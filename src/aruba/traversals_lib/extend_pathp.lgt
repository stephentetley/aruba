/* 
    extend_pathp.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- protocol(extend_pathp).

    :- public(extend_path/3).
    :- mode(extend_path(+term, +term, -term), one).
    :- info(extend_path/3, [
            comment is 'Extend the path by a crumb',
            argnames is ['Path1', 'Crumb', 'Path']
        ]).

:- end_protocol.
