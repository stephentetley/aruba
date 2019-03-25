/*
    metrics_lib.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

% NOTE
% aux functions have to be public (protected dosn't work).

:- object(metrics_lib).

    :- public(count_kids_aux/3).
    :- mode(count_kids_aux(+term, +term, -term), one).
    count_kids_aux(folder_object(_,_,_,_), Acc, N) :- 
        N is Acc + 1.
        
    count_kids_aux(file_object(_,_,_,_), Acc, N) :- 
        N is Acc + 1.
    
    count_kids_aux(_, Acc, Acc).
    
    :- public(count_kids/2).
    count_kids(Fo, Count) :- 
        file_store_traversals::alltd_transform(metrics_lib::count_kids_aux, Fo, 0, Count), 
        !.


    % count_files
    :- public(count_files_aux/3).
    :- mode(count_files_aux(+term, +term, -term), one).
    count_files_aux(Input, Acc, Acc1) :- 
        file_store_structs::is_file_object(Input),        
        Acc1 is Acc + 1.

    count_files_aux(_, Acc, Acc).

    :- public(count_files/2).
    count_files(Fo, Count) :- 
        file_store_traversals::alltd_transform(metrics_lib::count_files_aux, Fo, 0, Count), 
        !.

    % count_folders
    :- public(count_folders_aux/3).
    :- mode(count_folders_aux(+term, +term, -term), one).
    count_folders_aux(Input, Acc, Acc1) :- 
        file_store_structs::is_folder_object(Input),        
        Acc1 is Acc + 1.

        count_folders_aux(_, Acc, Acc).

    :- public(count_folders/2).
    count_folders(Fo, Count) :- 
        file_store_traversals::alltd_transform(metrics_lib::count_folders_aux, Fo, 0, Count), 
        !.

    % store_size
    :- public(store_size_aux/3).
    :- mode(store_size_aux(+term, +term, -term), one).
    store_size_aux(file_object(_,_,_,Sz), Acc, N) :- 
        N is Acc + Sz.

    store_size_aux(_, A, A).

    :- public(store_size/2).
    store_size(Store, Size) :-
        file_store_traversals::alltd_transform(metrics_lib::store_size_aux, Store, 0, Size), !.

    % latest_modification_time
    :- public(latest_modification_aux/3).
    :- mode(latest_modification_aux(+term, +term, -term), one).
    latest_modification_aux(file_object(_, Stamp, _, _), T0, Latest) :-
        { iso_8601_stamp(Stamp, T1) }, 
        Latest is max(T0, T1).

    latest_modification_aux(folder_object(_, Stamp, _, _), T0, Latest) :- 
        { iso_8601_stamp(Stamp, T1) },
        Latest is max(T0, T1).
        
    :- public(latest_modification_time/2).
    latest_modification_time(Store, Stamp) :-
        file_store_traversals::alltd_transform(metrics_lib::latest_modification_aux, Store, 0, Stamp), !.

:- end_object.	