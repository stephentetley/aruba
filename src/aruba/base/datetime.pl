% datetime.pl

% Serialize and deserialize date-times in ISO 8601 format.

% parsetime gets us a timestamp (long integer?).

demo01(Stamp) :-
    parse_time("2006-12-08", iso_8601, Stamp).

year_of(X) :- 
    parse_time("2006-12-08T10:10", iso_8601, Stamp),
    stamp_date_time(Stamp, DT, local),
    date_time_value(year, DT, X).

hour_of(X) :- 
    parse_time("2006-12-08T10:10", iso_8601, Stamp),
    stamp_date_time(Stamp, DT, local),
    date_time_value(hour, DT, X).

any_of(Any,X) :- 
    parse_time("2006-12-08T10:35", iso_8601, Stamp),
    stamp_date_time(Stamp, DT, local),
    date_time_value(Any, DT, X).

