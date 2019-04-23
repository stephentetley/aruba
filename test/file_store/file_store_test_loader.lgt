/* 
    loader.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  


:- initialization((
    logtalk_load('../../src/aruba/base/base_logtalk.lgt'),
    logtalk_load('../../src/aruba/traversals_lib/walker.lgt'),
    logtalk_load('../../src/aruba/traversals_lib/rewrite.lgt'),
    logtalk_load('../../src/aruba/traversals_lib/transform.lgt'),
    logtalk_load('../../src/aruba/file_store/objects.lgt'),
    logtalk_load('../../src/aruba/file_store/metrics_lib.lgt'),
    logtalk_load('demo.lgt')
)).