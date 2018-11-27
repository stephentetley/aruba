/*
    dummy_traversals.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/ 


/*
    RecLib paper (Deling Ren, Martin Erwig) has illustrations of recursion paths.
    

*/

:- use_module(aruba/base/traversals).
:- use_module(library(record)).


:- record company(departments:list=[]).

:- record department(name:text=none, manager:employee, units:list).

:- record unit_employee(employee:employee).

:- record unit_dept(dept:department).

:- record employee(person:person, salary:float).

:- record person(name:string, address:string).


% choose(r1,r1)



% fail_rewrite(_) :- false.

% seq_rewrite(R1, R2, Input, Ans) :-
%     call(R1, Input, A1),
%     call(R2, A1, Ans).

add1(X,Y) :- Y is X + 1.

demo01(Ans) :- seq_rewrite(add1, add1, 10,Ans).

% choose_rewrite(R1, R2, Input, Ans) :-
%     catch(call(R1,Input,Ans), 
%           _, 
%           call(R2,Input,Ans)).

if_even_add10(X,Y) :- 
    A1 is rem(X,2),
    (A1 == 0 -> Y is X + 10).


demo02(Ans) :- choose_rewrite(if_even_add10, add1, 1, Ans).

employee(person("stephen", "Yorkshire"), 10000000.0).

demo03(Ans) :- employee(person("stephen", "Yorkshire"), 10000000.0) =.. Ans.

% all_rewrite_aux(_,[],[]).
% all_rewrite_aux(R1, [X|Xs], Ans) :-
%     call(R1, X, A1),
%     all_rewrite_aux(R1, Xs, A2),
%     Ans = [A1|A2].


% all_rewrite(R1,Input,Ans) :-
%     Input =.. [Head|Kids],
%     all_rewrite_aux(R1, Kids, Kids1), 
%     Ans =.. [Head|Kids1], !.


demo04(Ans) :- all_rewrite(identity_rewrite, employee(person("stephen", "Yorkshire"), 10000000.0), Ans).

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


    