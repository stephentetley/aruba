/* 
    rewrite.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- category(rewrite).
    

    

    

    :- public(id_rewrite/2).
    :- mode(id_rewrite(+term, -term), one).
    id_rewrite(Ans, Ans).

    :- public(fail_rewrite/2).
    :- mode(fail_rewrite(+term, -term), zero).
    fail_rewrite(_, _) :- false.        

    :- public(apply_rewrite/3).
    :- meta_predicate(apply_rewrite(2,*,*)).
    :- mode(apply_rewrite(+callable, +term, -term), zero_or_more).
    apply_rewrite(Goal1, Input, Ans) :-
        catch( call(Goal1, Input, Ans),
            _,
            false).


    % all_rewrite_list
    :- public(all_rewrite_list/3).
    :- meta_predicate(all_rewrite_list(2,*,*)).
    :- mode(all_rewrite_list(+callable, +term, -term), zero_or_more).
    all_rewrite_list(Goal1, Input, Ans) :-
        all_rewrite_list_aux(Input, Goal1, [], Ans).

    all_rewrite_list_aux([], _, Acc, Ans) :-
        {reverse(Acc, Ans)}.
        
    all_rewrite_list_aux([X|Xs], Goal1, Acc, Ans) :-
        ::apply_rewrite(Goal1, X, A1),
        all_rewrite_list_aux(Xs, Goal1, [A1|Acc], Ans).

    % alltd_rewrite
    :- public(alltd_rewrite/3).
    :- meta_predicate(alltd_rewrite(2,*,*)).
    :- mode(alltd_rewrite(+callable, +term, -term), zero_or_more).
    alltd_rewrite(R1, Input, Ans) :-
        ::apply_rewrite(R1, Input, A1),
        ::all_rewrite(::alltd_rewrite(R1), A1, Ans).

:- end_category.


