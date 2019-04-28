/* 
    demo_csv.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  

:- use_module(library(csv)).

:- object(demo_csv).

	:- public(get_worklist/1).
	get_worklist(Rows) :- 
    	csv::csv_read_file("../../proprietary/rtu_year5_site_list.csv", [_| Rows]).  

	:- public(get_sainumber/2).
	get_sainumber(Row,Sai) :- 
		base_utils::nth0_cell(0, Row, Sai).

	:- public(get_info/2).
	get_info(Row, Ans) :- 
		base_utils::nth0_cell(0, Row, Sai),
		base_utils::nth0_cell(2, Row, Name),
		Ans = info{ sai:Sai, name:Name }.


	:- public(identity/2).
	identity(X,X).

	:- public(test01/1).
	test01(Xs) :- 
		get_worklist(Rows),
		meta::map( ::identity, Rows, Xs).

	:- public(test2/1).
	test02(Xs) :- 
		get_worklist(Rows),
		meta::map( ::get_sainumber, Rows, Xs).

	:- public(test3/1).
	test03(Xs) :- 
		get_worklist(Rows),
		meta::map( demo_csv::get_info, Rows, Xs).

:- end_object.


% ?- demo_csv::get_worklist(Xs), meta::map(demo_csv::identity, Xs, Ans).

