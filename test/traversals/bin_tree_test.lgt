/*  
    bin_tree_test.lgt
*/

:- object(bin_tree_test).

    :- public(test_data1/1).
    test_data1(bin(1, bin(2, bin(4,empty,empty), bin(5, empty, empty)), bin(3, empty,empty))).

    add1(X,Y) :- Y is X + 1.

    :- public(test01/1).
    test01(Ans) :- 
        bin_tree::all_rewrite(add1, empty, Ans).
    
    % fails (add1 is the wrong type)
    :- public(test01a/1).
    test01a(Ans) :- 
        test_data1(T),
        bin_tree::all_rewrite(add1, T, Ans).

    :- public(bin_add_one/2).
    % :- meta_predicate(bin_add_one(*, *)).
    % :- mode(bin_add_one(+term, -term), one).
    bin_add_one(bin(X, T1, T2), Ans) :- 
        integer(X),
        !, 
        Y is X + 1,
        Ans = bin(Y, T1, T2).
    
    bin_add_one(empty, empty).


    % Should succeed
    :- public(test01b/1).
    test01b(Ans) :- 
        bin_tree::all_rewrite(bin_add_one, empty, Ans).
    
    :- public(test01c/1).
    test01c(Ans) :- 
        bin_tree::all_rewrite([X,Y]>> (X = Y), bin(1, empty, empty), Ans).

    :- public(test01d/1).
    test01d(Ans) :- 
        bin_tree::all_rewrite(bin_tree_test::bin_add_one, bin(1, empty, empty), Ans).

    :- public(test01e/1).
    test01e(Ans) :- 
        bin_add_one(empty, Ans).

    :- public(test01f/1).
    test01f(Ans) :- 
        test_data1(Tree1),
        bin_tree::alltd_rewrite([X,Y] >> (Y = X), Tree1, Ans).

    :- public(test01g/1).
    test01g(Ans) :- 
        test_data1(Tree1),
        bin_tree::alltd_rewrite(bin_tree_test::bin_add_one, Tree1, Ans).

    :- public(test01h/1).
    test01h(Ans) :- 
        test_data1(Tree1),
        bin_tree::allbu_rewrite(bin_add_one, Tree1, Ans).

    count_labels(bin(_, _, _), Acc, Ans) :- Ans is Acc + 1, !.
    count_labels(_, Acc, Acc).

    :- public(test02/1).
    test02(Ans) :- 
        test_data1(Tree1),
        bin_tree::alltd_transform(count_labels, Tree1, 0, Ans).

:- end_object.