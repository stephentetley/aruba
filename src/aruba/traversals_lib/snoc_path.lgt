/* 
    snoc_path.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- use_module(library(lists)).

:- object(snoc_path, 
    implements(extend_pathp)).

    extend_path(Path1, Crumb, [Crumb|Path1]).
        
    :- public(as_list/2).
    :- mode(as_list(+snoc_list, -list), one).
    :- info(as_list/2, [
        comment is 'Converts a snoc_path to a list.',
        argnames is ['SnocPath', 'List']
    ]).  
    
    as_list(SnocList, List) :- 
        list::reverse(SnocList, List).

    :- public(as_path/2).
    :- mode(as_path(+snoc_path, -path), one).
    :- info(as_path/2, [
        comment is 'Converts a snoc_path to a path.',
        argnames is ['SnocPath', 'Path']
    ]). 

    as_snoc_path(SnocPath, Path) :- 
        list::reverse(SnocPath, Path).

    
:- end_object.
