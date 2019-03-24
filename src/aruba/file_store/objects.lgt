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