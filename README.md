# Communication-Network-
It is so simple communication network between group of friends that all the friends will actually do is send a contact message to one or more people in the group, and then wait for a confirmation reply from that person. 

## output
The “master” process will be the initial process that spawns one process for each of the people in the “calls.txt” file. So, in our
little example above, there will be 6 processes in total: the master and 5 friends.To confirm the validity of the program, each person receiving a contact request – either an initial request or a response – must send a message to the master process to inform it about the exchange.


## Compile the Erlang program
In command prompt execute following command,
> erlc exchange.erl
> erlc calling.erl

## Execute the Erlang Program
> erl -noshell -s exchange start

