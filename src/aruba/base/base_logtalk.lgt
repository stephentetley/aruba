/*
    base_logtalk.lgt
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/   

%% Wrap base_utils.pl for Logtalk

:- object(base_utils).



    :- public(iso_8601_stamp/2).
    iso_8601_stamp(Text, Stamp) :-
        {parse_time(Text, iso_8601, Stamp)}.  

    :- public(iso_8601_text/2).
    iso_8601_text(Stamp, Text) :-
        {format_time(string(Text), "%G-%m-%dT%H:%M:%S", Stamp)}.

:- end_object.