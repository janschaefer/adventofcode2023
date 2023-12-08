-module(main).
-import(io,[fwrite/1]).
-export([start/0]).

readlines(FileName) ->
  {ok, Device} = file:open(FileName, [read]),
  try get_all_lines(Device)
    after file:close(Device)
  end.

get_all_lines(Device) ->
  case io:get_line(Device, "") of
      eof  -> [];
      Line -> Line ++ get_all_lines(Device)
  end.

createCardMap([], Map) -> Map;
createCardMap([C | Tail], Map) ->
  case maps:is_key(C, Map) of
      true ->
        CurrentValue = maps:get(C, Map),
        createCardMap(Tail, maps:put(C, CurrentValue + 1, Map));
      false ->
        createCardMap(Tail, maps:put(C, 1, Map))
  end.

basicValue(C) ->
  case C of 
    $A -> 14;
    $K -> 13;
    $Q -> 12;
    $J -> 11;
    $T -> 10;
    $9 -> 9;
    $8 -> 8;
    $7 -> 7;
    $6 -> 6;
    $5 -> 5;
    $4 -> 4;
    $3 -> 3;
    $2 -> 2
  end.


calculateValue(SortedCards) ->
  Map = createCardMap(SortedCards, #{}),
  Result = lists:map( fun (Key) -> 
          Value = math:pow(10, 1 + maps:get(Key, Map)),
          %io:format("Value: ~p~n", [Value]),
          Value end, maps:keys(Map)),
  lists:foldl( fun(X, Acc) -> X + Acc end, 0, Result)
  .


hasSmallerFirstChar([],[]) -> false;
hasSmallerFirstChar([Char1 | Rest1], [Char2 | Rest2]) ->
  case Char1 of
      Char2 -> hasSmallerFirstChar(Rest1, Rest2);
      _ -> 
        basicValue(Char1) < basicValue(Char2)
  end.

process_line(Line) ->
  Parts = string:split(Line, " "),
  Hand = lists:nth(1, Parts),
  {Bid, _} = string:to_integer(lists:nth(2, Parts)),
  SortedCards = lists:sort(Hand),
  Value = calculateValue(SortedCards),
  {Value, Hand, Bid}
  .

rankedSum([], _, Sum) -> Sum;
rankedSum([Head | Tail], Rank, Sum) ->
  {_, _, Bid} = Head,
  rankedSum(Tail, Rank + 1, Sum + Rank * Bid).

solve(FileName) ->
  Lines = string:split(readlines(FileName), "\n", all),
  %io:format("~p~n", [Lines]).
  ProcessedLines = lists:map(fun process_line/1, Lines),
  Ranked = lists:sort(fun (A, B) -> 
      {ValueA, HandA, _} = A,
      {ValueB, HandB, _} = B,
      case ValueA of 
        ValueB -> 
          hasSmallerFirstChar(HandA, HandB);
        _ ->
          ValueA < ValueB
      end
    end, ProcessedLines),
  RankedSum = rankedSum(Ranked, 1, 0),
  io:format("Ranked Sum: ~p~n", [RankedSum]).


basicValue2(C) ->
  case C of 
    $A -> 14;
    $K -> 13;
    $Q -> 12;
    $J -> 1;
    $T -> 10;
    $9 -> 9;
    $8 -> 8;
    $7 -> 7;
    $6 -> 6;
    $5 -> 5;
    $4 -> 4;
    $3 -> 3;
    $2 -> 2
  end.
  

applyJoker(Map) ->
  case maps:is_key($J, Map) of
  true -> 
    Joker = maps:get($J, Map),
    MapWithoutJoker = maps:remove($J, Map),
  
    case maps:size(MapWithoutJoker) of
        0 -> Map;
        _ ->
          [ HighestKey | _ ] = lists:sort( 
              fun (K1, K2) -> 
                maps:get(K1, MapWithoutJoker) > maps:get(K2, MapWithoutJoker) 
              end, 
              maps:keys(MapWithoutJoker) ),
          HighestValue = maps:get(HighestKey, MapWithoutJoker),
          AppliedJoker = maps:put(HighestKey, HighestValue + Joker, MapWithoutJoker),
          AppliedJoker
      end;
  false ->
    Map
  end
  .
  

calculateValue2(SortedCards) ->
  Map = createCardMap(SortedCards, #{}),
  %io:format("Map: ~p~n", [Map]),
  MapWithJokerApplied = applyJoker(Map),
  %io:format("JokerMap: ~p~n", [MapWithJokerApplied]),
  Result = lists:map( fun (Key) -> 
          Value = math:pow(10, 1 + maps:get(Key, MapWithJokerApplied)),
          %io:format("Value: ~p~n", [Value]),
          Value end, maps:keys(MapWithJokerApplied)),
  lists:foldl( fun(X, Acc) -> X + Acc end, 0, Result)
  .

hasSmallerFirstChar2([],[]) -> false;
hasSmallerFirstChar2([Char1 | Rest1], [Char2 | Rest2]) ->
  case Char1 of
      Char2 -> hasSmallerFirstChar2(Rest1, Rest2);
      _ -> 
        basicValue2(Char1) < basicValue2(Char2)
  end.

process_line2(Line) ->
  Parts = string:split(Line, " "),
  Hand = lists:nth(1, Parts),
  {Bid, _} = string:to_integer(lists:nth(2, Parts)),
  SortedCards = lists:sort(Hand),
  Value = calculateValue2(SortedCards),
  {Value, Hand, Bid}
  .

solve2(FileName) ->
  Lines = string:split(readlines(FileName), "\n", all),
  %io:format("~p~n", [Lines]).
  ProcessedLines = lists:map(fun process_line2/1, Lines),
  Ranked = lists:sort(fun (A, B) -> 
      {ValueA, HandA, _} = A,
      {ValueB, HandB, _} = B,
      case ValueA of 
        ValueB -> 
          hasSmallerFirstChar2(HandA, HandB);
        _ ->
          ValueA < ValueB
      end
    end, ProcessedLines),
  %io:format("Ranked: ~p~n", [Ranked]),
  RankedSum = rankedSum(Ranked, 1, 0),
  io:format("Ranked Sum: ~p~n", [RankedSum]).


start() ->
  solve("input"),
  solve2("input")
  .

