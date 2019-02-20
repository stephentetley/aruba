% record_test1.pl


:- use_module(library(record)).


% See SWI Prolog Manual Section 4.36 for direct file system 
% access predicates (not "file stores" / listings).
% e.g.

:- record properties(modification_time:text=none, mode:text=none).


demo01(Time) :- 
    default_properties(Props),
    properties_modification_time(Props, Time).


% we can create structures with either 'make_properties' ...
demo02(Time) :- 
    make_properties([modification_time("2018-10-29T09:47:00"), mode('d----')], Props),
    properties_modification_time(Props, Time).

% ... Or the regular functor notation...
demo02b(Mode) :- 
    Props = properties("2018-10-29T09:47:00", 'd----'),
    properties_mode(Props, Mode).
