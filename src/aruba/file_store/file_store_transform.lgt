/*
    file_store_transform.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   



:- object(file_store_transform,
    implements([transformp]),
    imports([transform])).

    % implements all_transform
    
    all_transform(T1, Input, Acc, Ans) :- 
        Input = folder_object(_, _, _, Kids),
        writeln("Folder"),
        ::all_transform_list(T1, Kids, Acc, Ans),
        !.

    all_transform(_, Input, Ans, Ans) :-
        Input = file_object(_, _, _, _), 
        writeln("File").

    all_transform(T1, Input, Acc, Ans) :- 
        Input = file_store(_, Kids),
        writeln("Store"),
        ::all_transform_list(T1, Kids, Acc, Ans),
        !.

    % implements all_transform
    one_transform(T1, Input, Acc, Ans) :- 
        Input = folder_object(_, _, _, Kids),
        ::one_transform_list(T1, Kids, Acc, Ans),
        !.

    one_transform(_, Input, Ans, Ans) :-
        Input = file_object(_, _, _, _).         

    one_transform(T1, Input, Acc, Ans) :- 
        Input = file_store(_, Kids),
        ::one_transform_list(T1, Kids, Acc, Ans),
        !.

:- end_object. 

