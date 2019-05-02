/* 
    traversals_loader.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- initialization(
    logtalk_load([
        extend_pathp, path, snoc_path,
        rewritep, transformp,
        ctx_rewritep, ctx_transformp,
        rewrite, transform,
        ctx_rewrite, ctx_transform
    ], 
    [optimize(on)])
).