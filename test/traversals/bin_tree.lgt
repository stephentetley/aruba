/*  
    bin_tree.lgt
*/

:- use_module(library(http/json)).


:- object(bin_tree, 
    implements([rewritep, transformp]),
    imports([rewrite, transform])).

    identity(X,Y) :- 
        Y = X.

    :- meta_predicate(decode_bin_tree_cont(*, 2, *)).
    decode_bin_tree_cont(null, Cont, Ans) :- 
        call(Cont, null, Ans).
        
    decode_bin_tree_cont(Dict, Cont, Ans) :-
        decode_bin_tree_cont(Dict.left,  identity, V1),
        decode_bin_tree_cont(Dict.right, identity, V2),
        !,
        call(Cont, bin(Dict.label, V1, V2), Ans).

    :- meta_predicate(encode_bin_tree_cont(*, 2, *)).
    encode_bin_tree_cont(null, Cont, Ans) :- 
        call(Cont, null, Ans). 

    encode_bin_tree_cont(bin(A, Left, Right), Cont, Ans) :- 
        encode_bin_tree_cont(Left, identity, V1),
        encode_bin_tree_cont(Right, identity, V2), 
        call(Cont, _{label:A, left:V1, right:V2}, Ans).
        



    :- public(json_read_bin_tree/2).
    json_read_bin_tree(Src, Ans):-
        open(Src, read, Stream),
        json::json_read_dict(Stream, Dict),
        close(Stream), 
        decode_bin_tree_cont(Dict, identity, Ans).



    :- public(json_write_bin_tree/2).
    json_write_bin_tree(Dst, Tree) :- 
        encode_bin_tree_cont(Tree, identity, Dict),
        open(Dst, write, Stream),
        json::json_write_dict(Stream, Dict), 
        close(Stream).

    
    :- meta_predicate(all_rewrite_aux(*, 2, *)). 
    all_rewrite_aux(bin(A, X1, X2), Closure, Ans) :-
        ::apply_rewrite(Closure, X1, Y1),
        ::apply_rewrite(Closure, X2, Y2),
        Ans = bin(A, Y1, Y2).
           
    all_rewrite_aux(empty, _, empty).


    :- meta_predicate(all_rewrite(2, *, *)).
    all_rewrite(Closure, Input, Ans) :- 
        all_rewrite_aux(Input, Closure, Ans).

    :- meta_predicate(any_rewrite(2, *, *)).
    any_rewrite(_, _, _) :- false.

    :- meta_predicate(one_rewrite(2, *, *)).
    one_rewrite(_, _, _) :- false.


    :- meta_predicate(all_transform_empty(3, *, *, *)).    
    all_transform_empty(_, empty, Acc, Acc).
            
    :- meta_predicate(all_transform_bin(3, *, *, *)).    
    all_transform_bin(Closure, bin(_, X1, X2), Acc, Ans) :-
        ::apply_transform(Closure, X1, Acc, Acc1),
        ::apply_transform(Closure, X2, Acc1, Ans).  

    :- meta_predicate(all_transform(3, *, *, *)).
    all_transform(Closure, Input, Acc, Ans) :- 
        ::choice_transform(all_transform_bin(Closure), all_transform_empty(Closure), Input, Acc, Ans).


:- end_object.