# Notes

In VS Code start a terminal, change directory to test\file_store

    > cd test\file_store

If you forget this before running SWI Prolog you can use chdir/1 to move to
the test directory.

Run the SWI Prolog toplevel (must include the ampersand):

    > & 'C:\Program Files\swipl\bin\swipl.exe'

Load Logtalk:

    ?- use_module(library(logtalk)).

Load all files:

    ?- logtalk_load('demo_loader.lgt').

Alteratively:

    ?- {demo_loader}.

Load a demo:

    ?- {demo}.

Dummy:

    ?- {'factbase/site_work_sorted.pl'}.
    ?- site_work_sorted::listing(Y), metrics_lib::count_kids(Y, Ans).

Hiding variables:

    % Swi-Prolog Yall...
    ?- use_module(library(yall)).

    % Logtalk (this is already loaded by the demos loader)...
    ?- {library(metapredicates_loader)}.

    % or...
    ?- logtalk_load(library(metapredicates_loader)).

    % Action - load a larage examples file...
    ?- {'factbase/site_work_sorted.pl'}.

    % Run a query, Ans shown, X not shown...
    ?- {Ans}/(site_work_sorted::listing(X), listing(X)::latest_modification_time(Ans)).

    % X show, too much output...
    ?- site_work_sorted::listing(X), listing(X)::latest_modification_time(Ans).
