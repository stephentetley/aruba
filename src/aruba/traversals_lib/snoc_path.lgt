/* 
    snoc_path.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- object(snoc_path, 
    implements(extend_pathp)).

    extend_path(Path1, Crumb, [Crumb|Path1]).
        
	
:- end_object.
