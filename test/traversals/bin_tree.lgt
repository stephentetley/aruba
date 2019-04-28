/*  
    bin_tree.lgt
*/

:- object(bin_tree, 
    imports([rewrite, transform])).

    :- meta_predicate(all_rewrite_empty(2, *, *)).    
    all_rewrite_empty(_, empty, empty).

    :- meta_predicate(all_rewrite_bin(2, *, *)).    
    all_rewrite_bin(Closure, bin(A, X1, X2), Ans) :-
        ::apply_rewrite(Closure, X1, Y1),
        ::apply_rewrite(Closure, X2, Y2),
        Ans = bin(A, Y1, Y2).


    :- meta_predicate(all_rewrite(2, *, *)).
    all_rewrite(Closure, Input, Ans) :- 
        ::choice_rewrite(all_rewrite_bin(Closure), all_rewrite_empty(Closure), Input, Ans).


    :- meta_predicate(all_tranform_empty(3, *, *, *)).    
    all_transform_empty(_, empty, Acc, Acc).
            
    :- meta_predicate(all_transform_bin(3, *, *, *)).    
    all_transform_bin(Closure, bin(_, X1, X2), Acc, Ans) :-
        ::apply_transform(Closure, X1, Acc, Acc1),
        ::apply_transform(Closure, X2, Acc1, Ans).  

    :- meta_predicate(all_transform(3, *, *, *)).
    all_transform(Closure, Input, Acc, Ans) :- 
        ::choice_transform(all_transform_bin(Closure), all_transform_empty(Closure), Input, Acc, Ans).


    :- public(test_data1/1).
    test_data1(bin(1, bin(2, bin(4,empty,empty), bin(5, empty, empty)), bin(3, empty,empty))).

    add1(X,Y) :- Y is X + 1.

    :- public(test01/1).
    test01(Ans) :- 
        all_rewrite_empty(add1, empty, Ans).
    
    % should fail
    :- public(test01a/1).
    test01a(Ans) :- 
        all_rewrite(add1, empty, Ans).


    bin_add1(bin(X, T1, T2), Ans) :- 
        integer(X),
        !, 
        Y is X + 1,
        Ans = bin(Y, T1, T2).
    
    bin_add1(X,X).


    % Should succeed
    :- public(test01b/1).
    test01b(Ans) :- 
        all_rewrite(bin_add1, empty, Ans).
    
    :- public(test01c/1).
    test01c(Ans) :- 
        all_rewrite_bin([X,Y]>> (X = Y), bin(1, empty, empty), Ans).

    :- public(test01d/1).
    test01d(Ans) :- 
        all_rewrite(bin_add1, bin(1, bin(2,empty,empty), empty), Ans).

    :- public(test01e/1).
    test01e(Ans) :- 
        bin_add1(empty, Ans).

    :- public(test01f/1).
    test01f(Ans) :- 
        test_data1(Tree1),
        ::alltd_rewrite([X,Y] >> (Y = X), Tree1, Ans).

    :- public(test01g/1).
    test01g(Ans) :- 
        test_data1(Tree1),
        ::alltd_rewrite(bin_add1, Tree1, Ans).

    :- public(test01h/1).
    test01h(Ans) :- 
        test_data1(Tree1),
        ::allbu_rewrite(bin_add1, Tree1, Ans).

    count_labels(bin(_, _, _), Acc, Ans) :- Ans is Acc + 1, !.
    count_labels(_, Acc, Acc).

    :- public(test02/1).
    test02(Ans) :- 
        test_data1(Tree1),
        ::alltd_transform(count_labels, Tree1, 0, Ans).

:- end_object.