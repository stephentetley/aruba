% file_traversals.pl

user:file_search_path(aruba_base, '../../src/aruba/base').
user:file_search_path(file_store, '../../src/aruba/file_store').
user:file_search_path(factbase, 'factbase').

:- use_module(aruba_base(base_utils)).
:- use_module(aruba_base(base_traversals)).
:- use_module(file_store(structs)).
:- use_module(file_store(traversals)).
:- use_module(file_store(metrics)).

:- use_module(factbase(directories), [listing/1 as get_store]).

anon(Input, Ans) :- 
    is_folder_object(Input),
    set_folder_object_field(name(""), Input, Ans), !.

anon(Input, Ans) :- 
    is_file_object(Input),
    set_file_object_field(name(""), Input, Ans), !.

anon(Input, Ans) :- 
    is_file_store(Input),
    Ans = Input.

demo0(Ans) :- 
    Input = file_object("actions_xsb.pl", "2018-05-18T09:51:00", '-a----', 115),
    apply_rewrite(anon, Input, Ans), !.

demo0b(Ans) :- 
    Input = file_object("actions_xsb.pl", "2018-05-18T09:51:00", '-a----', 115),
    anon(Input, Ans).

demo01(Ans) :- 
    get_store(Store),
    alltd_rewrite(anon, Store, Ans), !.
