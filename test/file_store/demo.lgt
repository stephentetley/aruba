/* 
    loader.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  

:- object(test).

	:- public(demo1/1).
	demo1(Ans) :- 
		test_data::listing(Ans).

:- end_object.

