% uilts.pl

:- module(utils, 
            [ output_csv/3
            , iso_8601_stamp/2
            , iso_8601_text/2
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

