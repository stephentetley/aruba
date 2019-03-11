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
            , set_file_object_field/3
            , set_file_object_fields/3
            , cons_file_object/5

            , is_folder_object/1
            , folder_object_data/3
            , make_folder_object/3
            , folder_object_name/2
            , folder_object_modification_time/2
            , folder_object_mode/2
            , folder_object_kids/2
            , set_folder_object_field/3
            , set_folder_object_fields/3
            , cons_folder_object/5

            , is_file_store/1
            , file_store_path/2
            , file_store_kids/2
            , set_file_store_field/3
            , set_file_store_fields/3
            , cons_file_store/3

            , file_object_modification_timestamp/2            
            , folder_object_modification_timestamp/2
            ]).

user:file_search_path(aruba_base, '../base').

:- use_module(library(record)).

:- use_module(aruba_base(base_utils)).


:- record file_object(name:text=none, modification_time:text=none, mode:text=none, size:integer=0).

:- record folder_object(name:text=none, modification_time:text=none, mode:text=none, kids:list=[]).

:- record file_store(path:text=none, kids:list=[]).


cons_file_object(Name, Timestamp, Mode, Size, Ans) :- 
    make_file_object([ name(Name), modification_time(Timestamp)
                     , mode(Mode), size(Size)], Ans).



cons_folder_object(Name, Timestamp, Mode, Kids, Ans) :- 
    make_folder_object([ name(Name), modification_time(Timestamp)
                       , mode(Mode), kids(Kids)], Ans).



cons_file_store(Path, Kids, Ans) :- 
    make_file_store([ path(Path), kids(Kids)], Ans).

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
