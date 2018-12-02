/*
    traversals.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/    


:- module(traversals, 
            [ seq_accum/5
            , seq_zero/3
            , choose_accum/5
            , choose_zero/3
            , everywhere/4 
            , onelayer/4
            ]).


:- use_module(aruba/file_store/structs).

% See SWI Manual section 6.4 Deining a meta-predicate

:- meta_predicate
    everywhere(3,+,+,-), 
    onelayer(3,+,+,-).


% 

seq_accum(Goal1, Goal2, Object, Init, Ans) :-
    call(Goal1, Object, Init, A1),
    call(Goal2, Object, A1, Ans).

seq_zero(Goal1, Goal2, Object) :-
    call(Goal1, Object),
    call(Goal2, Object).

choose_accum(Goal1, Goal2, Object, Init, Ans) :-
    ( call(Goal1,Object,Init,A0) ->
        Ans = A0
    ; 
        call(Goal2, Object, Init, A1), 
        Ans = A1
    ). 

choose_zero(Goal1, Goal2, Object) :-
    (call(Goal1,Object) ->
        !
    ;   call(Goal2,Object)
    ).   


% TODO 
% Implement a suite of traversals (c.f Stratego, Strafunski, KURE, ...).

% TODO 
% Handle failure appropriately

% everywhere considered deprecated - we should be moving to use base_traversals.


everywhere_list([], _, A, A).

everywhere_list([X0|Xs], Goal, A0, A) :-
    everywhere_aux(X0, Goal, A0, A1),
    everywhere_list(Xs, Goal, A1, A).
    
everywhere_aux(Fo, Goal, A0, A) :- 
    Fo = file_object(_,_,_,_),
    call(Goal, A0, Fo, A).

everywhere_aux(Fo, Goal, A0, A) :- 
    Fo = folder_object(_,_,_,Kids),
    call(Goal, A0, Fo, A1),
    everywhere_list(Kids, Goal, A1, A).

everywhere(Goal, Store, Init, Answer) :- 
    file_store_kids(Store, Kids),
    everywhere_list(Kids, Goal, Init, Answer).


% Naming note - onelayer is accumulating.

onelayer_list(_, [], A, A).

onelayer_list(Goal, [X|Xs], A0, A) :-
    call(Goal, X, A0, A1),
    onelayer_list(Goal, Xs, A1, A).

onelayer(Goal, Fo, Init, Answer) :- 
    file_store_kids(Fo, Kids),
    onelayer_list(Goal, Kids, Init, Answer), !.
