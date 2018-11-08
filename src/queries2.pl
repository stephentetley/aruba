% queries.pl

:- use_module(library(yall)).

:- use_module(aruba/file_store/structs).
:- use_module(aruba/file_store/metrics).
:- use_module(aruba/file_store/operations).

:- use_module(factbase/directories).


% Towards dynamic databases...


% Maybe dynamic databases aren't the thing.
% for the time being "bind" a file_store inside a listing/2 functor.

demo01(Xs) :- 
    listing('directories',Store),
    file_store_kids(Store,Xs).


is_folder(folder_object(_,_,_,_)) :- true.
is_folder(_) :- false.


folder_name(folder_object(Name,_,_,_),Name).



demo02(Xs) :- 
    listing('directories', Store),
    file_store_kids(Store, Kids),
    include(is_folder, Kids, Fs),
    maplist(folder_name, Fs, Xs).


demo03(N) :- 
    listing('directories', Store),
    count_kids(Store, N).



demo04(N) :- 
    listing('directories', Store),
    store_size(Store, N).

%% towards sub_stores.

demo05(Xs) :- 
    listing('directories', Store),
    sub_stores(Store, Xs).

report_store(Store) :- 
    file_store_path(Store,Path),
    store_size(Store,Size),
    format("'~w': size=~d ~n", [Path,Size]).

demo06 :- 
    listing('directories', Store),
    sub_stores(Store, Subs),
    maplist(report_store, Subs).


