/* 
    demo_list_kids.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  

% make this dynamic once working...
:- use_module(factbase/directories).

% Test...
% ?- {Ans}/(directories::listing(X), list_kids::list_kids(X, Ans)).

% Favour passing in the Store as an argument.
% A parameterized object doesn't have a good "calling convention".

:- object(demo_list_kids).


    :- public(test01/1).
    test01(Ans) :- 
        directories::listing(Ans).

    :- public(cons_name/3).
    cons_name(Input, Acc, Acc1) :- 
        file_store_structs::is_folder_object(Input),
        Input::name(Name),
        Acc1 = [ Name | Acc ].

    cons_name(_, Acc, Acc).

    :- public(list_backwards/2).
    list_backwards(Store, Ans) :- 
        file_store_traversals::all_transform(list_kids::cons_name, Store, [], Ans).


    :- public(add_name/3).
    add_name(Input, DL1, DL2) :- 
        file_store_structs::is_folder_object(Input),
        Input::name(Name),
        difflist::add(Name,DL1, DL2).

    add_name(_, Acc, Acc).

    :- public(list_kids/2).
    list_kids(Store, Ans) :- 
        file_store_traversals::all_transform(list_kids::add_name, Store, (X0-X0), DL),
        difflist::as_list(DL, Ans).


:- end_object.

% {Ans}/(rtu_firmware::listing(X), list_kids_simple::list1(X,Ans)).
