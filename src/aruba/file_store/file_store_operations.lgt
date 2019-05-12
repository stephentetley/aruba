/*
    file_store_operations.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- use_module(library(pcre)).
:- use_module(library(http/json)).

:- object(file_store_operations).


    encode_file_store(file_object(Name, ModTime, Mode, Size), Ans) :- 
        Ans = file{ tag:"file", name:Name, modification_time:ModTime, mode:Mode, size:Size }.

    encode_file_store(folder_object(Name, ModTime, Mode, Kids), Ans) :- 
        meta::map([X,Y] >> encode_file_store(X,Y), Kids, Kids1),
        Ans = folder{ tag:"folder", name:Name, modification_time:ModTime, mode:Mode, kids:Kids1 }.

    encode_file_store(file_store(Path, Kids), Ans) :- 
        meta::map([X,Y]>> encode_file_store(X,Y), Kids, Kids1),
        Ans = file_store{ tag:"file_store", path:Path, kids:Kids1 }.

    :- public (json_write_file_store/2).        
    json_write_file_store(Dst, Tree) :- 
        encode_file_store(Tree, Dict),
        open(Dst, write, Stream),
        json::json_write_dict(Stream, Dict), 
        close(Stream).

    decode_file_object(Dict, Ans) :- 
        Ans = file_object(Dict.name, Dict.modification_time, Dict.mode, Dict.size).

    decode_folder_object(Dict, Ans) :- 
        meta::map([X,Y] >> decode_file_store(X,Y), Dict.kids, Kids1),
        Ans = folder_object(Dict.name, Dict.modification_time, Dict.mode, Kids1).

    decode_file_store(Dict, Ans) :-
        (   Dict.tag = "file" ->
            decode_file_object(Dict, Ans)
        ;   Dict.tag = "folder" -> 
            decode_folder_object(Dict, Ans)
        ;   Dict.tag = "file_store" -> 
            meta::map([X,Y] >> decode_file_store(X,Y), Dict.kids, Kids1),
            Ans = file_store(Dict.path, Kids1)
        ;   false
        ).


    :- public (json_read_file_store/2). 
    json_read_file_store(Src, Ans):-
        open(Src, read, Stream),
        json::json_read_dict(Stream, Dict),
        close(Stream), 
        decode_file_store(Dict, Ans).




    :- public(modification_timestamp/2).
    modification_timestamp(Fo,Stamp) :- 
        file_store_structs::is_file_object(Fo), !,
        file_store_structs::file_object_modification_time(Fo,Text),
        base_utils::iso_8601_stamp(Text,Stamp).
    
    modification_timestamp(Fo,Stamp) :- 
        file_store_structs::is_folder_object(Fo), !,
        file_store_structs::folder_object_modification_time(Fo,Text),
        base_utils::iso_8601_stamp(Text,Stamp).

    % Does not return dot
    :- public(file_object_extension/2).
    file_object_extension(Fo, Extension) :-
        file_store_structs::file_object_name(Fo, FileName),
        pcre::re_matchsub("\\.([^\\.]+)\\Z"/s, FileName, Dict, []),
        get_dict(1, Dict, Extension).



:- end_object.		