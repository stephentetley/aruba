% queries.pl

:- use_module(library(csv)).
:- use_module(library(yall)).
:- use_module(library(lists)).

:- use_module(aruba/base/utils).
:- use_module(aruba/file_store/structs).
:- use_module(aruba/file_store/traversals).
:- use_module(aruba/file_store/metrics).
:- use_module(aruba/file_store/operations).


% Note using the module system means we cannot have discontiguous or
% multifile predicates.
% Instead use a renamed import.

:- use_module(
        factbase/directories, 
        [listing/1 as dir_listing]
        ).




% Towards dynamic databases...


% Maybe dynamic databases aren't the thing.
% for the time being "bind" a file_store inside a listing/2 functor.

demo01(Xs) :- 
    dir_listing(Store),
    file_store_kids(Store,Xs).


is_folder(folder_object(_,_,_,_)) :- true.
is_folder(_) :- false.


folder_name(folder_object(Name,_,_,_),Name).



demo02(Xs) :- 
    dir_listing(Store),
    file_store_kids(Store, Kids),
    include(is_folder, Kids, Fs),
    maplist(folder_name, Fs, Xs).


demo03(N) :- 
    dir_listing(Store),
    count_kids(Store, N).



demo04(N) :- 
    dir_listing(Store),
    store_size(Store, N).

%% towards sub_stores.

demo05(Xs) :- 
    dir_listing(Store),
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
    dir_listing(Store),
    sub_stores(Store, Subs),
    maplist(report_store, Subs).

% TODO report should include item count
% empty size can be misleading... 
make_row(Store, Row) :- 
    file_store_path(Store, Path),
    file_store_name(Store, Name),
    store_size(Store, Size),
    format_file_size(Size, SizeName),
    earliest_modification_time(Store, TEarly),
    iso_8601_text(TEarly, SEarly),
    latest_modification_time(Store, TLate),
    iso_8601_text(TLate, SLate),
    count_kids(Store, NKids),
    count_files(Store, NFiles),
    count_folders(Store, NFolders),
    Row = row(Name, Path, NKids, NFiles, NFolders, SizeName, Size, SEarly, SLate).


main :- 
    dir_listing(Store),
    sub_stores(Store, Subs),
    maplist(make_row, Subs, OutputRows),
    Headers = row("Name", "Path", "Kids Count", "File Count", "Folder Count", "Size", "Size (Bytes)", "Earliest Modification Time", "Latest Modification Time"),
    output_csv("..\\data\\rtu.csv", Headers, OutputRows).

temp02 :- 
    split_string("D:\\coding\\fsharp\\factx-fsharp", "\\", "", Xs),
    last(Xs,Last),
    writeln(Last).

temp03 :- 
    dir_listing(Store),
    count_kids(Store, XKids), 
    format("Kids=~d~n", [XKids]), 
    count_files(Store, XFiles), 
    format("Files=~d~n", [XFiles]),
    count_folders(Store, XFolders), 
    format("Folders=~d~n", [XFolders]).


temp04(Stamp) :- 
    dir_listing(Store),
    earliest_modification_time(Store, Stamp).


temp04a(Stamp) :- 
    dir_listing(Store),
    latest_modification_time(Store, Stamp).

