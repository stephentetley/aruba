/* 
    extend_pathp.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- protocol(extend_pathp).

    :- public(extend_path/3).
    :- meta_predicate(extend_path(*, *, *)).
    :- mode(extend_path(+term, +term, -term), one).

:- end_protocol.
