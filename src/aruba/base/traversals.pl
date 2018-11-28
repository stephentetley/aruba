/*
    traversals.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/    

:- module(traversals, 
            [ identity/2
            , failure/1
            , sequence/4
            , choose/4
            , all_rewrite/3
            , all_trafo/4
            , try_rewrite/3
            , alltd_rewrite/3
            , allbu_rewrite/3
            ]).

:- meta_predicate
    sequence(2,+,-),
    choose(2,+,-), 
    all_rewrite(2,+,-),
    all_trafo(3,+,+,-),
    try_rewrite(2,+,-),
    alltd_rewrite(2,+,-),
    allbu_rewrite(2,+,-).


% In KURE R is a restriction of T where input and output types
% are the same


identity(Ans, Ans).


failure(_) :- false.


sequence(R1, R2, Input, Ans) :-
    call(R1, Input, A1),
    call(R2, A1, Ans).

% Turns false into error, obviously there will be a better way of writing this...
failcall(R1, Input, Ans) :-
    ( call(R1, Input, Ans), !
    ; throw(call_error())
    ).

choose(R1, R2, Input, Ans) :-
    catch(failcall(R1,Input,Ans), 
          _, 
          call(R2,Input,Ans)).


all_rewrite_aux(_,[],[]).

all_rewrite_aux(R1, [X|Xs], Ans) :-
    call(R1, X, A1),
    all_rewrite_aux(R1, Xs, A2),
    Ans = [A1|A2].
    
    
all_rewrite(R1, Input, Ans) :-
    Input =.. [Head|Kids],
    all_rewrite_aux(R1, Kids, Kids1), 
    Ans =.. [Head|Kids1], 
    !.

% Terminology trafo indicates a fold-like traversal.

all_trafo_aux(_, [], Init, Init).

all_trafo_aux(R1, [X|Xs], Init, Ans) :-
    call(R1, Init, X, A1),
    all_trafo_aux(R1, Xs, A1, Ans).

all_trafo(R1, Input, Init, Ans) :-
    Input =.. [_|Kids],
    all_trafo_aux(R1, Kids, Init, Ans), 
    !.    

try_rewrite(R1, Input, Ans) :-
    choose(R1, identity, Input, Ans).


alltd_rewrite(R1, Input, Ans) :-
    choose(R1, all_rewrite(alltd_rewrite(R1)), Input, Ans).


allbu_rewrite(R1, Input, Ans) :-
    choose(all_rewrite(allbu_rewrite(R1)), R1, Input, Ans).





% foldtd