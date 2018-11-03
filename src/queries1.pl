% queries1.pl

:- use_module(library(yall)).

:- use_module(aruba/file_store/structs).



file_sys(
    [ file_object('Chamber 001.JPG', properties("2018-06-29T11:05:00", '-a---'), 295132)
    , file_object('Chamber 002.JPG', properties("2018-06-29T11:06:00", '-a---'), 108821)
    ]).


demo01(Xs) :- 
    file_sys(Xs).

demo02_aux([X|_], T) :- 
    file_object_props(X,Props), 
    properties_modification_time(Props,T).

demo02(T) :- 
    file_sys(Xs),
    demo02_aux(Xs,T).

proc(FO) :- 
    file_object_props(FO,Props), 
    properties_modification_time(Props,T), 
    writeln(T).


    

dummy :- 
    file_sys(Objects), 
    maplist(proc, Objects).

dummy2 :- 
    file_sys(Objects), 
    maplist([X] >> proc(X), Objects).


procT(FO,T) :- 
    file_object_props(FO,Props), 
    properties_modification_time(Props,T). 

all_times(Ts) :- 
    file_sys(Objects), 
    convlist([FO,T] >> procT(FO,T), Objects, Ts).


all_times_no_aux(Ts) :- 
    file_sys(Objects), 
    convlist([FO,T] >> (file_object_props(FO,Props), 
                         properties_modification_time(Props,T)), Objects, Ts).





