/*
    traversals.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/    

:- module(traversals, 
            [ identity_rewrite/2
            , fail_rewrite/1
            , seq_rewrite/4
            , choose_rewrite/4
            , all_rewrite/3
            , try_rewrite/3
            , alltd_rewrite/3
            , allbu_rewrite/3
            ]).

:- meta_predicate
    seq_rewrite(2,+,-),
    choose_rewrite(2,+,-), 
    all_rewrite(2,+,-),
    try_rewrite(2,+,-),
    alltd_rewrite(2,+,-),
    allbu_rewrite(2,+,-).


identity_rewrite(Ans, Ans).


fail_rewrite(_) :- false.


seq_rewrite(R1, R2, Input, Ans) :-
    call(R1, Input, A1),
    call(R2, A1, Ans).


choose_rewrite(R1, R2, Input, Ans) :-
    catch(call(R1,Input,Ans), 
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


try_rewrite(R1, Input, Ans) :-
    choose_rewrite(R1, identity_rewrite, Input, Ans).


alltd_rewrite(R1, Input, Ans) :-
    choose_rewrite(R1, all_rewrite(alltd_rewrite(R1)), Input, Ans).


allbu_rewrite(R1, Input, Ans) :-
    choose_rewrite(all_rewrite(allbu_rewrite(R1)), R1, Input, Ans).