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
        ::all_rewrite(::alltd_rewrite(Closure), A1, Ans).


    % allbu_rewrite
    :- public(allbu_rewrite/3).
    :- meta_predicate(allbu_rewrite(2,*,*)).
    :- mode(allbu_rewrite(+callable, +term, -term), one).
    allbu_rewrite(R1, Input, Ans) :-
        ::all_rewrite(::alltd_rewrite(R1), Input, A1),
        apply_rewrite(R1, A1, Ans).

    /* any_rewrites */

    :- meta_predicate(any_rewrite_list_aux(*, 2, *, *)).
    any_rewrite_list_aux([], _, Acc, Ans) :- 
        lists::reverse(Acc, Ans).
    
    any_rewrite_list_aux([X|Xs], Goal1, Acc, Ans) :-
        (   apply_rewrite(Goal1, X, A0)
        ;   A0 = X),
        any_rewrite_list_aux(Xs, Goal1, [A0,Acc], Ans).


    % any_rewrite_list
    :- public(any_rewrite_list/3).
    :- meta_predicate(any_rewrite_list(2,*,*)).
    :- mode(any_rewrite_list(+callable, +term, -term), zero_or_more).
    any_rewrite_list(Goal1, Input, Ans) :-
        any_rewrite_list_aux(Input, Goal1, [], Ans).
    


    % one_rewrite_list
    :- public(one_rewrite_list/3).
    :- meta_predicate(one_rewrite_list(2,*,*)).
    :- mode(one_rewrite_list(+callable, +term, -term), zero_or_more).
    one_rewrite_list(Goal1, Input, Ans) :-
        one_rewrite_list_aux(Input, Goal1, [], Ans).
        
    one_rewrite_list_aux([], _, _, _) :-
        false.
    
    
    one_rewrite_list_aux([X|Xs], Goal1, Acc, Ans) :-
        (   ::apply_rewrite(Goal1, X, X1) -> 
            {(reverse(Acc, Front), append(Front,[X1|Xs],Ans))}
        ;   one_rewrite_list_aux(Xs, Goal1, [X|Acc], Ans)).



    % anytd_rewrite
    :- public(anytd_rewrite/3).
    :- meta_predicate(anytd_rewrite(2,*,*)).
    :- mode(anytd_rewrite(+callable, +term, -term), zero_or_more).
    anytd_rewrite(R1, Input, Ans) :-
        (   ::apply_rewrite(R1, Input, A1)
        ;   A1 = Input),
        ::any_rewrite(::anytd_rewrite(R1), A1, Ans).


    % ??? 
    % onetd_rewrite
    :- public(onetd_rewrite/3).
    :- meta_predicate(onetd_rewrite(2,*,*)).
    :- mode(alltd_rewrite(+callable, +term, -term), zero_or_more).
    onetd_rewrite(R1, Input, Ans) :-
        (   ::apply_rewrite(R1, Input, Ans)
        ;   ::one_rewrite(::onetd_rewrite(R1), Input, Ans)).





:- end_category.


