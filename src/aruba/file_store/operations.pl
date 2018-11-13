/*
    operations.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/   

:- module(operations, 
            [ sub_stores/2
            , file_store_name/2
            , get_extension/2
            ]).

:- use_module(library(apply)).
:- use_module(library(lists)).
:- use_module(library(yall)). 
:- use_module(library(pcre)).

:- use_module(aruba/file_store/structs).



extend_path(Root,Child,Path) :- 
    string_concat(Root, "\\", S0),
    string_concat(S0, Child, Path).
    
sub_stores_aux(Root, folder_object(Path0, _, _,Kids), Store) :-
    extend_path(Root, Path0, Path),
    Store = file_store(Path, Kids).


% sub_stores
sub_stores(file_store(Path,Kids), Stores) :- 
    convlist({Path}/[Fo,Store] >> sub_stores_aux(Path,Fo, Store), Kids, Stores).

% , file_store_path/2

file_store_name(Store,Name) :-
    file_store_path(Store,Path),
    split_string(Path, "\\", "", Xs),
    last(Xs,Name).

file_object(file_object(_,_,_,_)).

get_extension_aux(FileName, Ans) :- 
    re_matchsub("(?:\\.)(?<ext>[^\\.]+)$", FileName, Dict, []),
    get_dict('ext', Dict, Ans).

get_extension(Fo,Ext) :- 
    file_object(Fo),
    file_object_name(Fo, Name),
    get_extension_aux(Name, Ext).

% base name of a "singular" file name (i.e no path info at the left).
get_basename(FileName, Ans) :- 
    re_matchsub("(?<base>.*)(?:\\.)(?<ext>[^\\.]+)$", FileName, Dict, []),
    get_dict('base',Dict,Ans).