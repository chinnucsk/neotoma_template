-module (packrat_parser_test).
-include_lib("eunit/include/eunit.hrl").

setup() ->
  ok.
  
teardown(_X) ->
  ok.

starting_test_() ->
  {spawn,
    {setup,
      fun setup/0,
      fun teardown/1,
      [
        fun test_simple_parsing/0,
        fun test_file_parsing/0
      ]
    }
  }.

test_simple_parsing() ->
  Matches = [
    ["bundle: hello\n", [{bundle, {command, "hello"}}]],
    ["bundle: 'hello'\n", [{bundle, {command, "'hello'"}}]],
    ["bundle: \"hello\"\n", [{bundle, {command, "\"hello\""}}]],
    ["bundle.before: \"world\"\n", [{bundle, {pre, "\"world\""}}]],
    ["bundle.after: lickity\n", [{bundle, {post, "lickity"}}]]
  ],
  lists:map(fun([H|T]) ->
    ?assertEqual(hd(T), packrat_parser:parse(H))
  end, Matches).

test_file_parsing() ->
  X = packrat_parser:file("config.conf"),
  Match = [{mount,{command,"\n  echo \"mounting\"\n"}},{bundle,[{command,"echo \"Bundle java stuff\""},{pre,"echo \"Before bundle\""},{post,"echo \"After bundle\""}]}],
  ?assertEqual(Match, X).