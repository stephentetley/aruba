/* 
    ctx_rewritep.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- protocol(ctx_rewritep).
    
    :- info([
        comment is 'Rewrites with context.',
        see_also is [rewritep]
    ]).

    :- public(all_ctx_rewrite/4).
    :- meta_predicate(all_ctx_rewrite(3, *, *, *)).
    :- mode(all_ctx_rewrite(+callable, +term, +term, -term), one).
    
	:- public(any_ctx_rewrite/4).
    :- meta_predicate(any_ctx_rewrite(3, *, *, *)).
    :- mode(any_ctx_rewrite(+callable, +term, +term, -term), zero_or_more).
    
	:- public(one_ctx_rewrite/4).
    :- meta_predicate(one_ctx_rewrite(3, *, *)).
    :- mode(one_ctx_rewrite(+callable, +term, +term, -term), zero_or_more).

:- end_protocol.
