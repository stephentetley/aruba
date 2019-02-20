% record_test2.pl


:- use_module(library(record)).


% How do we encode cases?
% oneof is one possibilty

:- record folder_object(name:string, kids=list(oneof([folder_object,file_object]))).

:- record file_object(name:string, size:integer=0).

example1(
    folder_object("src", 
        [ folder_object("aruba", [])
        , file_object("main.pl", 1000)
        , file_object("test.pl", 100)
        ])).

demo01 :- 
    example1(Src),
    is_folder_object(Src).

demo02(Xs):- 
    example1(Src),
    folder_object_kids(Src,Xs).

