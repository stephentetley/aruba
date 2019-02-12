% file_metrics.pl

user:file_search_path(aruba, '../src/aruba').
user:file_search_path(factbase, '../src/factbase').

:- use_module(aruba(base/base_utils)).
:- use_module(aruba(file_store/structs)).
:- use_module(aruba(file_store/metrics)).

:- use_module(factbase(directories), [listing/1 as get_store]).

% count_kids 133 + 56 = 189
demo01(N) :- 
    get_store(Store),
    count_kids(Store, N).

% count_files 133
demo02(N) :- 
    get_store(Store),
    count_files(Store, N).

% count_folders 56
demo03(N) :- 
    get_store(Store),
    count_folders(Store, N).



demo04(N) :- 
    get_store(Store),
    store_size(Store, N).

