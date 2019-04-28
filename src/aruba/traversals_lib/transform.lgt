/* 
    transform.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- category(transform).

    :- public(apply_transform/4).
    :- meta_predicate(apply_transform(3, *, *, *)).
    :- mode(apply_transform(+callable, +term, +term, -term), one).
    apply_transform(Goal1, Input, Acc, Ans) :-
        writeln("apply_transform"),
        catch( call(Goal1, Input, Acc, Ans),
            _,
            false).

    % all_transform_list_aux
    :- meta_predicate(all_transform_list_aux(*, 3, *, *)).
    all_transform_list_aux([], _, Ans, Ans).
        
    
    all_transform_list_aux([X|Xs], Goal1, Acc, Ans) :-
        apply_transform(Goal1, X, Acc, Acc1),
        all_transform_list_aux(Xs, Goal1, Acc1, Ans).


    % Transform all the elements in a list.
    :- public(all_transform_list/4).
    :- meta_predicate(all_transform_list(3, *, *, *)).
    :- mode(all_transform_list(+callable, +term, +term, -term), one).    
    all_transform_list(Goal1, Input, Acc, Ans) :-
        all_transform_list_aux(Input, Goal1, Acc, Ans).
    


    % Transform one elements in a list.
    :- meta_predicate(one_transform_list_aux(*, 3, *, *)).
    one_transform_list_aux([], _, _, _) :- false.
    
    one_transform_list_aux([X|Xs], Goal1, Acc, Ans) :-
        (   apply_transform(Goal1, X, Acc, A0) -> 
            Ans = A0
        ;   one_transform_list_aux(Xs, Goal1, Acc, Ans)).


    :- public(one_transform_list/4).
    :- meta_predicate(one_transform_list(3, *, *, *)).    
    :- mode(one_transform_list(+callable, +term, +term, -term), one).        
    one_transform_list(Goal1, Input, Acc, Ans) :-
        one_transform_list_aux(Input, Goal1, Acc, Ans).
    
        

    % alltd_rewrite
    :- public(alltd_transform/4).
    :- meta_predicate(alltd_transform(3, *, *, *)).
    :- mode(alltd_transform(+callable, +term, +term, -term), one).
    alltd_transform(T1, Input, Acc, Ans) :-
        writeln("alltd_transform"),
        apply_transform(T1, Input, Acc, A1),
        writeln("alltd_transform 2"),
        ::all_transform(::alltd_transform(T1), Input, A1, Ans).



:- end_category.
