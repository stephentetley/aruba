/* 
    path.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- object(path, 
    implements(extend_pathp)).
    
    extend_path(Path1, Crumb, [Crumb|Path1]).

    :- public(as_list/2).
    :- mode(as_list(+path, -list), one).
    :- info(as_list/2, [
        comment is 'Converts a path to a list.',
        argnames is ['Path', 'List']
    ]).  

    as_list(Path, Path).

    :- public(as_snoc_path/2).
    :- mode(as_snoc_path(+path, -snoc_path), one).
    :- info(as_snoc_path/2, [
        comment is 'Converts a path to a snoc_path.',
        argnames is ['Path', 'SnocPath']
    ]). 

    as_snoc_path(Path, SnocPath) :- 
        list::reverse(Path, SnocPath).


:- end_object.
