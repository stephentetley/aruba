/*
    traversals.pl
    Copyright (c) Stephen Tetley 2018
    License: BSD 3 Clause
*/    

:- module(traversals, 
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


sequence_rewrite(R1, R2, Input, Ans) :-
    call(R1, Input, A1),
    call(R2, A1, Ans).

% Folds in SWI-Prolog take list (input) before accumulator.

sequence_trafo(R1, R2, Input, Acc, Ans) :-
    call(R1, Input, Acc, A1),
    call(R2, Input, A1, Ans).


% Turns false into error, obviously there will be a better way of writing this...
failcall_rewrite(R1, Input, Ans) :-
    ( call(R1, Input, Ans), !
    ; throw(call_error())
    ).

% accumulating
failcall_trafo(R1, Input, Acc, Ans) :-
    ( call(R1, Input, Acc, Ans), !
    ; throw(call_error())
    ).

choose_rewrite(R1, R2, Input, Ans) :-
    catch(failcall_rewrite(R1,Input,Ans), 
          _, 
          call(R2,Input,Ans)).


choose_trafo(R1, R2, Input, Acc, Ans) :-
    catch(failcall_trafo(R1, Input, Acc, Ans), 
            _, 
            call(R2, Input, Acc, Ans)).

% Failure if no success

one_rewrite_aux(_,[], _, _) :- false.

one_rewrite_aux(R1, [X|Xs], Acc, Ans) :-
    ( call(R1, X, A1),
      reverse(Acc, Cca),
      append([Cca, [A1|Xs]], Ans) 
    ; one_rewrite_aux(R1, Xs, [X|Acc], Ans)
    ).
    
    
one_rewrite(R1, Input, Ans) :-
    is_list(Input),
    one_rewrite_aux(R1, Input, [], Ans), 
    !.

one_rewrite(R1, Input, Ans) :-
    Input =.. [Head|Kids],
    one_rewrite_aux(R1, Kids, [], Kids1), 
    Ans =.. [Head|Kids1], 
    !.


%% 
one_trafo_aux(_,[], _, _) :- false.

one_trafo_aux(R1, [X|Xs], Acc, Ans) :-
    ( call(R1, X, Acc, Ans)
    ; one_trafo_aux(R1, Xs, Acc, Ans)
    ).

    
one_trafo(R1, Input, Acc, Ans) :-
    is_list(Input),
    one_trafo_aux(R1, Input, Acc, Ans), 
    !.

one_trafo(R1, Input, Acc, Ans) :-
    Input =.. [_|Kids],
    one_trafo_aux(R1, Kids, Acc, Ans), 
    !.


%% 

% Failure if no success

any_rewrite_aux(_, [], _, false, _) :- false.
any_rewrite_aux(_, [], Acc, true, Ans) :- 
    reverse(Acc,Ans).


any_rewrite_aux(R1, [X|Xs], Acc, Status, Ans) :-
    ( call(R1, X, X1),
      any_rewrite_aux(R1, Xs, [X1|Acc], true, Ans) 
    ; any_rewrite_aux(R1, Xs, [X|Acc], Status, Ans)
    ).
    
    
any_rewrite(R1, Input, Ans) :-
    is_list(Input),
    any_rewrite_aux(R1, Input, [], false, Ans), 
    !.

any_rewrite(R1, Input, Ans) :-
    Input =.. [Head|Kids],
    any_rewrite_aux(R1, Kids, [], false, Kids1), 
    Ans =.. [Head|Kids1], 
    !.

%%

all_rewrite_aux(_,[],[]).

all_rewrite_aux(R1, [X|Xs], Ans) :-
    call(R1, X, A1),
    all_rewrite_aux(R1, Xs, A2),
    Ans = [A1|A2].
    
all_rewrite(R1, Input, Ans) :-
    is_list(Input),
    all_rewrite_aux(R1, Input, Ans), 
    !.

all_rewrite(R1, Input, Ans) :-
    Input =.. [Head|Kids],
    all_rewrite_aux(R1, Kids, Kids1), 
    Ans =.. [Head|Kids1], 
    !.


% Terminology trafo indicates a fold-like traversal.

all_trafo_aux(_, [], Acc, Acc).

all_trafo_aux(R1, [X|Xs], Acc, Ans) :-
    call(R1, X, Acc, A1),
    all_trafo_aux(R1, Xs, A1, Ans).

all_trafo(R1, Input, Acc, Ans) :-
    Input =.. [_|Kids],
    all_trafo_aux(R1, Kids, Acc, Ans).


try_rewrite(R1, Input, Ans) :-
    choose_rewrite(R1, identity, Input, Ans).


alltd_rewrite(R1, Input, Ans) :-
    choose_rewrite(R1, all_rewrite(alltd_rewrite(R1)), Input, Ans),
    !.

alltd_trafo(R1, Input, Acc, Ans) :-
    choose_trafo(R1, all_trafo(alltd_trafo(R1)), Input, Acc, Ans), 
    !.


allbu_rewrite(R1, Input, Ans) :-
    choose_rewrite(all_rewrite(allbu_rewrite(R1)) , R1, Input, Ans), 
    !.

allbu_trafo(R1, Input, Acc, Ans) :-
    choose_trafo(all_trafo(allbu_trafo(R1)), R1, Input, Acc, Ans), 
    !.

