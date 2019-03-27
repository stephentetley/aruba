/*
    base_logtalk.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

%% Wrap base_utils.pl for Logtalk

:- use_module(library(csv)).
:- use_module(library(date)).

:- object(base_utils).

    :- include('base_utils.pl').

    :- public(iso_8601_stamp/2).  

    :- public(iso_8601_text/2).

:- end_object.