/*
    metrics.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/    

:- module(metrics, 
            [ count_files/2
            , count_folders/2
            , count_kids/2
            , store_size/2
            , latest_modification_time/2
            , earliest_modification_time/2
            ]).

:- use_module(aruba/base/base_utils).
:- use_module(aruba/base/base_traversals).
:- use_module(aruba/file_store/structs).
:- use_module(aruba/file_store/traversals).

% TODO 
% As my Prolog improves the metrics should be implemented using generic 
% traversals (c.f Stratego, Strafunski, KURE, ...).

% count_files

count_files_aux(A, file_object(_,_,_,_), A1) :- 
    A1 is A + 1.

count_files_aux(A, _, A).


count_files(Fo,Count) :- 
    everywhere(count_files_aux, Fo, 0, Count), !.

% count_files

count_folders_aux(A, folder_object(_,_,_,_), A1) :- 
    A1 is A + 1.

count_folders_aux(A, _, A).


count_folders(Fo,Count) :- 
    everywhere(count_folders_aux, Fo, 0, Count), !.

% count_kids
% counts both files and folders.

% It is not ideal passing an arity three predicate around and ignoring one argument
% It means users must always remember which argument is the accumulator.
count_kids_aux(Acc, _, N) :- 
    N is Acc + 1.

count_kids_old(Fo,Count) :- 
    everywhere(count_kids_aux, Fo, 0, Count), !.

count_kids(Fo, Count) :- 
    alltd_trafo(attempt_trafo(count_kids_aux), Fo, 0, Count), !.



% store_size

store_size_aux(Acc, file_object(_,_,_,Sz), N) :- 
    N is Acc + Sz.

store_size_aux(A, _, A).


store_size(Store, Size) :-
    everywhere(store_size_aux, Store, 0, Size), !.


% latest_modification_time

latest(Stamp1, Stamp2, Latest) :-
    Latest is max(Stamp1, Stamp2).

latest_modification_aux(T0, file_object(_, Stamp, _, _), T) :-
    iso_8601_stamp(Stamp, T1), 
    latest(T0, T1, T).

latest_modification_aux(T0, folder_object(_, Stamp, _, _), T) :- 
    iso_8601_stamp(Stamp, T1),
    latest(T0, T1, T).

latest_modification_time(Store, Stamp) :-
    everywhere(latest_modification_aux, Store, 0, Stamp), !.



% earliest_modification_time

earliest(Stamp1, Stamp2, Earliest) :-
    ( number(Stamp1) -> 
        Earliest is min(Stamp1, Stamp2)
    ; Earliest is Stamp2
    ).



earliest_modification_aux(T0, file_object(_, Stamp, _, _), T) :-
    iso_8601_stamp(Stamp, T1), 
    earliest(T0, T1, T).

earliest_modification_aux(T0, folder_object(_, Stamp, _, _), T) :- 
    iso_8601_stamp(Stamp, T1),
    earliest(T0, T1, T).

earliest_cast(Stamp0, Stamp) :-
    ( number(Stamp0) ->
        Stamp is Stamp0
    ; Stamp is 0
    ).


earliest_modification_time(Store, Stamp) :-
    everywhere(earliest_modification_aux, Store, 'zero', S0), 
    earliest_cast(S0, Stamp), !.

