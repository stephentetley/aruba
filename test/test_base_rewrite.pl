/*
    test_base_rewrite.pl
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/ 

user:file_search_path(aruba, '../src/aruba').

:- use_module(aruba(base/base_rewrite)).



add1(X,Y) :- Y is X + 1.


demo01(Ans) :- id_rewrite(none, 10, Ans).

add1_ctxfree(_, X, Y) :- Y is X + 1.

demo02(Ans) :- apply_rewrite(add1_ctxfree, none, 10, Ans).
demo02a(Ans) :- apply_rewrite(add1_ctxfree, none, [10,11,12], Ans).

demo03(X) :- contextfree_rewrite(add1,"Elephant", 5, X).
demo03a(X) :- apply_rewrite(contextfree_rewrite(add1),"Elephant", 5, X).


demo04(X) :- const_rewrite(1000, "Elephant", 4, X).
demo04a(X) :- apply_rewrite(const_rewrite(101), "Elephant", 4, X).

