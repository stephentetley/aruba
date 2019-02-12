% queries.pl

user:file_search_path(aruba, '../src/aruba').
user:file_search_path(factbase, '../src/factbase').

:- use_module(library(csv)).
:- use_module(library(yall)).
:- use_module(library(lists)).

:- use_module(aruba(base/base_utils)).
:- use_module(aruba(base/base_traversals)).
:- use_module(aruba(file_store/structs)).
:- use_module(aruba(file_store/traversals)).
:- use_module(aruba(file_store/metrics)).
:- use_module(aruba(file_store/operations)).


% Note using the module system means we cannot have discontiguous or
% multifile predicates.
% Instead use a renamed import.

:- use_module(
        factbase(directories), 
        [listing/1 as get_store]
        ).

dummy1(Ys) :-
    Xs = [2,3,4],
    Ys = [1|Xs].


dummy2(X,Xs) :-
    get_store(Store),
    Store =.. [X|Xs].

append_name(Object, Acc, Xs) :-
    is_file_object(Object),
    file_object_name(Object, Name),
    Xs = [Name|Acc].

append_name(Object, Acc, Xs) :-
    is_folder_object(Object),
    folder_object_name(Object, Name),
    Xs = [Name|Acc].

append_name(Object, Acc, Acc) :-
    is_file_store(Object).



%% PROBLEM - remember Store destructs to [path,kids] not [kids].
demo00(Xs) :-
    get_store(Store),
    file_store_kids(Store,Kids),
    is_list(Kids),    
    any_trafo(append_name, Kids, [], Rev), 
    reverse(Rev,Xs).

demo00a(Xs) :-
    get_store(Store),
    file_store_kids(Store,Kids),  
    alltd_trafo(append_name, Kids, [], Rev), 
    reverse(Rev,Xs).


demo01(Xs) :- 
    get_store(Store),
    file_store_kids(Store,Xs).


is_folder(folder_object(_,_,_,_)) :- true.
is_folder(_) :- false.


folder_name(folder_object(Name,_,_,_),Name).



demo02(Xs) :- 
    get_store(Store),
    file_store_kids(Store, Kids),
    include(is_folder, Kids, Fs),
    maplist(folder_name, Fs, Xs).

% 189 for 'factx-fsharp' file store
demo03(N) :- 
    get_store(Store),
    count_kids(Store, N).



demo04(N) :- 
    get_store(Store),
    store_size(Store, N).


count_kids_aux( _, Acc, N) :- 
    N is Acc + 1.


count_kids_new(Fo, Count) :- 
    alltd_trafo(count_kids_aux, Fo, 0, Count), !.

test10(N1,N2) :- 
    get_store(Store),
    count_kids(Store, N1),
    count_kids_new(Store,N2).

%% towards sub_stores.

demo05(Xs) :- 
    get_store(Store),
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
    get_store(Store),
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
    get_store(Store),
    sub_stores(Store, Subs),
    maplist(make_row, Subs, OutputRows),
    Headers = row("Name", "Path", "Kids Count", "File Count", "Folder Count", "Size", "Size (Bytes)", "Earliest Modification Time", "Latest Modification Time"),
    output_csv("..\\data\\rtu.csv", Headers, OutputRows).

temp02 :- 
    split_string("D:\\coding\\fsharp\\factx-fsharp", "\\", "", Xs),
    last(Xs,Last),
    writeln(Last).

temp03 :- 
    get_store(Store),
    count_kids(Store, XKids), 
    format("Kids=~d~n", [XKids]), 
    count_files(Store, XFiles), 
    format("Files=~d~n", [XFiles]),
    count_folders(Store, XFolders), 
    format("Folders=~d~n", [XFolders]).


temp04(Stamp) :- 
    get_store(Store),
    earliest_modification_time(Store, Stamp).


temp04a(Stamp) :- 
    get_store(Store),
    latest_modification_time(Store, Stamp).

