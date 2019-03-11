/*
    traversals.pl
    Copyright (c) Stephen Tetley 2018,2019
    License: BSD 3 Clause
*/    


:- module(traversals, 
            [ 
            
            /* file_object_transform/4, 
              file_object_rewrite/3
            , all_folder_object_transform/5
            , all_folder_object_rewrite/3
            , any_folder_object_transform/5
            , any_folder_object_rewrite/3
            , one_folder_object_transform/5
            , one_folder_object_rewrite/3
            , all_file_store_transform/5
            */

              alltd_rewrite/3
            , alltd_transform/4

            ]).

%% Unfortuately we can't rely on Prolog's Univ if we want to replicate
%% KURE. We need to put the "universe" of traversals under user control.

user:file_search_path(aruba_base, '../base').

:- use_module(aruba_base(base_traversals)).
:- use_module(structs).

% See SWI Manual section 6.4 Deining a meta-predicate

:- meta_predicate
    /* file_object_transform(6,+,+,-),
    file_object_rewrite(2,+,-),
    all_folder_object_transform(3,5,+,+,-),
    all_folder_object_rewrite(3,+,-),
    any_folder_object_transform(3,5,+,+,-),
    any_folder_object_rewrite(3,+,-),
    one_folder_object_transform(3,5,+,+,-),
    one_folder_object_rewrite(3,+,-),
    all_file_store_transform(3,3,+,+,-),
    */
    alltd_rewrite(2,+,-),
    alltd_transform(3,+,+,-).


% So-called congruence combinators

% Because we have no mzero (c.f KURE) we must always define traversals with an accumulator

lift_rewrite(R1, Input, _, Ans) :-
    call(R1, Input, Ans).

% No kids
% Build1 : string * timestamp * props * int * Acc -> Ans 
/* file_object_transform(Build, Input, Acc, Ans) :-
    call(Build, Name, Time, Props, Size, Acc, Ans). 

% T1 : file_object -> file_onject
file_object_rewrite(R1, Input, Ans) :- 
    apply_rewrite(R1, Input, Ans).

% T1 : (folder_object | file_object) * Acc -> Ans
% Build : string * timestamp * props * Acc -> Ans 
all_folder_object_transform(T1, Build, folder_object(Name, Time, Props, Kids), Acc, Ans) :-
    all_transform_list(T1, Kids, Acc, A1),
    call(Build, Name, Time, Props, A1, Ans).

all_folder_object_rewrite(R1, Input, Ans) :- 
    all_folder_object_transform(lift_rewrite(R1), cons_folder_object, Input, false, Ans).

any_folder_object_transform(T1, Build, folder_object(Name, Time, Props, Kids), Acc, Ans) :-
    any_transform_list(T1, Kids, Acc, A1),
    call(Build, Name, Time, Props, A1, Ans).

any_folder_object_rewrite(R1, Input, Ans) :- 
    any_folder_object_transform(lift_rewrite(R1), cons_folder_object, Input, false, Ans).

one_folder_object_transform(T1, Build, folder_object(Name, Time, Props, Kids), Acc, Ans) :-
    one_transform_list(T1, Kids, Acc, A1),
    call(Build, Name, Time, Props, A1, Ans).

one_folder_object_rewrite(R1, Input, Ans) :- 
    one_folder_object_transform(lift_rewrite(R1), cons_folder_object, Input, false, Ans).


% T1 : (folder_object | file_object) * Acc -> Ans
% Build : string * Acc -> Ans 
all_file_store_transform(T1, Build, file_store(Path, Kids), Acc, Ans) :-
    all_transform_list(T1, Kids, Acc, A1),
    call(Build, Path, A1, Ans).

all_file_store_rewrite(R1, Input, Ans) :- 
    all_file_store_transform(lift_rewrite(R1), cons_file_store, Input, false, Ans).
*/

%% alltd_rewrite

alltd_rewrite(R1, Input, Ans) :-
    is_file_object(Input),
    apply_rewrite(R1, Input, Ans).

alltd_rewrite(R1, Input, Ans) :-
    is_folder_object(Input),
    apply_rewrite(R1, Input, A1),
    A1 = folder_object(Name, Time, Mode, Kids1),
    all_rewrite_list(alltd_rewrite(R1), Kids1, Kids2),
    cons_folder_object(Name, Time, Mode, Kids2, Ans).

alltd_rewrite(R1, Input, Ans) :-
    is_file_store(Input),
    apply_rewrite(R1, Input, A1),
    A1 = file_store(Path1, Kids1),
    all_rewrite_list(alltd_rewrite(R1), Kids1, Kids2),
    cons_file_store(Path1, Kids2, Ans).


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