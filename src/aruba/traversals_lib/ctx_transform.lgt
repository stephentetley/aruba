/* 
    ctx_transform.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- category(ctx_transform, 
    implements(ctx_transformp)).

    :- public(apply_ctx_transform/5).
    :- meta_predicate(apply_ctx_transform(4, *, *, *, *)).
    :- mode(apply_ctx_transform(+callable, +term, +term, +term, -term), one).
    apply_ctx_transform(Closure, Ctx, Input, Acc, Ans) :-
        catch(  call(Closure, Ctx, Input, Acc, Ans),
                Error,
                (writeln(Error), false)).

    :- public(choice_ctx_transform/6).
    :- meta_predicate(choice_ctx_transform(4, 4, *, *, *, *)).
    :- mode(choice_ctx_transform(+callable, +callable, +term, +term, +term, -term), one).
    choice_ctx_transform(Closure1, Closure2, Ctx, Input, Acc, Ans) :- 
        (   apply_ctx_transform(Closure1, Ctx, Input, Acc, Ans), !
        ;   apply_ctx_transform(Closure2, Ctx, Input, Acc, Ans)
        ).





    /* all_transforms */

    % all_transform_list_aux
    :- meta_predicate(all_ctx_transform_list_aux(*, 4, *, *, *)).
    all_ctx_transform_list_aux([], _, _, Ans, Ans).
        
    
    all_ctx_transform_list_aux([X|Xs], Closure, Ctx, Acc, Ans) :-
        apply_ctx_transform(Closure, Ctx, X, Acc, Acc1),
        all_ctx_transform_list_aux(Xs, Closure, Ctx, Acc1, Ans).



    % Transform all the elements in a list.
    :- public(all_ctx_transform_list/5).
    :- meta_predicate(all_ctx_transform_list(4, *, *, *, *)).
    :- mode(all_ctx_transform_list(+callable, +term, +term, +term, -term), one).    
    all_ctx_transform_list(Closure, Ctx, Input, Acc, Ans) :-
        all_ctx_transform_list_aux(Input, Closure, Ctx, Acc, Ans).
    



:- end_category.
