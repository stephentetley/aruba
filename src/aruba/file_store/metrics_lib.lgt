/*
    metrics_lib.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- object(metrics_lib).


    % count_files

    count_files_aux(Input, Acc, Acc1) :- 
        (   file_store_utils::is_file_object(Input)
        ->  Acc1 is Acc + 1
        ;   Acc1 is Acc
        ).

:- end_object.	