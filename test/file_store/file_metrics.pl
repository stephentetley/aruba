% file_metrics.pl

user:file_search_path(aruba_base, '../../src/aruba/base').
user:file_search_path(file_store, '../../src/aruba/file_store').
user:file_search_path(factbase, 'factbase').

:- use_module(aruba_base(base_utils)).
:- use_module(file_store(structs)).
:- use_module(file_store(metrics)).

:- use_module(factbase(directories), [listing/1 as get_store]).

demo0(X) :- 
    Input = file_object("actions_xsb.pl", "2018-05-18T09:51:00", '-a----', 115),
    ( is_file_object(Input) -> write_ln("okay")),    
    count_files(Input,X).

demo0b(X) :- 
    Input = file_object("actions_xsb.pl", "2018-05-18T09:51:00", '-a----', 115),
    file_object_name(Input,X).

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

