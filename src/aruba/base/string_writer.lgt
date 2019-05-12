/*
    string_writer.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- object(string_writer).

    :- public(as_string/2).
    :- mode(as_string(+string_builder, -string), one).
    as_list(X-X, "").
/*     as_list(List-Back, String) :-
        (	List == Back ->
            Out = []
        ;	Out = [Head| Tail],
            List = [Head| Rest],
            as_list(Rest-Back, Tail)
        ). */

:- end_object.	