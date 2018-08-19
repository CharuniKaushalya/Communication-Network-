%%%-------------------------------------------------------------------
%%% @author kaushi
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Jun 2018 11:39 AM
%%%-------------------------------------------------------------------
-module(calling).
-author("kaushi").

%% API
-export([loop/2]).

loop(Person, Master) ->
  receive
    {From, intro, MicroSec} ->
     %% io:format("~p received intro message from ~p ~p~n", [Person, From, [MicroSec]]),
      Master ! {reply, From, Person, MicroSec},
      loop(Person, Master);
    {Me, intro} ->
      {_MS, _Sec, MicroSec} = erlang:now(),
      io:format("~p received intro message from ~p ~p~n", [Me, Person, [MicroSec]]),
      Master ! {reply, Me, Person, MicroSec},
      loop(Person, Master);
     Other ->
      io:format("Invalid format: ~p~n", [Other]),
      Master ! {self(), {error,Other}},
      loop(Person, Master)
    after 1000 ->
    Master ! {terminate, Person}

  end.





