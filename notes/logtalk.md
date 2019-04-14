# Notes



In VS Code start a terminal, change directory to test\file_store

    > cd test\file_store

Run the SWI Prolog toplevel (must include the ampersand):

    > & 'C:\Program Files\swipl\bin\swipl.exe'

Load Logtalk:

    ?- use_module(library(logtalk)).

Load all files:

    ?- logtalk_load('loader.lgt').

Alteratively:

    ?- {loader}.

Dummy:

    ?- {'factbase/site_work_sorted.pl'}.
    ?- site_work_sorted::listing(Y), metrics_lib::count_kids(Y, Ans).

Hiding variables:

    ?- use_module(library(yall)).
    ?- {Ans}/(site_work_sorted::listing(X), listing(X)::latest_modifaction_time(Ans)).
