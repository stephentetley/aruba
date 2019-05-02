/* 
    ctx_rewrite.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- use_module(library(lists)).

:- category(ctx_rewrite, 
    implements(ctx_rewritep)).

    :- public(id_ctx_rewrite/3).
    :- mode(id_ctx_rewrite(+term, +term, -term), one).
    id_ctx_rewrite(_, Ans, Ans).

    :- public(fail_ctx_rewrite/3).
    :- mode(fail_ctx_rewrite(+term, +term, -term), zero).
    fail_ctx_rewrite(_, _, _) :- false.     

    :- public(apply_ctx_rewrite/4).
    :- meta_predicate(apply_ctx_rewrite(3, *, *, *)).
    :- mode(apply_ctx_rewrite(+callable, +term, +term, -term), one).
    apply_ctx_rewrite(Closure, Ctx, Input, Ans) :-
        catch(  call(Closure, Ctx, Input, Ans), 
                Error, 
                (writeln(Error), false)).


    :- public(choice_ctx_rewrite/5).
    :- meta_predicate(choice_ctx_rewrite(3, 3, *, *, *)).
    :- mode(choice_ctx_rewrite(+callable, +callable, +term, +term, -term), one).
    choice_ctx_rewrite(Closure1, Closure2, Ctx, Input, Ans) :- 
        (   apply_ctx_rewrite(Closure1, Ctx, Input, Ans), !
        ;   apply_ctx_rewrite(Closure2, Ctx, Input, Ans)
        ).
            
    :- public(try_ctx_rewrite/4).
    :- meta_predicate(try_ctx_rewrite(3, *, *, *)).
    :- mode(try_ctx_rewrite(+callable, +term, +term, -term), one).
    try_ctx_rewrite(Closure, Ctx, Input, Ans) :-
        choice_ctx_rewrite(Closure, id_ctx_rewrite, Ctx, Input, Ans).

    /* all_rewrites */

    :- meta_predicate(all_ctx_rewrite_list_aux(*, 3, *, *, *)).
    all_ctx_rewrite_list_aux([], _, _, Acc, Ans) :-
        difflist::as_list(Acc, Ans).
            
    all_ctx_rewrite_list_aux([X|Xs], Closure, Ctx, Acc, Ans) :-
        apply_ctx_rewrite(Closure, Ctx, X, A1),
        difflist::add(A1, Acc, Acc1),
        all_ctx_rewrite_list_aux(Xs, Closure, Ctx, Acc1, Ans).        

    % all_rewrite_list
    :- public(all_ctx_rewrite_list/4).
    :- meta_predicate(all_ctx_rewrite_list(3, *, *, *)).
    :- mode(all_ctx_rewrite_list(+callable, +term, +term, -term), one).
    all_ctx_rewrite_list(Closure, Ctx, Input, Ans) :-
        all_ctx_rewrite_list_aux(Input, Closure, Ctx, X-X, Ans).


:- end_category.	