/*
    test_base_rewrite2.pl
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/ 

user:file_search_path(aruba, '../src/aruba').

:- use_module(aruba(base/base_rewrite)).



add1(X,Y) :- Y is X + 1.

add1_ctxfree(_, X, Y) :- Y is X + 1.

node_add1(_,node(X,Y,Z), Ans) :-
    X1 is X + 1,
    Ans = node(X1, Y, Z).

tree1(node(1, node(2, node(4,empty,empty), node(5,empty,empty)), node(3,empty,empty))).

tree2(node(1, node(2,empty,empty),empty)).


demo01(X) :- 
    tree1(Tree),
    apply_rewrite(id_rewrite, no_ctx, Tree, X).

demo02(X) :- 
    tree1(Tree),
    apply_rewrite(node_add1, no_ctx, Tree, X).

demo03(X) :- 
    tree1(Tree),
    apply_rewrite(one_rewrite(node_add1), no_ctx, Tree, X).


demo04(X) :- 
    tree1(Tree),
    apply_rewrite(any_rewrite(node_add1), no_ctx, Tree, X).


demo05(X) :- 
    tree1(Tree),
    apply_rewrite(all_rewrite(node_add1), no_ctx, Tree, X).

