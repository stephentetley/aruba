/*
    traversals.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   



:- object(file_store_traversals,
    implements([rewritep, transformp]),
    imports([rewrite, transform])).

    % implements all_rewrite
    all_rewrite(R1, Input, Ans) :- 
        Input = folder_object(Name, ModificationTime, Mode, Kids),
        ::all_rewrite_list(R1, Kids, Kids1),
        Ans = folder_object(Name, ModificationTime, Mode, Kids1),
        !.

    all_rewrite(_, Ans, Ans) :-
        Ans = file_object(_, _, _, _).

    all_rewrite(R1, Input, Ans) :- 
        Input = file_store(Path, Kids),
        ::all_rewrite_list(R1, Kids, Kids1),
        Ans = file_store(Path, Kids1),
        !.

    % implements one_rewrite
    any_rewrite(R1, Input, Ans) :- 
        Input = folder_object(Name, ModificationTime, Mode, Kids),
        ::any_rewrite_list(R1, Kids, Kids1),
        Ans = folder_object(Name, ModificationTime, Mode, Kids1),
        !.
    
        any_rewrite(_, Ans, Ans) :-
        Ans = file_object(_, _, _, _).
    
        any_rewrite(R1, Input, Ans) :- 
        Input = file_store(Path, Kids),
        ::any_rewrite_list(R1, Kids, Kids1),
        Ans = file_store(Path, Kids1),
        !.

    % implements one_rewrite
    one_rewrite(R1, Input, Ans) :- 
        Input = folder_object(Name, ModificationTime, Mode, Kids),
        ::one_rewrite_list(R1, Kids, Kids1),
        Ans = folder_object(Name, ModificationTime, Mode, Kids1),
        !.
    
    one_rewrite(_, Ans, Ans) :-
        Ans = file_object(_, _, _, _).
    
    one_rewrite(R1, Input, Ans) :- 
        Input = file_store(Path, Kids),
        ::one_rewrite_list(R1, Kids, Kids1),
        Ans = file_store(Path, Kids1),
        !.

    % implements all_transform
    :- meta_predicate(all_transform(3, *, *, *)).
    
    all_transform(T1, Input, Acc, Ans) :- 
        Input = folder_object(_, _, _, Kids),
        ::all_transform_list(T1, Kids, Acc, Ans),
        !.

    all_transform(_, Input, Ans, Ans) :-
        Input = file_object(_, _, _, _).         

    all_transform(T1, Input, Acc, Ans) :- 
        Input = file_store(_, Kids),
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

