/*
    traversals.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/    


:- module(traversals, 
            [ everywhere/4 
            ]).


:- use_module(aruba/file_store/structs).

:- meta_predicate
    everywhere(3,+,+,-).

% TODO 
% Implement a suite of traversals (c.f Stratego, Strafunski, KURE, ...).

everywhere_list(_, [], A, A).

everywhere_list(Goal, [X0|Xs], A0, A) :-
    everywhere_aux(Goal, X0, A0, A1),
    everywhere_list(Goal, Xs, A1, A).
    
everywhere_aux(Goal, Fo, A0, A) :- 
    Fo = file_object(_,_,_,_),
    call(Goal, Fo, A0, A).

everywhere_aux(Goal, Fo, A0, A) :- 
    Fo = folder_object(_,_,_,Kids),
    call(Goal, Fo, A0, A1),
    everywhere_list(Goal, Kids, A1, A).

everywhere(Goal, Fo, Init, Answer) :- 
    file_store_kids(Fo, Kids),
    everywhere_list(Goal, Kids, Init, Answer).

