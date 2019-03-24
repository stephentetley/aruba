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
        file_store_structs::is_file_object(file_object("actions_xsb.pl", "2018-05-18T09:51:00", '-a----', 115)).

    :- public(demo02b/0).
    demo02b :- 
        file_store_structs::is_file_object(folder_object("notes", "2018-07-30T10:52:00", 'd-----', [])).
    
    :- public(demo02c/0).
    demo02c :- 
        file_store_structs::is_folder_object(folder_object("notes", "2018-07-30T10:52:00", 'd-----', [])).

    :- public(demo03/1).
    demo03(Ans) :-         
        test_data::listing(Store),
        metrics_lib::count_files(Store, Ans).

    :- public(demo03a/1).
    demo03a(Ans) :-         
        test_data::listing(Store),
        metrics_lib::count_files_aux(Store, 0, Ans).     

    :- public(demo03b/1).
    demo03b(Ans) :-         
        test_data::listing(Store),
        file_store_traversals::all_transform(count_files_aux, Store, 0, Ans).    


    :- public(demo04/1).
    demo04(Ans) :-         
        test_data::listing(Store),
        file_store_traversals::id_rewrite(Store, Ans).

    :- public(demo05/1).
    demo05(Ans) :-         
        test_data::listing(Store),
        file_store_traversals::alltd_rewrite(file_store_traversals::id_rewrite, Store, Ans).

    :- public(demo06/1).
    demo06(Ans) :-         
        test_data::listing(Store),
        metrics_lib::count_kids(Store, Ans).

    :- public(demo06a/1).
    demo06a(Ans) :-         
        test_data::listing(Store),
        metrics_lib::count_kids_aux(Store, 0, Ans). 
    
    :- public(demo06b/1).
    demo06b(Ans) :-         
        test_data::listing(Store),
        file_store_traversals::all_transform(count_kids_aux, Store, 0, Ans).  

:- end_object.

