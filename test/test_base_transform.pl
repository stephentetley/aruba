/*
    test_base_transform.pl
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/ 

user:file_search_path(aruba, '../src/aruba').

:- use_module(aruba(base/base_transform)).

demo01(X) :-
    success_transform("Elephant", 0, 8),
    X = true.

demo01a :- 
    success_transform("Elephant", 0, 8).

demo02(X) :-
    context_transform("Elephant", 0, 8, X).

update(_, "Bluish").

demo03(X) :-
    lift_context_transform(update, context_transform, "Elephant", 0, 8, X).