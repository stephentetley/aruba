/*
    file_store_metrics.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

% NOTE
% aux functions have to be public (protected doesn't work).

:- object(file_store_metrics).

    :- uses(file_store_transform, [all_transform/4]).


    :- public(count_kids_aux/3).
    :- mode(count_kids_aux(+term, +term, -term), one).
    :- meta_predicate(count_kids_aux(*, *, *)).
    
    count_kids_aux(folder_object(_,_,_,_), Acc, N) :- 
        writeln("count_kids_aux folder"),
        N is Acc + 1.
        
    count_kids_aux(file_object(_,_,_,_), Acc, N) :- 
        writeln("count_kids_aux file"),
        N is Acc + 1.
    
    count_kids_aux(_, Acc, Acc) :- 
        writeln("count_kids_aux _").
    
    :- public(count_kids/2).
    count_kids(Fo, Count) :- 
        % file_store_traversals::alltd_transform(count_kids_aux, Fo, 0, Count), 
        all_transform(count_kids_aux, Fo, 0, Count), 
        !.


    % count_files
    % :- public(count_files_aux/3).
    % :- mode(count_files_aux(+term, +term, -term), one).
    :- meta_predicate(count_files_aux(*, *, *)).

    count_files_aux(Input, Acc, Acc1) :- 
        file_store_structs::is_file_object(Input),        
        Acc1 is Acc + 1.

    count_files_aux(_, Acc, Acc).

    :- public(count_files/2).
    count_files(Fo, Count) :- 
        file_store_transform::alltd_transform(file_store_metrics::count_files_aux, Fo, 0, Count), 
        !.

    % count_folders
    :- public(count_folders_aux/3).
    :- mode(count_folders_aux(+term, +term, -term), one).
    count_folders_aux(Input, Acc, Acc1) :- 
        file_store_structs::is_folder_object(Input),        
        Acc1 is Acc + 1.

    %% fall through case
    count_folders_aux(_, Acc, Acc).

    :- public(count_folders/2).
    count_folders(Fo, Count) :- 
        file_store_transform::alltd_transform(file_store_metrics::count_folders_aux, Fo, 0, Count), 
        !.

    % store_size
    :- public(store_size_aux/3).
    :- mode(store_size_aux(+term, +term, -term), one).
    store_size_aux(file_object(_,_,_,Sz), Acc, N) :- 
        N is Acc + Sz.

    store_size_aux(_, A, A).

    :- public(store_size/2).
    store_size(Store, Size) :-
        file_store_transform::alltd_transform(file_store_metrics::store_size_aux, Store, 0, Size), !.

    % latest_modification_time
    :- public(latest_modification_time_aux/3).
    :- meta_predicate(latest_modification_time_aux(*, *, *)).
    :- mode(latest_modification_time_aux(+term, +term, -term), one).
    latest_modification_time_aux(file_object(_, Stamp, _, _), T0, Latest) :-
        base_utils::iso_8601_stamp(Stamp, T1), 
        Latest is max(T0, T1),
        !.
        
    latest_modification_time_aux(folder_object(_, Stamp, _, _), T0, Latest) :- 
        base_utils::iso_8601_stamp(Stamp, T1),
        Latest is max(T0, T1), 
        !.

    latest_modification_time_aux(Obj, T0, T0) :- 
        file_store_structs::is_file_store(Obj), !.
        
    :- public(latest_modification_time/2).
    latest_modification_time(Store, Time) :-
        file_store_transform::alltd_transform(file_store_metrics::latest_modification_time_aux, Store, 0, Stamp), 
        base_utils::iso_8601_text(Stamp, Time),
        !.

:- end_object.	

      
