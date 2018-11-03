% structs.pl

:- module(structs, 
            [ default_properties/1
            , properties_data/3
            , make_properties/2
            , properties_mode/2
            , properties_modification_time/2
            , file_object_data/3
            , make_file_object/3
            , file_object_name/2
            , file_object_props/2
            , file_object_size/2
            ]).

:- use_module(library(record)).

:- record properties(modification_time:text=none, mode:text=none).

:- record file_object(name:text=none, props:properties=none, size:integer=0).

