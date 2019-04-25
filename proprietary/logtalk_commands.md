# Setting up

At the terminal

    > cd test\file_store

    > & 'C:\Program Files\swipl\bin\swipl.exe'

    ?- use_module(library(logtalk)).

    ?- logtalk_load(library(metapredicates_loader)).

    ?- logtalk_load('file_store_test_loader.lgt').

    ?- {'../../proprietary/rtu_firmware.pl'}.

    ?- {Ans}/(rtu_firmware::listing(X), listing(X)::latest_modification_time(Ans)).

    ?- {Ans}/(rtu_firmware::listing(X), metrics_lib::latest_modification_time(X, Ans)).

    ?- {'../../src/aruba/base/base_utils.pl'}.
