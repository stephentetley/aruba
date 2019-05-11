/*
    file_store_operations.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   



:- object(file_store_operations).


    :- public(modification_timestamp/2).
    modification_timestamp(Fo,Stamp) :- 
        file_store_structs::is_file_object(Fo),
        file_store_structs::file_object_modification_time(Fo,Text),
        base_utils::iso_8601_stamp(Text,Stamp).
    
    modification_timestamp(Fo,Stamp) :- 
        file_store_structs::is_folder_object(Fo),
        file_store_structs::folder_object_modification_time(Fo,Text),
        base_utils::iso_8601_stamp(Text,Stamp).

:- end_object.		