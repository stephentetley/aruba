/*
    listtrav.lgt
*/

% > & 'C:\Program Files\swipl\bin\swipl.exe'
% ?- use_module(library(logtalk)).
% ?- {loader}.

:- object(listtrav, 
    % implements([rewritep, transformp]),
    imports([rewrite, transform])).

    % Must include a meta_predicate directive here so we can call 'add1' etc.
    % without explicit qualification.
    :- meta_predicate(all_rewrite(2, *, *)).    
    all_rewrite(Closure, Input, Ans) :- 
        ::all_rewrite_list(Closure, Input, Ans).

    add1(X, Y) :- Y is X + 1.


    :- public(test01/1).
    test01(Ans) :- 
        ::apply_rewrite(add1, 3, Ans).

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
    
 
    safe_add1(X, Y) :- 
        integer(X), 
        !,
        Y is X + 2.

    safe_add1(X, X).

    % :- meta_predicate(alltd_rewrite(2, *, *)). 

    % Should this work? Have to check KURE...
    :- public(test06/1).
    test06(Ans) :- 
        ::alltd_rewrite(safe_add1, [1,2,3,4,5,6], Ans).
    
    :- public(test06a/1).
    test06a(Ans) :- 
        all_rewrite(safe_add1, [1,2,3,4,5,6], Ans).
    
    :- public(test06b/1).
    test06b(Ans) :- 
        safe_add1([1,2,3], Ans).

:- end_object.