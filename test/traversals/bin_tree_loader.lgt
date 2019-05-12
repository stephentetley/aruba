/*
    bin_tree_loader.lgt
*/

:- initialization((
        logtalk_load(library(types_loader)),
        logtalk_load(library(metapredicates_loader)),
        logtalk_load('../../src/aruba/base/base_loader.lgt'),
        logtalk_load('../../src/aruba/traversals_lib/traversals_loader.lgt'),
        logtalk_load('bin_tree.lgt'),
        logtalk_load('bin_tree_test.lgt')
    )).