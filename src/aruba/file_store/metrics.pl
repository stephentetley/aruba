% metrics.pl

:- module(metrics, 
            [ count_kids/2
            , store_size/2
            , latest_modification_time/2
            ]).

:- use_module(aruba/base/utils).
:- use_module(aruba/file_store/structs).


% TODO 
% As my Prolog improves these should be implemented using generic 
% traversals (c.f Stratego / Strafunski, ...).

% count_kids
% counts both files and folders.

count_kids_list([X|Xs], N0, N) :-
    count_kids_aux(X,N0,N1),
    count_kids_list(Xs,N1,N).

count_kids_list([], N, N).


count_kids_aux(file_object(_,_,_,_), N0, N) :- 
    N is N0 + 1.

count_kids_aux(folder_object(_,_,_,Kids), N0, N) :- 
    N1 is N0 + 1,
    count_kids_list(Kids, N1, N).

count_kids(file_store(_,Xs), N) :- 
    count_kids_list(Xs, 0, N).


% store_size


size_kids_list([X|Xs], N0, N) :-
    size_kids_aux(X,N0,N1),
    size_kids_list(Xs,N1,N).

size_kids_list([], N, N).


size_kids_aux(file_object(_,_,_,Sz), N0, N) :- 
    N is N0 + Sz.

size_kids_aux(folder_object(_,_,_,Kids), N0, N) :- 
    size_kids_list(Kids, N0, N).

store_size(Store, N) :-
    file_store_kids(Store, Kids),
    size_kids_list(Kids, 0, N).

% latest_modification_time

latest(Stamp1, Stamp2, Latest) :-
    Latest is max(Stamp1, Stamp2).

latest_modification_list([X|Xs], T0, T) :-
    latest_modification_aux(X,T0,T1),
    latest_modification_list(Xs,T1,T).

latest_modification_list([], T, T).


latest_modification_aux(file_object(_, Stamp, _, _), T0, T) :-
    iso_8601_stamp(Stamp, T1), 
    latest(T0, T1, T).

latest_modification_aux(folder_object(_, Stamp, _, Kids), T0, T) :- 
    iso_8601_stamp(Stamp, T1),
    latest(T0,T1,T2),
    latest_modification_list(Kids, T2, T).

latest_modification_time(Store, T) :-
    file_store_kids(Store, Kids),
    latest_modification_list(Kids, 0, T).