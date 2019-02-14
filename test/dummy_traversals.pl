/*
    dummy_traversals.pl
    Copyright (c) Stephen Tetley 2018,2019
    License: BSD 3 Clause
*/ 


/*
    RecLib paper (Deling Ren, Martin Erwig) has illustrations of recursion paths.
    

*/
user:file_search_path(aruba, '../src/aruba').

:- use_module(library(record)).
:- use_module(aruba(base/base_traversals)).



:- record company(departments:list=[]).

:- record department(name:text=none, manager:employee, units:list).

:- record unit_employee(employee:employee).

:- record unit_dept(dept:department).

:- record employee(person:person, salary:float).

:- record person(name:string, address:string).


add1(X,Y) :- Y is X + 1.
sum(X,Y,Z) :- Z is X + Y.


demo01(Ans) :- sequence_rewrite(add1, add1, 10, Ans).


if_even_add10(X,Y) :- 
    A1 is rem(X,2),
    (A1 == 0 -> Y is X + 10).


demo02(Ans) :- choose_rewrite(if_even_add10, add1, 1, Ans).

employee(person("stephen", "Yorkshire"), 10000000.0).

demo03(Ans) :- employee(person("stephen", "Yorkshire"), 10000000.0) =.. Ans.


demo04(Ans) :- all_rewrite(identity, employee(person("stephen", "Yorkshire"), 10000000.0), Ans).

% Prolog lists are heterogenous (of course!)...
demo05(Ans) :- 
    Ans = [1,"two"].


% try_rewrite(R1, Input, Ans) :-
%     choose_rewrite(R1, identity_rewrite, Input, Ans).


    
demo06(Input, Ans) :- 
    try_rewrite(add1, Input, Ans).
    

% alltd_rewrite(R1, Input, Ans) :-
%     choose_rewrite(R1, all_rewrite(alltd_rewrite(R1)), Input, Ans).


% allbu_rewrite(R1, Input, Ans) :-
%     choose_rewrite(all_rewrite(allbu_rewrite(R1)), R1, Input, Ans).

demo07(Ans) :- 
    X = node(leaf(1),node(leaf(2), leaf(3))),
    alltd_rewrite(add1, X, Ans).

if_even_add10_three(X, _ ,Y) :- 
    A1 is rem(X,2),
    (A1 == 0 -> Y is X + 10).

% demo08 works (the functor mylist(..) is destructured):
demo08(Ans) :- 
    one_trafo(if_even_add10_three, mylist(1,3,4,5,7,9), 0, Ans).


% demo08a - note we have added a special clause to destructure lists...
demo08a(Ans) :- 
    one_trafo(if_even_add10_three, [1,3,4,5,7,9], 0, Ans).


demo09(Ans) :- 
    any_rewrite(if_even_add10, [1,2,3,4,5,6,7,8,9], Ans).


demo09a(Ans) :- 
    alltd_rewrite(if_even_add10, [2,4,6,8,[10,12]], Ans).


demo09b(Ans) :- 
    allbu_rewrite(if_even_add10, [2,4,6,8,[10,12]], Ans).



maximum(X, Y, Ans) :- 
    Ans is max(X,Y).


demo10(Ans) :- 
    alltd_trafo(maximum, [1,2,3,4,5,6,7,8,9], 0, Ans).



list_append(X, Xs, Ans) :-
    ( \+ is_list(X) 
    -> Ans = [X|Xs]
    ; Ans = Xs
    ).


flaky_append(X,Xs,Ans) :- 
    Ans  = [X|Xs].


%%
demo11(Ans) :- 
    all_trafo(sum, [1,2,3,4,5,6], 0, Ans).

demo11a(Ans) :- 
    alltd_trafo(sum, [1,2,3,4,5,6], 0, Ans).

demo11b(Ans) :- 
    alltd_trafo(sum, [1,2,3,[4,[5,6]]], 0, Ans).

demo11c(Ans) :- 
    alltd_trafo(sum, [1,2,3,number(4),[5,6]], 0, Ans).


count(_, Acc, Ans) :-
    Ans is Acc + 1.

demo12(Ans) :- 
    all_trafo(count, [1,2,3,4,5,6], 0, Ans).

demo12a(Ans) :- 
    alltd_trafo(count, [1,2,3,4,5,6], 0, Ans).

demo12b(Ans) :- 
    alltd_trafo(count, [1,2,3,[4,[5,6]]], 0, Ans).

demo12c(Ans) :- 
    alltd_trafo(count, [1,2,3,number(4),[5,6]], 0, Ans).

demo12d(Ans) :- 
    alltd_trafo(count, list(zero, [1,2,3,number(4),[5]]), 0, Ans).

sum_if_number(number(X), Acc, Ans) :- 
    Ans is X + Acc.

sum_if_number(_, Acc, Acc).

demo13(Ans) :- 
    alltd_trafo(sum_if_number, [1,2,3, number(4),[5, number(6)]], 0, Ans).


demo13a(Ans) :- 
    allbu_trafo(sum_if_number, [1,2,3, number(4),[5, number(6)]], 0, Ans).


demo14(X) :- 
    Tree = node(leaf(1),node(leaf(2), leaf(3))),
    one_rewrite(add1, Tree, X).


demo14a(X) :- 
    Tree = node(1,node(2,3)),
    one_rewrite(add1, Tree, X).