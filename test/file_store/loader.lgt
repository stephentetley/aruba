/* 
    loader.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  


:- initialization((
    logtalk_load('../../src/aruba/base/traversal_lib.lgt'),
    logtalk_load('../../src/aruba/file_store/objects.lgt'),
    logtalk_load('../../src/aruba/file_store/metrics_lib.lgt'),
    logtalk_load('factbase/includes.lgt'),
    logtalk_load('demo.lgt')
)).