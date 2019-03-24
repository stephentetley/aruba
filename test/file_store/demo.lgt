/* 
    loader.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  

:- object(test).

    :- public(demo01/1).
    demo01(Ans) :- 
        test_data::listing(Ans).


    :- public(demo02a/0).
    demo02a :- 
        file_store_utils::is_file_object(file_object("actions_xsb.pl", "2018-05-18T09:51:00", '-a----', 115)).

    :- public(demo02b/0).
    demo02b :- 
        file_store_utils::is_file_object(folder_object("notes", "2018-07-30T10:52:00", 'd-----', [])).
    
:- end_object.

