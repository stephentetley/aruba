/*
    objects.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- object(file_object(_Name, _ModificationTime, _Mode, _Size)).
    
    :- public([
        name/1,
		modification_time/1,
		mode/1,
		size/1
    ]).

    name(Ans) :-
        parameter(1,Ans).
    
	modification_time(Ans) :-
        parameter(2,Ans).
	
	mode(Ans) :-
		parameter(3,Ans).
		
	size(Ans) :-
		parameter(4,Ans).

:- end_object.

:- object(folder_object(_Name, _ModificationTime, _Mode, _Kids)).
    
    :- public([
        name/1,
		modification_time/1,
		mode/1,
		kids/1
    ]).

    name(Ans) :-
        parameter(1,Ans).
    
	modification_time(Ans) :-
        parameter(2,Ans).
	
	mode(Ans) :-
		parameter(3,Ans).
		
	kids(Ans) :-
		parameter(4,Ans).

:- end_object.

 
:- object(file_store(_Path, _Kids)).
    
    :- public([
        path/1,
        kids/1
    ]).

    path(Ans) :-
        parameter(1,Ans).
    
    kids(Ans) :-
        parameter(2,Ans).

:- end_object.

:- object(file_store_utils).

    :- public(is_file_object/1).
    is_file_object(Input) :- 
        Input = file_object(_, _, _, _).

:- end_object.


:- object(file_store_traversals,
    implements(walkerp),
    imports(traversals)).

    % implements all_rewrite
    all_rewrite(R1, Input, Ans) :- 
        Input = folder_object(Name, ModificationTime, Mode, Kids),
        ::all_rewrite_list(R1, Kids, Kids1),
        Ans = folder_object(Name, ModificationTime, Mode, Kids1),
        !.

    all_rewrite(_, Ans, Ans) :-
        Ans = file_object(_, _, _, _).

    all_rewrite(R1, Input, Ans) :- 
        Input = file_store(Path, Kids),
        ::all_rewrite_list(R1, Kids, Kids1),
        Ans = file_store(Path, Kids1),
        !.

    % implements all_transform
    all_transform(T1, Input, Acc, Ans) :- 
        Input = folder_object(_, _, _, Kids),
        ::all_transform_list(T1, Kids, Acc, Ans),
        !.

    all_transform(_, Input, Ans, Ans) :-
        Input = file_object(_, _, _, _).

    all_transform(T1, Input, Acc, Ans) :- 
        Input = file_store(_, Kids),
        ::all_transform_list(T1, Kids, Acc, Ans),
        !.

:- end_object. 

