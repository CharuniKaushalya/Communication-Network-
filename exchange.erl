%%%-------------------------------------------------------------------
%%% @author kaushi
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Jun 2018 11:39 AM
%%%-------------------------------------------------------------------
-module(exchange).
-author("kaushi").

%% API
-export([start/0, receiver/0]).

start() ->
  io:format("** Calls to be made *~n"),
  {ok,Terms} = file:consult("calls.txt"), 	%%read file  %% plese add path to calls.txt
  Master = spawn(?MODULE, receiver, []),
  Processes = fun(N) ->
    {Person, List} = N,
    io:format("~p: ~p~n",[Person, List]),
	timer:sleep(round(timer:seconds(random:uniform(100))/1000)),
    Pid = spawn(calling, loop, [Person, Master]),
    [{Person, Pid}]
  end,
  Processlist = lists:flatmap(Processes, Terms),	%%get process id for each member of the group
  io:format("~n~n"),
  send_messages(Terms, Processlist, Master),
  process_started_successfully.

send_messages([H | List],Processlist, Master)->
  {From, ContactList } = H,
  lists:foreach(fun(N) ->
    To = findProcessId(N,Processlist),
    Master ! {To, intro, From,  N}
                end, ContactList),
  send_messages(List,Processlist,Master);
  
send_messages([],_Processlist,_Master)-> ok.

findProcessId(What, List) ->
  hd([ Value || {Key, Value} <- List, Key =:= What]).


receiver() ->
  receive
    {Pid, intro, From, To} ->
      {_MegaSec, _Sec, MicroSec} = erlang:now(),
      io:format("~p received intro message from ~p ~p~n", [To, From, [MicroSec]]),
      Pid ! {From, intro, MicroSec},
      receiver();
    {reply, To, From, MicroSeconds} ->
      io:format("~p received reply messaged from  ~p ~p~n",[To, From, [MicroSeconds]]),
      receiver();
    {terminate, Person} ->
      io:format("Process ~p has received no calls for 1 second, ending... ~n", [Person]),
      receiver();
    Else ->
      io:format("Invalid Format: ~p~n", [{Else}]),
      % Pid ! {self(), intro},
    receiver()
  after 1500 ->
    io:format("Master has received no replies for 1.5 second, ending...~n")
  end.

