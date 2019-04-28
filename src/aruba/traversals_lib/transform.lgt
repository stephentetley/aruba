/* 
    transform.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- category(transform, 
    implements(transformp)).

    :- public(apply_transform/4).
    :- meta_predicate(apply_transform(3, *, *, *)).
    :- mode(apply_transform(+callable, +term, +term, -term), one).
    apply_transform(Closure, Input, Acc, Ans) :-
        catch(  call(Closure, Input, Acc, Ans),
                Error,
                (writeln(Error), false)).

    :- public(choice_transform/5).
    :- meta_predicate(choice_transform(3, 3, *, *, *)).
    :- mode(choice_transform(+callable, +callable, +term, +term, -term), one).
    choice_transform(Closure1, Closure2, Input, Acc, Ans) :- 
        (   apply_transform(Closure1, Input, Acc, Ans), !
        ;   apply_transform(Closure2, Input, Acc, Ans)
        ).

    /* all_transforms */

    % all_transform_list_aux
    :- meta_predicate(all_transform_list_aux(*, 3, *, *)).
    all_transform_list_aux([], _, Ans, Ans).
        
    
    all_transform_list_aux([X|Xs], Closure, Acc, Ans) :-
        apply_transform(Closure, X, Acc, Acc1),
        all_transform_list_aux(Xs, Closure, Acc1, Ans).


    % Transform all the elements in a list.
    :- public(all_transform_list/4).
    :- meta_predicate(all_transform_list(3, *, *, *)).
    :- mode(all_transform_list(+callable, +term, +term, -term), one).    
    all_transform_list(Closure, Input, Acc, Ans) :-
        all_transform_list_aux(Input, Closure, Acc, Ans).
    

    :- public(alltd_transform/4).
    :- meta_predicate(alltd_transform(3, *, *, *)).
    :- mode(alltd_transform(+callable, +term, +term, -term), one).
    alltd_transform(Closure, Input, Acc, Ans) :-
        apply_transform(Closure, Input, Acc, A1),
        ::all_transform(::alltd_transform(Closure), Input, A1, Ans).

    :- public(allbu_transform/4).
    :- meta_predicate(allbu_transform(3, *, *, *)).
    :- mode(allbu_transform(+callable, +term, +term, -term), one).
    allbu_transform(Closure, Input, Acc, Ans) :-
        ::all_transform(::allbu_transform(Closure), Input, Acc, A1),
        apply_transform(Closure, Input, A1, Ans).
        

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
    
        




:- end_category.
