% record_test1.pl


:- use_module(aruba/file_store/structs).



file_object('Chamber 001.JPG', properties("2018-06-29T11:05:00", '-a---')).
file_object('Chamber 002.JPG', properties("2018-06-29T11:06:00", '-a---')).

demo01(Props):- 
    findall(X, file_object(_,X), Props).

% Direct accessor
demo02(Ts):- 
    findall(T, (file_object(_,X), properties_modification_time(X,T)), Ts).

% Field label accessor
demo03(Ts):- 
    findall(T, (file_object(_,X), properties_data(mode,X,T)), Ts).