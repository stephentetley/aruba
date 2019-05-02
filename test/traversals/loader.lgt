/*
    loader.lgt
*/

:- initialization((
        logtalk_load(library(types_loader)),
        logtalk_load(library(metapredicates_loader)),
        logtalk_load('../../src/aruba/base/base_logtalk.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/extend_pathp.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/path.lgt'),        
        logtalk_load('../../src/aruba/traversals_lib/rewritep.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/transformp.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/ctx_rewritep.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/ctx_transformp.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/rewrite.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/transform.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/ctx_rewrite.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/ctx_transform.lgt'),        
        logtalk_load('list_trav.lgt')
    )).