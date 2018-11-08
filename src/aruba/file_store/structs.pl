% structs.pl

:- module(structs, 
            [ file_object_data/3
            , make_file_object/3
            , file_object_name/2
            , file_object_modification_time/2
            , file_object_mode/2
            , file_object_size/2
            , folder_object_data/3
            , make_folder_object/3
            , folder_object_name/2
            , folder_object_modification_time/2
            , folder_object_mode/2
            , folder_object_kids/2
            , file_store_path/2
            , file_store_elements/2            
            ]).

:- use_module(library(record)).


:- record file_object(name:text=none, modification_time:text=none, mode:text=none, size:integer=0).

:- record folder_object(name:text=none, modification_time:text=none, mode:text=none, kids:list=[]).

:- record file_store(path:text=none, elements:list=[]).
