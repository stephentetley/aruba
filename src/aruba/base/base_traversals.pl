/*
    base_traversals.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/    

:- module(base_traversals, 
            [ identity/2
            , failure/1
            , attempt_rewrite/3
            , attempt_trafo/4
            , sequence_rewrite/4
            , sequence_trafo/5
            , choose_rewrite/4
            , choose_trafo/5
            , one_rewrite/3
            , one_trafo/4
            , any_rewrite/3
            , any_trafo/4
            , all_rewrite/3
            , all_trafo/4
            , try_rewrite/3
            , try_trafo/4
            , alltd_rewrite/3
            , alltd_trafo/4
            , allbu_rewrite/3
            , allbu_trafo/4
            ]).

:- meta_predicate
    attempt_rewrite(2,+,-),
    attempt_trafo(3,+,+,-),
    sequence_rewrite(2,+,-),
    sequence_trafo(3,+,+,-),
    choose_rewrite(2,+,-), 
    choose_trafo(3,+,+,-), 
    one_rewrite(2,+,-), 
    one_trafo(3,+,+,-),
    any_rewrite(2,+,-),
    any_trafo(3,+,+,-),
    all_rewrite(2,+,-),
    all_trafo(3,+,+,-),
    try_rewrite(2,+,-),
    try_trafo(3,+,+,-),
    alltd_rewrite(2,+,-),
    alltd_trafo(3,+,+,-),
    allbu_rewrite(2,+,-),
    allbu_trafo(3,+,+,-).


% In KURE R is a restriction of T where input and output types
% are the same

% In Prolog we can (should?) use arity to distinguish between 
% trafos and rewrites.
% (But this has been error prone so far...)


identity(Ans, Ans).


failure(_) :- false.

attempt_rewrite(Goal1, Input, Ans) :- 
    catch(call(Goal1, Input, Ans), 
          _, 
          false).

attempt_trafo(Goal1, Input, Acc, Ans) :- 
    catch(call(Goal1, Input, Acc, Ans), 
        _, 
        false).

sequence_rewrite(Goal1, Goal2, Input, Ans) :-
    call(Goal1, Input, A1),
    call(Goal2, A1, Ans).

% Folds in SWI-Prolog take list (input) before accumulator.

sequence_trafo(Goal1, Goal2, Input, Acc, Ans) :-
    call(Goal1, Input, Acc, A1),
    call(Goal2, Input, A1, Ans).

% Exceptions will not be caught - wrap goals with attempt_rewrite 
% if exceptions are possible.
choose_rewrite(Goal1, Goal2, Input, Ans) :-
    ( call(Goal1, Input, Ans) 
    ; call(Goal2, Input, Ans)
    ).

choose_trafo(Goal1, Goal2, Input, Acc, Ans) :-
    ( call(Goal1, Input, Acc, Ans)
    ; call(Goal2, Input, Acc, Ans)
    ).

% Failure if no success

one_rewrite_aux([], _, _, _) :- false.

one_rewrite_aux([X|Xs], Goal1, Acc, Ans) :-
    ( call(Goal1, X, A1),
      reverse(Acc, Cca),
      append([Cca, [A1|Xs]], Ans) 
    ; one_rewrite_aux(Xs, Goal1, [X|Acc], Ans)
    ).
    
% Descend, if a list...
one_rewrite(Goal1, Input, Ans) :-
    is_list(Input),
    one_rewrite_aux(Input, Goal1, [], Ans), 
    !.

% Destructure, if a functor...
one_rewrite(Goal1, Input, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    one_rewrite_aux(Kids, Goal1, [], Kids1), 
    Ans =.. [Head|Kids1], 
    !.


one_rewrite(Goal1, Input, Ans) :-
    atomic(Input),
    call(Goal1, Input, Ans), 
    !.

%% 
one_trafo_aux([], _, _, _) :- false.

one_trafo_aux([X|Xs], Goal1, Acc, Ans) :-
    ( call(Goal1, X, Acc, Ans)
    ; one_trafo_aux(Xs, Goal1, Acc, Ans)
    ).

    
one_trafo(R1, Input, Acc, Ans) :-
    is_list(Input),
    one_trafo_aux(Input, R1, Acc, Ans), 
    !.

one_trafo(Goal1, Input, Acc, Ans) :-
    compound(Input),
    Input =.. [_|Kids],
    one_trafo_aux(Kids, Goal1, Acc, Ans), 
    !.

one_trafo(Goal1, Input, Acc, Ans) :-
    atomic(Input),
    call(Goal1, Input, Acc, Ans), 
    !.

%% 

% Failure if no success

any_rewrite_aux([], _, _, false, _) :- false.
any_rewrite_aux([], _, Acc, true, Ans) :- 
    reverse(Acc,Ans).


any_rewrite_aux([X|Xs], Goal1, Acc, Status, Ans) :-
    ( call(Goal1, X, X1),
      any_rewrite_aux(Xs, Goal1, [X1|Acc], true, Ans) 
    ; any_rewrite_aux(Xs, Goal1, [X|Acc], Status, Ans)
    ).
    
    
any_rewrite(Goal1, Input, Ans) :-
    is_list(Input),
    any_rewrite_aux(Input, Goal1, [], false, Ans), 
    !.

any_rewrite(Goal1, Input, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    any_rewrite_aux(Kids, Goal1, [], false, Kids1), 
    Ans =.. [Head|Kids1], 
    !.

any_rewrite(Goal1, Input, Ans) :-
    atomic(Input),
    call(Goal1, Input, Ans), 
    !.

%%

any_trafo_aux([], _, true, Acc, Acc).
any_trafo_aux([], _, false, _, _) :- false.


any_trafo_aux([X|Xs], Goal1, Status, Acc, Ans) :-
    ( call(Goal1, X, Acc, A1),
      any_trafo_aux(Xs, Goal1, true, A1, Ans)
    ; any_trafo_aux(Xs, Goal1, Status, Acc, Ans)
    ).


any_trafo(Goal1, Input, Init, Ans) :-
    is_list(Input),
    write_ln("List case..."),
    any_trafo_aux(Input, Goal1, false, Init, Ans), 
    !.

any_trafo(Goal1, Input, Init, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    any_trafo_aux(Kids, Goal1, false, Init, Kids1), 
    Ans =.. [Head|Kids1], 
    !.

%% 

all_rewrite_aux([], _, []).

all_rewrite_aux([X|Xs], Goal1, Ans) :-
    call(Goal1, X, A1),
    all_rewrite_aux(Xs, Goal1, A2),
    Ans = [A1|A2].
    
all_rewrite(Goal1, Input, Ans) :-
    is_list(Input),
    all_rewrite_aux(Input, Goal1, Ans), 
    !.

all_rewrite(Goal1, Input, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    all_rewrite_aux(Kids, Goal1, Kids1), 
    Ans =.. [Head|Kids1], 
    !.

all_rewrite(Goal1, Input, Ans) :-
    atomic(Input),
    call(Goal1, Input, Ans), 
    !.

% Terminology - trafo indicates a fold-like traversal.

all_trafo_aux([], _, Acc, Acc).

all_trafo_aux([X|Xs], Goal1, Acc, Ans) :-
    call(Goal1, X, Acc, A1),
    all_trafo_aux(Xs, Goal1, A1, Ans).



all_trafo(Goal1, Input, Acc, Ans) :-
    is_list(Input),
    all_trafo_aux(Input, Goal1, Acc, Ans), !.


all_trafo(Goal1, Input, Acc, Ans) :-
    compound(Input),
    Input =.. [_|Kids],
    all_trafo_aux(Kids, Goal1, Acc, Ans), !.

all_trafo(Goal1, Input, Acc, Ans) :-
    atomic(Input),
    call(Goal1, Input, Acc, Ans).


try_rewrite(Goal1, Input, Ans) :-
    choose_rewrite(attempt_rewrite(Goal1), identity, Input, Ans), !.


try_trafo(Goal1, Input, Acc, Ans) :-
    choose_rewrite(attempt_rewrite(Goal1), Acc, Input, Ans), !.


% alltd_rewrite
/* alltd_rewrite(Goal1, Input, Ans) :-
    sequence_rewrite(attempt_rewrite(Goal1), all_rewrite(alltd_rewrite(Goal1)), Input, Ans), 
    !. */

alltd_rewrite_aux([], _, Acc, Ans) :- 
    reverse(Acc, Ans).


alltd_rewrite_aux([X|Xs], Goal1, Acc, Ans) :-
    alltd_rewrite(Goal1, X, A1),
    alltd_rewrite_aux(Xs, Goal1, [A1|Acc], Ans).


alltd_rewrite(Goal1, Input, Ans) :-
    is_list(Input),
    alltd_rewrite_aux(Input, Goal1, [], Ans), 
    !.

alltd_rewrite(Goal1, Input, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    alltd_rewrite_aux(Kids, Goal1, [], Kids1), 
    Ans =.. [Head|Kids1],
    !.

alltd_rewrite(Goal1, Input, Acc, Ans) :-
    atomic(Input),
    call(Goal1, Input, Acc, Ans).


% alltd_trafo

alltd_trafo_aux([], _, Acc, Acc).

alltd_trafo_aux([X|Xs], Goal1, Acc, Ans) :-
    alltd_trafo(Goal1, X, Acc, A1),
    alltd_trafo_aux(Xs, Goal1, A1, Ans).


alltd_trafo(Goal1, Input, Acc, Ans) :-
    is_list(Input),
    alltd_trafo_aux(Input, Goal1, Acc, Ans), 
    !.

alltd_trafo(Goal1, Input, Acc, Ans) :-
    compound(Input),
    call(Goal1, Input, Acc, A1),
    Input =.. [_|Kids],
    alltd_trafo_aux(Kids, Goal1, A1, Ans), 
    !.

alltd_trafo(Goal1, Input, Acc, Ans) :-
    atomic(Input),
    call(Goal1, Input, Acc, Ans).

% allbu_rewrite
/* allbu_rewrite(Goal1, Input, Ans) :-
    sequence_rewrite(all_rewrite(allbu_rewrite(Goal1)), attempt_rewrite(Goal1), Input, Ans), 
    !. */


allbu_rewrite_aux([], _, Acc, Ans) :- 
    reverse(Acc, Ans).


allbu_rewrite_aux([X|Xs], Goal1, Acc, Ans) :-
    allbu_rewrite_aux(Xs, Goal1, Acc, Acc1),
    allbu_rewrite(Goal1, X, A1),
    Ans = [A1|Acc1].


allbu_rewrite(Goal1, Input, Ans) :-
    is_list(Input),
    allbu_rewrite_aux(Input, Goal1, [], Ans), 
    !.

allbu_rewrite(Goal1, Input, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    allbu_rewrite_aux(Kids, Goal1, [], Kids1), 
    Ans =.. [Head|Kids1],
    !.

allbu_rewrite(Goal1, Input, Acc, Ans) :-
    atomic(Input),
    call(Goal1, Input, Acc, Ans).

% allbu_trafo
/* allbu_trafo(Goal1, Input, Acc, Ans) :-
    sequence_trafo(all_trafo(allbu_trafo(Goal1)), Goal1, Input, Acc, Ans), 
    !. */

allbu_trafo_aux([], _, Acc, Acc).

allbu_trafo_aux([X|Xs], Goal1, Acc, Ans) :-
    allbu_trafo_aux(Xs, Goal1, Acc, A1),
    allbu_trafo(Goal1, X, A1, Ans).

allbu_trafo(Goal1, Input, Acc, Ans) :-
    is_list(Input),
    allbu_trafo_aux(Input, Goal1, Acc, Ans), 
    !.

allbu_trafo(Goal1, Input, Acc, Ans) :-
    compound(Input),
    Input =.. [_|Kids],
    allbu_trafo_aux(Kids, Goal1, Acc, A1), 
    call(Goal1, Input, A1, Ans),
    !.

allbu_trafo(Goal1, Input, Acc, Ans) :-
    atomic(Input),
    call(Goal1, Input, Acc, Ans).

%% 
