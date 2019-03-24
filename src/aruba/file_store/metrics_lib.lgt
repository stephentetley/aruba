/*
    metrics_lib.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


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
        file_store_traversals::alltd_transform(metrics_lib::count_kids_aux, Fo, 0, Count), !.


    % count_files
    :- public(count_files_aux/3).
    :- mode(count_files_aux(+term, +term, -term), one).
    count_files_aux(Input, Acc, Acc1) :- 
        file_store_structs::is_file_object(Input),
        writeln('count_files_aux - file_object'),        
        Acc1 is Acc + 1.

    count_files_aux(_, Acc, Acc) :-
        writeln('count_files_aux - other').

    :- public(count_files/2).
    count_files(Fo, Count) :- 
        writeln('count_files'),
        file_store_traversals::alltd_transform(metrics_lib::count_files_aux, Fo, 0, Count), 
        !.

:- end_object.	