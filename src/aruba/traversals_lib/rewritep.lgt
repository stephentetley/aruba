/* 
    rewritep.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- protocol(rewritep).
    
    :- info([
        comment is 'Rewrites. No context.',
        see_also is [transformp, ctx_rewritep]
    ]).

    :- public(all_rewrite/3).
    :- meta_predicate(all_rewrite(2, *, *)).
    :- mode(all_rewrite(+callable, +term, -term), one).
    
	:- public(any_rewrite/3).
    :- meta_predicate(any_rewrite(2, *, *)).
    :- mode(any_rewrite(+callable, +term, -term), zero_or_more).
    
	:- public(one_rewrite/3).
    :- meta_predicate(one_rewrite(2, *, *)).
    :- mode(one_rewrite(+callable, +term, -term), zero_or_more).

:- end_protocol.
