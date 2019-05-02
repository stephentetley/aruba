/* 
    rewrite.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- use_module(library(lists)).

:- category(rewrite, 
    implements(rewritep)).
    

    :- public(id_rewrite/2).
    :- mode(id_rewrite(+term, -term), one).
    id_rewrite(Ans, Ans).

    :- public(fail_rewrite/2).
    :- mode(fail_rewrite(+term, -term), zero).
    fail_rewrite(_, _) :- false.        



    :- public(apply_rewrite/3).
    :- meta_predicate(apply_rewrite(2, *, *)).
    :- mode(apply_rewrite(+callable, +term, -term), one).
    apply_rewrite(Closure, Input, Ans) :-
        catch(  call(Closure, Input, Ans), 
                Error, 
                (writeln(Error), false)).
        


    :- public(choice_rewrite/4).
    :- meta_predicate(choice_rewrite(2, 2, *, *)).
    :- mode(choice_rewrite(+callable, +callable, +term, -term), one).
    choice_rewrite(Closure1, Closure2, Input, Ans) :- 
        (   apply_rewrite(Closure1, Input, Ans), !
        ;   apply_rewrite(Closure2, Input, Ans)
        ).

    :- public(try_rewrite/3).
    :- meta_predicate(try_rewrite(2, *, *)).
    :- mode(try_rewrite(+callable, +term, -term), one).
    try_rewrite(Closure, Input, Ans) :-
        choice_rewrite(Closure, id_rewrite, Input, Ans).


    /* all_rewrites */

    :- meta_predicate(all_rewrite_list_aux(*, 2, *, *)).
    all_rewrite_list_aux([], _, Acc, Ans) :-
        difflist::as_list(Acc, Ans).
            
    all_rewrite_list_aux([X|Xs], Closure, Acc, Ans) :-
        apply_rewrite(Closure, X, A1),
        difflist::add(A1, Acc, Acc1),
        all_rewrite_list_aux(Xs, Closure, Acc1, Ans).

    % all_rewrite_list
    :- public(all_rewrite_list/3).
    :- meta_predicate(all_rewrite_list(2, *, *)).
    :- mode(all_rewrite_list(+callable, +term, -term), one).
    all_rewrite_list(Closure, Input, Ans) :-
        all_rewrite_list_aux(Input, Closure, X-X, Ans).



    % alltd_rewrite
    :- public(alltd_rewrite/3).
    :- meta_predicate(alltd_rewrite(2, *, *)).
    :- mode(alltd_rewrite(+callable, +term, -term), one).
    alltd_rewrite(Closure, Input, Ans) :-
        apply_rewrite(Closure, Input, A1),
        ::all_rewrite( ::alltd_rewrite(Closure), A1, Ans).


    % allbu_rewrite
    :- public(allbu_rewrite/3).
    :- meta_predicate(allbu_rewrite(2,*,*)).
    :- mode(allbu_rewrite(+callable, +term, -term), one).
    allbu_rewrite(Closure, Input, Ans) :-
        ::all_rewrite( ::alltd_rewrite(Closure), Input, A1),
        apply_rewrite(Closure, A1, Ans).

    /* any_rewrites */

    :- meta_predicate(any_rewrite_list_aux(*, 2, *, *)).
    any_rewrite_list_aux([], _, Acc, Ans) :- 
        difflist::as_list(Acc, Ans).
    
    any_rewrite_list_aux([X|Xs], Closure, Acc, Ans) :-
        (   apply_rewrite(Closure, X, A1)
        ;   A1 = X
        ),
        difflist::add(A1, Acc, Acc1),
        any_rewrite_list_aux(Xs, Closure, Acc1, Ans).


    % any_rewrite_list
    :- public(any_rewrite_list/3).
    :- meta_predicate(any_rewrite_list(2,*,*)).
    :- mode(any_rewrite_list(+callable, +term, -term), zero_or_more).
    any_rewrite_list(Closure, Input, Ans) :-
        any_rewrite_list_aux(Input, Closure, X-X, Ans).
    
    % anytd_rewrite
    :- public(anytd_rewrite/3).
    :- meta_predicate(anytd_rewrite(2,*,*)).
    :- mode(anytd_rewrite(+callable, +term, -term), zero_or_more).
    anytd_rewrite(Closure, Input, Ans) :-
        (   apply_rewrite(Closure, Input, A1)
        ;   A1 = Input
        ),
        ::any_rewrite( ::anytd_rewrite(Closure), A1, Ans).

    /* one_rewrites */

    :- meta_predicate(one_rewrite_list_aux(*, 2, *, *)).        
    one_rewrite_list_aux([], _, _, _) :-
        false.


    one_rewrite_list_aux([X|Rest], Closure, Acc, Ans) :-
        (   ::apply_rewrite(Closure, X, X1) -> 
            difflist::add(X1, Acc, Acc1), 
            difflist::append(Acc1, Rest, Acc2),
            difflist::as_list(Acc2, Ans)
        ;   difflist::add(X, Acc, Acc1), 
            one_rewrite_list_aux(Rest, Closure, Acc1, Ans)
        ).



    % one_rewrite_list
    :- public(one_rewrite_list/3).
    :- meta_predicate(one_rewrite_list(2,*,*)).
    :- mode(one_rewrite_list(+callable, +term, -term), zero_or_more).
    one_rewrite_list(Closure, Input, Ans) :-
        one_rewrite_list_aux(Input, Closure, X-X, Ans).
        

    % ??? 
    % onetd_rewrite
    :- public(onetd_rewrite/3).
    :- meta_predicate(onetd_rewrite(2,*,*)).
    :- mode(alltd_rewrite(+callable, +term, -term), zero_or_more).
    onetd_rewrite(Closure, Input, Ans) :-
        (   apply_rewrite(Closure, Input, Ans)
        ;   ::one_rewrite( ::onetd_rewrite(Closure), Input, Ans)
        ).


:- end_category.


