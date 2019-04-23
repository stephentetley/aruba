# Notes



In VS Code start a terminal, change directory to test\file_store

    > cd test\file_store

Run the SWI Prolog toplevel (must include the ampersand):

    > & 'C:\Program Files\swipl\bin\swipl.exe'

Load Logtalk:

    ?- use_module(library(logtalk)).

Load all files:

    ?- logtalk_load('file_store_test_loader.lgt').

Alteratively:

    ?- {file_store_test_loader}.

Dummy:

    ?- {'factbase/site_work_sorted.pl'}.
    ?- site_work_sorted::listing(Y), metrics_lib::count_kids(Y, Ans).

Hiding variables:

    % Swi-Prolog Yall...
    ?- use_module(library(yall)).

    % Logtalk...
    ?- {library(metapredicates_loader)}.

    % or...
    ?- logtalk_load(library(metapredicates_loader)).

    % Action - load a larage examples file...
    ?- {'factbase/site_work_sorted.pl'}.

    % Run a query, X not shown...
    ?- {Ans}/(site_work_sorted::listing(X), listing(X)::latest_modifaction_time(Ans)).

    % X show, too much output...
    ?- site_work_sorted::listing(X), listing(X)::latest_modifaction_time(Ans).
