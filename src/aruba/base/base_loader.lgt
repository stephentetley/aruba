/* 
    base_loader.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- use_module(base_utils).

:- initialization(
    logtalk_load([
        string_writer
    ], 
    [optimize(on)])
).

