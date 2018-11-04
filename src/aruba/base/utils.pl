% uilts.pl

:- module(utils, 
            [ output_csv/3
            ]).

:- use_module(library(csv)).

output_csv(File, Headers, Rows) :-
    setup_call_cleanup(
        open(File, write, Out),
            ( csv_write_stream(Out, [Headers], []),
              csv_write_stream(Out, Rows, [])
            ),
        close(Out)).