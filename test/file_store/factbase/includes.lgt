/*
    includes.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- object(test_data).

    %% Happily we can include Prolog files with SWI specific modules.

    :- include('directories.pl').

    :- public([listing/1]).

:- end_object.