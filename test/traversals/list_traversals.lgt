/*
    list_traversals.lgt
*/

:- object(list_traversals, 
    implements([rewritep, transformp]),
    imports([rewrite, transform])).

    all_rewrite(Closure, Input, Ans) :- 
        ::all_rewrite_list(Closure, Input, Ans).

    :- public(add1/2).
    add1(X, Y) :- Y is X + 1.

    :- public(test01/1).
    test01(Ans) :- 
        all_rewrite(list::add1, [1,2,3,4,5,6], Ans).

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



:- end_object.