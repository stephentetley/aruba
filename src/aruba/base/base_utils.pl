/*
    base_utils.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/    

:- module(base_utils, 
            [ output_csv/3
            , iso_8601_stamp/2
            , iso_8601_text/2
            , format_file_size/2
            ]).

:- use_module(library(csv)).

output_csv(File, Headers, Rows) :-
    setup_call_cleanup(
        open(File, write, Out),
            ( csv_write_stream(Out, [Headers], []),
              csv_write_stream(Out, Rows, [])
            ),
        close(Out)).

% iso_8601_stamp
% This is so "obvious" we don't / barely need it.
iso_8601_stamp(Text, Stamp) :-
    parse_time(Text, iso_8601, Stamp).    

iso_8601_text(Stamp, Text) :-
    format_time(string(Text), "%G-%m-%dT%H:%M:%S", Stamp).


format_file_size(Size, Text) :- 
    KB is 1024,
    MB is 1024 * KB,
    GB is 1024 * MB,
    ( Size > GB -> 
        format(string(Text), "~1f GB", [Size / GB])
    ; Size > MB -> 
        format(string(Text), "~1f MB", [Size / MB])
    ; Size > KB -> 
        format(string(Text), "~1f KB", [Size / KB])
    ; format(string(Text), "~d bytes", Size)
    ).

