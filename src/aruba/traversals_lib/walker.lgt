/* 
    walker.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

:- protocol(rewritep).
    
    :- public(all_rewrite/3).
    :- mode(all_rewrite(+callable, +term, -term), zero_or_more).

:- end_protocol.

:- protocol(transformp).

	:- public(all_transform/4).
	:- mode(all_transform(+callable, +term, +term, -term), zero_or_more).

:- end_protocol.