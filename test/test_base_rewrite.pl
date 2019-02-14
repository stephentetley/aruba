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

addn_ctxfree(N, _, X, Y) :- Y is X + N.

demo02(Ans) :- apply_rewrite(add1_ctxfree, none, 10, Ans).
demo02a(Ans) :- apply_rewrite(add1_ctxfree, none, [10,11,12], Ans).

demo03(X) :- contextfree_rewrite(add1,"CtxElephant", 5, X).
demo03a(X) :- apply_rewrite(contextfree_rewrite(add1),"CtxElephant", 5, X).


demo04(X) :- const_rewrite(1000, "CtxElephant", 4, X).
demo04a(X) :- apply_rewrite(const_rewrite(101), "CtxElephant", 4, X).

demo05(X) :- 
    sequence_rewrite(add1_ctxfree, add1_ctxfree, "CtxElephant", 10, X).

% false
demo05a(X) :- 
    sequence_rewrite(add1_ctxfree, add1_ctxfree, "CtxElephant", "String", X).

% false
demo05b(X) :- 
    sequence_rewrite(fail_rewrite, add1_ctxfree, "CtxElephant", 10, X).

%% 11
demo06(X) :- 
    choose_rewrite(fail_rewrite, add1_ctxfree, "CtxElephant", 10, X).

%% false.
demo06a(X) :- 
    choose_rewrite(fail_rewrite, add1_ctxfree, "CtxElephant", "String", X).

demo07(X) :- 
    one_rewrite(add1_ctxfree, "CtxElephant", [10,11,12], X).


demo08(X) :- 
    any_rewrite(add1_ctxfree, "CtxElephant", [10,11,12], X).


demo09(X) :- 
    all_rewrite(addn_ctxfree(4), "CtxElephant", [10,11,12], X).


demo10(X) :- 
    Tree = node(1,node(2,3)),
    id_rewrite("CtxNone", Tree, X).

demo10a(X) :- 
    Tree = node(1,node(2,3)),
    one_rewrite(add1_ctxfree, "CtxNone", Tree, X).

demo10b(X) :- 
    Tree = node(1,node(2,3)),
    any_rewrite(add1_ctxfree, "CtxNone", Tree, X).

% This is quite _important_ we need to check KURE's behavior here.

demo10c(X) :- 
    Tree = node(1,node(2,3)),
    all_rewrite(add1_ctxfree, "CtxNone", Tree, X).

demo10d(X) :- 
    Tree = node(1,node(2,3)),
    alltd_rewrite(add1_ctxfree, "CtxNone", Tree, X).
