/*
    dummy_traversals.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/ 


/*
    RecLib paper (Deling Ren, Martin Erwig) has illustrations of recursion paths.
    

*/
:- use_module(library(record)).


:- record company(departments:list=[]).

:- record department(name:text=none, manager:employee, units:list).

:- record unit_employee(employee:employee).

:- record unit_dept(dept:department).

:- record employee(person:person, salary:float).

:- record person(name:string, address:string).


% choose(r1,r1)

identity_r(A,A).

fail_r(_) :- false.

seq_r(R1, R2, Input, Ans) :-
    call(R1, Input, A1),
    call(R2, A1, Ans).

add1(X,Y) :- Y is X + 1.

demo01(Ans) :- seq_r(add1, add1, 10,Ans).

choose_r(R1, R2, Input, Ans) :-
    ( call(R1,Input,X) -> Ans is X
    ; call(R2,Input,Ans)
    ).

if_even_add10(X,Y) :- 
    A1 is rem(X,2),
    (A1 == 0 -> Y is X + 10).


demo02(Ans) :- choose_r(if_even_add10, add1, 1, Ans).

employee(person("stephen", "Yorkshire"), 10000000.0).

demo03(Ans) :- employee(person("stephen", "Yorkshire"), 10000000.0) =.. Ans.

all_r_aux(_,[],[]).
all_r_aux(R1, [X|Xs], Ans) :-
    call(R1, X, A1),
    all_r_aux(R1, Xs, A2),
    Ans = [A1|A2].


all_r(R1,Input,Ans) :-
    Input =.. [Head|Kids],
    all_r_aux(R1, Kids, Kids1), 
    Ans =.. [Head|Kids1], !.


demo04(Ans) :- all_r(identity_r, employee(person("stephen", "Yorkshire"), 10000000.0), Ans).


demo05(Ans) :- 
    Ans = [1,"two"].



    
    

    

