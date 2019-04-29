/*
    file_store_transform.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   



:- object(file_store_transform,
    implements([transformp]),
    imports([transform])).

    % implements all_transform
    :- meta_predicate(all_transform(3, *, *, *)). 
    all_transform(Closure, Input, Acc, Ans) :- 
        Input = folder_object(_, _, _, Kids),
        ::all_transform_list(Closure, Kids, Acc, Ans),
        !.

    all_transform(_, Input, Ans, Ans) :-
        Input = file_object(_, _, _, _), 
        !.

    all_transform(Closure, Input, Acc, Ans) :- 
        Input = file_store(_, Kids),
        ::all_transform_list(Closure, Kids, Acc, Ans),
        !.

    % implements all_transform
    :- meta_predicate(one_transform(3, *, *, *)). 
    one_transform(Closure, Input, Acc, Ans) :- 
        Input = folder_object(_, _, _, Kids),
        ::one_transform_list(Closure, Kids, Acc, Ans),
        !.

    one_transform(_, Input, Ans, Ans) :-
        Input = file_object(_, _, _, _), 
        !.

    one_transform(Closure, Input, Acc, Ans) :- 
        Input = file_store(_, Kids),
        ::one_transform_list(Closure, Kids, Acc, Ans),
        !.

:- end_object. 

