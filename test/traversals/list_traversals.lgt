/*
    list_traversals.lgt
*/

% > & 'C:\Program Files\swipl\bin\swipl.exe'
% ?- use_module(library(logtalk)).
% ?- {loader}.

:- object(list_traversals, 
    % implements([rewritep, transformp]),
    imports([rewrite, transform])).

    % Must include a meta_predicate directive here so we can call 'add1' etc.
    % without explicit qualification.
    :- meta_predicate(all_rewrite(2, *, *)).    
    all_rewrite(Closure, Input, Ans) :- 
        ^^all_rewrite_list(Closure, Input, Ans).

    :- public(add1/2).
    add1(X, Y) :- Y is X + 1.

    :- public(test0/1).
    test0(Ans) :- 
        list_traversals::apply_rewrite(list_traversals::add1, 3, Ans).

    :- public(test0a/1).
    test0a(Ans) :- 
        list_traversals::apply_rewrite(add1, 3, Ans).


    :- public(test01/1).
    test01(Ans) :- 
        all_rewrite(list_traversals::add1, [1,2,3,4,5,6], Ans).

    :- public(test02/1).
    test02(Ans) :- 
        all_rewrite(add1, [1,2,3,4,5,6], Ans).

    :- public(test03/1).
    test03(Ans) :- 
        all_rewrite(([X,Y] >> (Y is X + 1)), [1,2,3,4,5,6], Ans).

    :- public(test04/1).
    test04(Ans) :- 
        meta::map(add1, [1,2,3,4,5,6], Ans).

    :- private(add2/2).
    add2(X, Y) :- Y is X + 2.

    :- public(test05/1).
    test05(Ans) :- 
        all_rewrite(add2, [1,2,3,4,5,6], Ans).
    
    :- private(guarded_add2/2).
    :- mode(guarded_add2(+term, -term), one).
    guarded_add2(X, Y) :- 
        integer(X), 
        Y is X + 2.

    guarded_add2(X, X).


    :- public(test06/1).
    test06(Ans) :- 
        ::alltd_rewrite(list_traversals::guarded_add2, [1,2,3,4,5,6], Ans).

    :- public(test06a/1).
    test06a(Ans) :- 
       ::all_rewrite(guarded_add2, [1,2,3,4,5,6], Ans).

    :- public(test06b/1).
    test06b(Ans) :- 
        guarded_add2([1,2,3], Ans).

:- end_object.