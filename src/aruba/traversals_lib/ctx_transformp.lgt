/* 
    ctx_transformp.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- protocol(ctx_transformp).

    :- info([
        comment is 'Transformations with context.',
        see_also is [rewritep, ctx_transformp]
    ]).

	:- public(all_ctx_transform/5).
    :- meta_predicate(all_ctx_transform(4, *, *, *, *)).
	:- mode(all_ctx_transform(+callable, +term, +term, +term, -term), zero_or_more).

	:- public(one_ctx_transform/5).
    :- meta_predicate(one_ctx_transform(4, *, *, *, *)).
	:- mode(one_ctx_transform(+callable, +term, +term, +term, -term), zero_or_more).

:- end_protocol.