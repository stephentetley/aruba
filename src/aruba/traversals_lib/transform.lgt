/* 
    rewrite.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- category(transform).

    :- public(apply_transform/4).
    :- meta_predicate(apply_transform(3,*,*,*)).
    :- mode(apply_transform(+callable, +term, +term, -term), zero_or_more).
    apply_transform(Goal1, Input, Acc, Ans) :-
        catch( call(Goal1, Input, Acc, Ans),
            _,
            false).

    % Transform all the elements in a list.
    :- public(all_transform_list/4).
    :- meta_predicate(all_transform_list(3,*,*,*)).
    :- mode(all_transform_list(+callable, +term, +term, -term), zero_or_more).    
    all_transform_list(Goal1, Input, Acc, Ans) :-
        all_transform_list_aux(Input, Goal1, Acc, Ans).
    
    :- meta_predicate(all_transform_list_aux(*, 3, *,*)).
    all_transform_list_aux([], _, Ans, Ans).
        
    
    all_transform_list_aux([X|Xs], Goal1, Acc, Ans) :-
        ::apply_transform(Goal1, X, Acc, Acc1),
        all_transform_list_aux(Xs, Goal1, Acc1, Ans).

    % Transform one elements in a list.
    :- public(one_transform_list/4).
    :- meta_predicate(one_transform_list(3,*,*,*)).
    :- mode(one_transform_list(+callable, +term, +term, -term), zero_or_more).        
    one_transform_list(Goal1, Input, Acc, Ans) :-
        one_transform_list_aux(Input, Goal1, Acc, Ans).
    
    one_transform_list_aux([], _, _, _) :- false.
    
    one_transform_list_aux([X|Xs], Goal1, Acc, Ans) :-
        (   ::apply_transform(Goal1, X, Acc, A0) -> 
            Ans = A0
        ;   one_transform_list_aux(Xs, Goal1, Acc, Ans)).
        

    % alltd_rewrite
    :- public(alltd_transform/4).
    :- meta_predicate(alltd_transform(3,*,*,*)).
    :- mode(alltd_transform(+callable, +term, +term, -term), zero_or_more).
    alltd_transform(T1, Input, Acc, Ans) :-
        ::apply_transform(T1, Input, Acc, A1),
        ::all_transform(::alltd_transform(T1), Input, A1, Ans).

:- end_category.
