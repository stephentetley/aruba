% queries.pl

:- use_module(library(csv)).
:- use_module(library(yall)).
:- use_module(library(lists)).

:- use_module(aruba/base/utils).
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
    latest_modification_time(Store,T),
    iso_8601_text(T,Datetime),
    format("'~w': size=~d, time=~w ~n", [Path,Size,Datetime]).

   
temp01:- 
    iso_8601_text(1535712600.000000,Text), 
    format("~w", [Text]).


demo06 :- 
    listing('directories', Store),
    sub_stores(Store, Subs),
    maplist(report_store, Subs).

 
make_row(Store, Row) :- 
    file_store_path(Store, Path),
    file_store_name(Store, Name),
    store_size(Store, Size),
    latest_modification_time(Store, T),
    iso_8601_text(T, Datetime),
    Row = row(Name, Path, Size, Datetime).


main :- 
    listing('directories', Store),
    sub_stores(Store, Subs),
    maplist(make_row, Subs, OutputRows),
    Headers = row("Name", "Path", "Size", "Latest Modification Time"),
    output_csv("..\\data\\projects.csv", Headers, OutputRows).

temp02 :- 
    split_string("D:\\coding\\fsharp\\factx-fsharp", "\\", "", Xs),
    last(Xs,Last),
    writeln(Last).
