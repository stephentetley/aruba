% record_test1.pl

user:file_search_path(aruba, '../src/aruba').

:- use_module(aruba(file_store/structs)).



file_object('Chamber 001.JPG', "2018-06-29T11:05:00", '-a---', 1024).
file_object('Chamber 002.JPG', "2018-06-29T11:06:00", '-a---', 1024).

demo01(Ts):- 
    findall(X, file_object(_,X,_,_), Ts).

% Direct accessor
% demo02(Ts):- 
%     findall(T, (file_object(_,X), properties_modification_time(X,T)), Ts).

% Field label accessor
% demo03(Ts):- 
%     findall(T, (file_object(_,X), properties_data(mode,X,T)), Ts).