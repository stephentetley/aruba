/* 
    transformp.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   


:- protocol(transformp).

    :- info([
        comment is 'Transformations. No context.',
        see_also is [rewritep, ctx_transformp]
    ]).


	:- public(all_transform/4).
    :- meta_predicate(all_transform(3, *, *, *)).
	:- mode(all_transform(+callable, +term, +term, -term), zero_or_more).

	:- public(one_transform/4).
    :- meta_predicate(one_transform(3, *, *, *)).
	:- mode(one_transform(+callable, +term, +term, -term), zero_or_more).

:- end_protocol.