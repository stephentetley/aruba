/* 
    demo.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  


% Use the Prolog test module directly
% Wrapping it in a Logtalk object is a bit pyrrhic as it only exposes 
% a single compund atom _listing_.
:- use_module(factbase/directories).

:- object(demo).

    :- public(test01/1).
    test01(Ans) :- 
        directories::listing(Ans).


    :- public(test02a/0).
    test02a :- 
        file_store_structs::is_file_object(file_object("actions_xsb.pl", "2018-05-18T09:51:00", '-a----', 115)).

    :- public(test02b/0).
    test02b :- 
        file_store_structs::is_file_object(folder_object("notes", "2018-07-30T10:52:00", 'd-----', [])).
    
    :- public(test02c/0).
    test02c :- 
        file_store_structs::is_folder_object(folder_object("notes", "2018-07-30T10:52:00", 'd-----', [])).

    :- public(test03/1).
    test03(Ans) :-         
        directories::listing(Store),
        metrics_lib::count_files(Store, Ans).

    :- public(test03a/1).
    test03a(Ans) :-         
        directories::listing(Store),
        metrics_lib::count_files_aux(Store, 0, Ans).     

    :- public(test03b/1).
    test03b(Ans) :-         
        directories::listing(Store),
        file_store_transform::all_transform(count_files_aux, Store, 0, Ans).    


    :- public(test04/1).
    test04(Ans) :-         
        directories::listing(Store),
        file_store_rewrite::id_rewrite(Store, Ans).

    :- public(test05/1).
    test05(Ans) :-         
        directories::listing(Store),
        file_store_rewrite::alltd_rewrite(file_store_traversals::id_rewrite, Store, Ans).

    :- public(test06/1).
    test06(Ans) :-         
        directories::listing(Store),
        metrics_lib::count_kids(Store, Ans).

    :- public(test07/1).
    test07(Ans) :-         
        directories::listing(Store),
        metrics_lib::count_folders(Store, Ans).

    :- public(test08/1).
    test08(Ans) :-         
        directories::listing(Store),
        metrics_lib::store_size(Store, Ans).

    :- public(test09/1).
    test09(Ans) :-         
        directories::listing(Store),
        metrics_lib::latest_modification_time(Store, Ans).

    :- public(test09a/1).
    test09a(Ans) :- 
        base_utils::iso_8601_stamp("2018-05-18T09:51:00", Ans).

    :- public(test09b/1).
    test09b(Ans) :- 
        metrics_lib::latest_modification_aux(file_object("assetnames.pl", "2018-07-19T10:34:00", '-a----', 758496), 1526637060.0, Ans).

:- end_object.







