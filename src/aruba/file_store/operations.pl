% operations.pl

:- module(operations, 
            [ sub_stores/2
            ]).

:- use_module(library(apply)).
:- use_module(library(yall)). 

:- use_module(aruba/file_store/structs).


extend_path(Root,Child,Path) :- 
    string_concat(Root, "\\", S0),
    string_concat(S0, Child, Path).
    
sub_stores_aux(Root, folder_object(Path0, _, _,Kids), Store) :-
    extend_path(Root, Path0, Path),
    Store = file_store(Path, Kids).

sub_stores(file_store(Path,Kids), Stores) :- 
    convlist({Path}/[Fo,Store] >> sub_stores_aux(Path,Fo, Store), Kids, Stores).