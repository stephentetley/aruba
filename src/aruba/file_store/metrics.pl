% metrics.pl

:- module(metrics, 
            [ count_kids/2
            ]).

:- use_module(aruba/file_store/structs).




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
