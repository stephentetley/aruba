/*
    base_traversals.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/    

:- module(base_traversals, 
            [ identity/2
            , failure/1
            , sequence_rewrite/4
            , sequence_trafo/5
            , choose_rewrite/4
            , choose_trafo/5
            , one_rewrite/3
            , one_trafo/4
            , any_rewrite/3
            , all_rewrite/3
            , all_trafo/4
            , try_rewrite/3
            , alltd_rewrite/3
            , alltd_trafo/4
            , allbu_rewrite/3
            , allbu_trafo/4
            ]).

:- meta_predicate
    sequence_rewrite(2,+,-),
    sequence_trafo(3,+,+,-),
    choose_rewrite(2,+,-), 
    choose_trafo(3,+,+,-), 
    one_rewrite(2,+,-), 
    one_trafo(3,+,+,-),
    any_rewrite(2,+,-),
    all_rewrite(2,+,-),
    all_trafo(3,+,+,-),
    try_rewrite(2,+,-),
    alltd_rewrite(2,+,-),
    alltd_trafo(3,+,+,-),
    allbu_rewrite(2,+,-),
    allbu_trafo(3,+,+,-).


% In KURE R is a restriction of T where input and output types
% are the same

% In Prolog we can (should?) use arity to distinguish between 
% trafos an rewrites.
% (But this has been error prone so far...)


identity(Ans, Ans).


failure(_) :- false.


sequence_rewrite(Goal1, Goal2, Input, Ans) :-
    call(Goal1, Input, A1),
    call(Goal2, A1, Ans).

% Folds in SWI-Prolog take list (input) before accumulator.

sequence_trafo(Goal1, Goal2, Input, Acc, Ans) :-
    call(Goal1, Input, Acc, A1),
    call(Goal2, Input, A1, Ans).


% Call Goal1 on input, if it fails (false) throw and error.
failcall_rewrite(Goal1, Input, Ans) :-
    ( call(Goal1, Input, Ans), !
    ; throw(call_error())
    ).

% Call Goal1 on input and accumulator, if it fails (false) throw and error.
failcall_trafo(Goal1, Input, Acc, Ans) :-
    ( call(Goal1, Input, Acc, Ans), !
    ; throw(call_error())
    ).

choose_rewrite(Goal1, Goal2, Input, Ans) :-
    catch(failcall_rewrite(Goal1,Input,Ans), 
          _, 
          call(Goal2,Input,Ans)).


choose_trafo(Goal1, Goal2, Input, Acc, Ans) :-
    catch(failcall_trafo(Goal1, Input, Acc, Ans), 
            _, 
            call(Goal2, Input, Acc, Ans)).

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


% Terminology trafo indicates a fold-like traversal.

all_trafo_aux([], _, Acc, Acc).

all_trafo_aux([X|Xs], Goal1, Acc, Ans) :-
    call(Goal1, X, Acc, A1),
    all_trafo_aux(Xs, Goal1, A1, Ans).

all_trafo(Goal1, Input, Acc, Ans) :-
    is_list(Input),
    all_trafo_aux(Input, Goal1, Acc, Ans).


all_trafo(Goal1, Input, Acc, Ans) :-
    Input =.. [_|Kids],
    all_trafo_aux(Kids, Goal1, Acc, Ans).


try_rewrite(Goal1, Input, Ans) :-
    choose_rewrite(Goal1, identity, Input, Ans).


alltd_rewrite(Goal1, Input, Ans) :-
    choose_rewrite(Goal1, all_rewrite(alltd_rewrite(Goal1)), Input, Ans),
    !.

alltd_trafo(Goal1, Input, Acc, Ans) :-
    choose_trafo(Goal1, all_trafo(alltd_trafo(Goal1)), Input, Acc, Ans), 
    !.


allbu_rewrite(Goal1, Input, Ans) :-
    choose_rewrite(all_rewrite(allbu_rewrite(Goal1)), Goal1, Input, Ans), 
    !.

allbu_trafo(Goal1, Input, Acc, Ans) :-
    choose_trafo(all_trafo(allbu_trafo(Goal1)), Goal1, Input, Acc, Ans), 
    !.

