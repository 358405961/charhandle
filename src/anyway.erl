#!/usr/local/bin/escript

main([Input, Output, WordsFile, LetterFile]) ->
    try
        WordsEts = ets:new(wordsets, [bag]),
        LetterEts = ets:new(lettersets, [bag]),
        ets_build(WordsFile, WordsEts, words),
        ets_build(LetterFile, LetterEts, letter),
        {ok, InputFd} = file:open(Input, [read, {encoding, utf8}]),
        {ok, OutputFd} = file:open(Output, [write, binary]),
        ok = file_handle(InputFd, OutputFd, WordsEts, LetterEts),
        file:close(InputFd),
        file:close(OutputFd),
        ok
    catch
        Err -> io:format("~p~n", [erlang:get_stacktrace()])
    end.


ets_build(File, Ets, Type) ->
        {ok, Fd} = file:open(File, [read, {encoding, utf8}]),
        ok = 
        case Type of
            words -> words_ets_build(Fd, Ets);
            _ -> letter_ets_build(Fd, Ets)
        end,
        file:close(Fd).

letter_ets_build(LetterFd, LetterEts) ->
    case file:read_line(LetterFd) of
        {ok, Line} ->
            [W, L] = string:tokens(Line, [32, 13, 10, 9]), 
            ets:insert(LetterEts, {W, L}),
            letter_ets_build(LetterFd, LetterEts);
        eof -> ok;
        _ -> error
    end.

words_ets_build(WordsFd, WordsEts) ->
    case file:read_line(WordsFd) of
        {ok, Line} ->
            {W, P, L} = 
            case string:tokens(Line, [32, 13, 10, 9]) of
                [Word, Prop, Lvl] -> {Word, Prop, Lvl};
                [Word, Lvl] -> {Word, undefined, Lvl}
            end,
            ets:insert(WordsEts, {W, P, L}),
            words_ets_build(WordsFd, WordsEts);
        eof -> ok;
        _ -> error
    end.

file_handle(InputFd, OutputFd, WordsTab, LetterTab) ->
    case file:read_line(InputFd) of
        {ok, Line} ->
            {Word, WordList} = line_parse(Line),
            Exclude = line_handle(WordList, OutputFd, WordsTab, LetterTab),
            ELine = make_line(Exclude, []),
            case ELine of
                "\n" -> ok;
                _ -> ok = file:write(OutputFd, unicode:characters_to_binary(ELine))
            end,
            file_handle(InputFd, OutputFd, WordsTab, LetterTab);
        eof -> ok;
        _ -> error
    end.

make_line([], Acc) ->
    Acc++"\n";
make_line([{W, P} | Rest], Acc) ->
    make_line(Rest, W++"/"++P++" "++Acc).

line_parse(Line) ->
    L1 = string:tokens(Line, [32, 13, 10, 9]),
    [Word | L2] = L1,
    L3 = lists:map(fun(X) -> string:tokens(X, "/") end, L2),
    WordList = [{A, B} || [A, B] <- L3],
    {Word, WordList}.

line_handle(Line, Output, WordsTab, LetterTab) ->
    lists:foldl(fun({W, P}, Acc) -> 
                    case word_handle(W, P, WordsTab, LetterTab) of
                        true -> Acc;
                        _ -> [{W, P} | Acc]
                    end
                end, [], Line).

word_handle(Word, Prop, WordsTab, LetterTab) ->
    case prop_parse(Prop) of
        letter -> [] =/= ets:lookup(LetterTab, Word);
        any -> [] =/= ets:lookup(WordsTab, Word);
        "w" -> true;
        _ ->
            [] =/=
            lists:foldl(fun({X, Y, Z}, Acc) -> 
                            case Y of
                                undefined -> [{X, Y} | Acc];
                                _ ->
                                    case X =:= Word of
                                        true ->
                                            case lists:usort(Y++Prop) =:= lists:usort(Y) of
                                                true -> [{X, Y} | Acc];
                                                _ -> Acc
                                            end;
                                        _ -> Acc
                                    end
                            end
                        end, [], ets:lookup(WordsTab, Word))
%        [] =/= [{X, Y} || {X, Y, Z} <- ets:lookup(WordsTab, Word), ((Y =:= undefined) orelse ((X =:= Word) andalso ({match, _} = re:run(Prop, Y))))]
    end.

prop_parse("g") -> letter;
prop_parse("x") -> letter;
prop_parse("t") -> "n";
prop_parse("f") -> "n";
prop_parse("s") -> "n";
prop_parse("y") -> "u";
prop_parse("j") -> any;
prop_parse("l") -> any;
prop_parse("i") -> any;
prop_parse("z") -> any;
prop_parse("b") -> any;
prop_parse("") -> any;
prop_parse(P) -> P.
