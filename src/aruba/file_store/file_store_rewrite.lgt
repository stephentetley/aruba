/*
    file_store_rewrite.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   



:- object(file_store_rewrite,
    implements([rewritep]),
    imports([rewrite])).

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


:- end_object. 

