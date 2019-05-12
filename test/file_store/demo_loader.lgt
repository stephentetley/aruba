/* 
    loader.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/  


:- initialization((
    logtalk_load(library(types_loader)),
    logtalk_load(library(metapredicates_loader)),
    logtalk_load('../../src/aruba/base/base_loader.lgt'),
    logtalk_load('../../src/aruba/traversals_lib/traversals_loader.lgt'),
    logtalk_load('../../src/aruba/file_store/file_store_loader.lgt'),
    logtalk_load('demo.lgt')
)).