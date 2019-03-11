/*
    traversals.pl
    Copyright (c) Stephen Tetley 2018,2019
    License: BSD 3 Clause
*/    


:- module(traversals, 
            [ all_transform/4
            , all_rewrite/3
            , any_transform/4
            , any_rewrite/3
            , one_transform/4
            , one_rewrite/3
            , alltd_rewrite/3
            , alltd_transform/4

            ]).

%% Unfortuately we can't rely on Prolog's Univ if we want to replicate
%% KURE. We need to put the "universe" of traversals under user control.

user:file_search_path(aruba_base, '../base').

:- use_module(aruba_base(base_traversals)).
:- use_module(structs).

% See SWI Manual section 6.4 Deining a meta-predicate

:- meta_predicate
    all_transform(3,+,+,-), 
    all_rewrite(2,+,-), 
    any_transform(3,+,+,-), 
    any_rewrite(2,+,-), 
    one_transform(3,+,+,-), 
    one_rewrite(2,+,-), 

    alltd_rewrite(2,+,-),
    alltd_transform(3,+,+,-).

lift_rewrite(R1, Input, _, Ans) :- 
    call(R1, Input, Ans).

%% Transform all children

all_transform(_, file_object(_,_,_,_), Acc, Acc).
    
all_transform(T1, folder_object(_,_,_,Kids), Acc, Ans) :-
    all_transform_list(T1, Kids, Acc, Ans).

all_transform(T1, file_store(_,Kids), Acc, Ans) :-
    all_transform_list(T1, Kids, Acc, Ans).

all_rewrite(R1, Input, Ans) :- 
    all_transform(lift_rewrite(R1), Input, _, Ans).

%% Transform some children (where the transform is successful)

any_transform(_, file_object(_,_,_,_), _, false).
    
any_transform(T1, folder_object(_,_,_,Kids), Acc, Ans) :-
    any_transform_list(T1, Kids, Acc, Ans).

any_transform(T1, file_store(_,Kids), Acc, Ans) :-
    any_transform_list(T1, Kids, Acc, Ans).

any_rewrite(R1, Input, Ans) :- 
    any_transform(lift_rewrite(R1), Input, _, Ans).

%% Transform a single child

one_transform(_, file_object(_,_,_,_), _, false).
    
one_transform(T1, folder_object(_,_,_,Kids), Acc, Ans) :-
    one_transform_list(T1, Kids, Acc, Ans).

one_transform(T1, file_store(_,Kids), Acc, Ans) :-
    one_transform_list(T1, Kids, Acc, Ans).

one_rewrite(R1, Input, Ans) :- 
    one_transform(lift_rewrite(R1), Input, _, Ans).


%% alltd_rewrite

alltd_rewrite(R1, Input, Ans) :-
    is_file_object(Input),
    apply_rewrite(R1, Input, Ans).

alltd_rewrite(R1, Input, Ans) :-
    is_folder_object(Input),
    apply_rewrite(R1, Input, A1),
    folder_object_kids(A1, Kids1),
    all_rewrite_list(alltd_rewrite(R1), Kids1, Kids2),
    set_folder_object_field(kids(Kids2), A1, Ans).

alltd_rewrite(R1, Input, Ans) :-
    is_file_store(Input),
    apply_rewrite(R1, Input, A1),
    file_store_kids(A1, Kids1),
    all_rewrite_list(alltd_rewrite(R1), Kids1, Kids2),
    set_file_store_field(kids(Kids2), A1, Ans).


%% alltd_transform

alltd_transform(T1, Input, Acc, Ans) :-
    is_file_object(Input),
    apply_transform(T1, Input, Acc, Ans).

alltd_transform(T1, Input, Acc, Ans) :-
    is_folder_object(Input),
    apply_transform(T1, Input, Acc, A1),
    folder_object_kids(Input, Kids1),
    all_transform_list(alltd_transform(T1), Kids1, A1, Ans).
    
alltd_transform(T1, Input, Acc, Ans) :-
    is_file_store(Input),
    apply_transform(T1, Input, Acc, A1),
    file_store_kids(Input, Kids1),
    all_transform_list(alltd_transform(T1), Kids1, A1, Ans).    