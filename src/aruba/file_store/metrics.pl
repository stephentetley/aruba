/*
    metrics.pl
    Copyright (c) Stephen Tetley 2018,2019
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

user:file_search_path(aruba_base, '../base').

:- use_module(aruba_base(base_utils)).
:- use_module(aruba_base(base_traversals)).
:- use_module(structs).



% count_files

count_files_aux(file_object(_,_,_,_), A, A1) :- 
    A1 is A + 1.

count_files_aux(_, A, A).


/* count_files(Fs, Count) :- 
    is_file_store(Fs),
    file_store_kids(Fs,Kids),
    alltd_trafo(count_files_aux, Kids, 0, Count), !. */

count_files(Fo, Count) :- 
    alltd_trafo(count_files_aux, Fo, 0, Count), !.

% count_folders

count_folders_aux(folder_object(_,_,_,_), A, A1) :- 
    A1 is A + 1.

count_folders_aux(_, A, A).


count_folders(Fo,Count) :- 
    alltd_trafo(count_folders_aux, Fo, 0, Count), !.    

% count_kids
% counts both files and folders.

% It is not ideal passing an arity three predicate around and ignoring one argument
% It means users must always remember which argument is the accumulator.
count_kids_aux(folder_object(_,_,_,_), Acc, N) :- 
    N is Acc + 1.

count_kids_aux(file_object(_,_,_,_), Acc, N) :- 
    N is Acc + 1.

count_kids_aux(_, Acc, Acc).


count_kids(Fo, Count) :- 
    alltd_trafo(count_kids_aux, Fo, 0, Count), !.



% store_size

store_size_aux(file_object(_,_,_,Sz), Acc, N) :- 
    N is Acc + Sz.

store_size_aux(_, A, A).


store_size(Store, Size) :-
    alltd_trafo(store_size_aux, Store, 0, Size), !.


% latest_modification_time

latest(Stamp1, Stamp2, Latest) :-
    Latest is max(Stamp1, Stamp2).

latest_modification_aux(file_object(_, Stamp, _, _), T0, T) :-
    iso_8601_stamp(Stamp, T1), 
    latest(T0, T1, T).

latest_modification_aux(folder_object(_, Stamp, _, _), T0, T) :- 
    iso_8601_stamp(Stamp, T1),
    latest(T0, T1, T).

latest_modification_time(Store, Stamp) :-
    alltd_trafo(latest_modification_aux, Store, 0, Stamp), !.



% earliest_modification_time

earliest(Stamp1, Stamp2, Earliest) :-
    ( number(Stamp1) -> 
        Earliest is min(Stamp1, Stamp2)
    ; Earliest is Stamp2
    ).



earliest_modification_aux(file_object(_, Stamp, _, _), T0, T) :-
    iso_8601_stamp(Stamp, T1), 
    earliest(T0, T1, T).

earliest_modification_aux(folder_object(_, Stamp, _, _), T0, T) :- 
    iso_8601_stamp(Stamp, T1),
    earliest(T0, T1, T).

earliest_cast(Stamp0, Stamp) :-
    ( number(Stamp0) ->
        Stamp is Stamp0
    ; Stamp is 0
    ).


earliest_modification_time(Store, Stamp) :-
    alltd_trafo(earliest_modification_aux, Store, zero, S0), 
    earliest_cast(S0, Stamp), !.

