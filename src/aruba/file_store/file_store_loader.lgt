/* 
    file_store_loader.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- use_module(file_store_structs).

:- initialization(
    logtalk_load([
        file_store_rewrite, 
        file_store_transform,
        file_store_operations,
        file_store_metrics
    ], 
    [optimize(on)])
).

