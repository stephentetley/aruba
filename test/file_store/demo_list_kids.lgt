/* 
    demo_list_kids.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  

% make this dynamic once working...
:- use_module(factbase/directories).


:- object(list_kids_simple).


	:- public(test01/1).
	test01(Ans) :- 
		directories::listing(Ans).

	:- public(cons_name/3).
	cons_name(Input, Acc, Acc1) :- 
		file_store_structs::is_folder_object(Input),
		Input::name(Name),
		Acc1 = [ Name | Acc ].

	cons_name(_, Acc, Acc).

	:- public(list1/1).
	list1(Ans) :- 
		directories::listing(Store),
		file_store_traversals::all_transform(list_kids_simple::cons_name, Store, [], Ans).

:- end_object.

:- object(list_kids(_Filestore)).


	:- public(test01/1).
	test01(Ans) :- 
		parameter(1, Store),
		Ans = Store.

	:- public(cons_folder_name/3).
	cons_folder_name(Input, Acc, Acc1) :- 
		file_store_structs::is_folder_object(Input),
		Input::name(Name),
		Acc1 = [ Name | Acc ].

	cons_folder_name(_, Acc, Acc).

	% This works (i.e produces output) but the calling is wrong "aesthetically" for cons_folder_name
	% Probably we don't want a parameterized object.
	% Instead, we might want, e.g.:  list1(Store, Ans) :- ...
	:- public(list1/1).
	list1(Ans) :- 
		parameter(1, Store),
		file_store_traversals::all_transform(list_kids(Store)::cons_folder_name, Store, [], Ans).

:- end_object.


% ?- {'../../proprietary/rtu_firmware.pl'}.
% ?- {Ans}/(rtu_firmware::listing(X), list_kids(X)::list1(Ans)).