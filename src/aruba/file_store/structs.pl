/*
    structs.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/   

:- module(structs, 
            [ is_file_object/1
            , file_object_data/3
            , make_file_object/3
            , file_object_name/2
            , file_object_modification_time/2
            , file_object_mode/2
            , file_object_size/2
            , is_folder_object/1
            , folder_object_data/3
            , make_folder_object/3
            , folder_object_name/2
            , folder_object_modification_time/2
            , folder_object_mode/2
            , folder_object_kids/2
            , file_store_path/2
            , file_store_kids/2
            , file_object_modification_timestamp/2            
            , folder_object_modification_timestamp/2
            ]).

:- use_module(library(record)).

:- use_module(aruba/base/utils).


:- record file_object(name:text=none, modification_time:text=none, mode:text=none, size:integer=0).

:- record folder_object(name:text=none, modification_time:text=none, mode:text=none, kids:list=[]).

:- record file_store(path:text=none, kids:list=[]).


% file_object(file_object(_,_,_,_)).

% is_file_object(file_object(_,_,_,_)).

% is_folder_object(folder_object(_,_,_,_)).


% Additional accessors

file_object_modification_timestamp(Fo,Stamp) :- 
    file_object_modification_time(Fo,Text),
    iso_8601_stamp(Text,Stamp).

folder_object_modification_timestamp(Fo,Stamp) :- 
    folder_object_modification_time(Fo,Text),
    iso_8601_stamp(Text,Stamp).
