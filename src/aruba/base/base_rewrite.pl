/*
    base_rewrite.pl
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/    

:- module(base_rewrite, 
            [ id_rewrite/3
            , fail_rewrite/3
            , apply_rewrite/4
            , contextfree_rewrite/4
            , const_rewrite/4
            , sequence_rewrite/5
            , choose_rewrite/5
            , one_rewrite/4
            , any_rewrite/4
            , all_rewrite/4
            , alltd_rewrite/4
            ]).

:- meta_predicate
    apply_rewrite(3,+,+,-), 
    contextfree_rewrite(2,+,-),
    sequence_rewrite(3,3,+,+,-),
    choose_rewrite(3,3,+,+,-),
    one_rewrite(3,+,+,-),
    any_rewrite(3,+,+,-),
    all_rewrite(3,+,+,-),
    alltd_rewrite(3,+,+,-).


% In KURE R(rewrite) is a restriction of T(transform) where input and output types
% are the same

% In Prolog we could use arity to distinguish between trafos and rewrites,
% but this has been error prone so far.
% Instead we use explicit names.



%! id_rewrite(Ctx, Input, Ans)
% 
% Always succeeds.

id_rewrite(_, Ans, Ans).

%! fail_rewrite(Ctx, Input, Ans)
% 
% Always fails.

fail_rewrite(_, _, _) :- false.

%! apply_rewrite(Goal1, Ctx, Input, Ans)
% 
% Apply a rewrite - if it fails, catch error and return false.

apply_rewrite(Goal1, Ctx, Input, Ans) :-
    catch(call(Goal1, Ctx, Input, Ans),
        _,
        false).

%! contextfree_rewrite(Goal1, Ctx, Input, Ans)
% 
% Apply a rewrite that doesn't depend on it's context.

contextfree_rewrite(Goal1, _, Input, Ans) :- 
    catch(call(Goal1, Input, Ans),
        _,
        false).

%! const_rewrite(Value, Ctx, Input, Ans)
% 

const_rewrite(Ans, _, _, Ans).

% Note - A contextonly rewrite would imply the type of the context and the input are the same.

%! sequence_rewrite(Goal1, Goal2, Ctx, Input, Ans)
% 
% Apply two rewrites, one after the other.

sequence_rewrite(Goal1, Goal2, Ctx, Input, Ans) :-
    apply_rewrite(Goal1, Ctx, Input, A1),
    apply_rewrite(Goal2, Ctx, A1, Ans).

%! choose_rewrite(Goal1, Goal2, Ctx, Input, Ans)
% 
% Apply the first rewrite, if it fails try the second.
choose_rewrite(Goal1, Goal2, Ctx, Input, Ans) :-
    ( apply_rewrite(Goal1, Ctx, Input, Ans) 
    ; apply_rewrite(Goal2, Ctx, Input, Ans)
    ).


%% One Layer Traversal
%% Apply a rewrite to the first child for which it can succeed.


%! one_rewrite(Goal1, Ctx, Input, Ans)
%
% One layer traversal, apply a rewrite to the first child for which it can succeed.

% Descend, if a list...
one_rewrite(Goal1, Ctx, Input, Ans) :-
    is_list(Input),
    one_rewrite_aux(Input, Goal1, Ctx, [], Ans), 
    !.

% Destructure, if a functor...
one_rewrite(Goal1, Ctx, Input, Ans) :-
    compound(Input),
    write_ln("one_rewrite compound"),
    Input =.. [Head|Kids],
    one_rewrite_aux(Kids, Goal1, Ctx, [], Kids1), 
    Ans =.. [Head|Kids1], 
    !.

% TODO - is this correct? check with KURE...
one_rewrite(Goal1, Ctx, Input, Ans) :-
    atomic(Input),
    apply_rewrite(Goal1, Ctx, Input, Ans), 
    !.


one_rewrite_aux([], _, _, _, _) :- false.

one_rewrite_aux([X|Xs], Goal1, Ctx, Acc, Ans) :-
    ( apply_rewrite(Goal1, Ctx, X, A1),
      reverse(Acc, Cca),
      append([Cca, [A1|Xs]], Ans) 
    ; one_rewrite_aux(Xs, Goal1, Ctx, [X|Acc], Ans)
    ).


%! any_rewrite(Goal1, Ctx, Input, Ans) 
%
% One layer traversal, apply a rewrite to all children, succeeding if any succeed.

    
any_rewrite(Goal1, Ctx, Input, Ans) :-
    is_list(Input),
    any_rewrite_aux(Input, Goal1, Ctx, [], false, Ans), 
    !.

any_rewrite(Goal1, Ctx, Input, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    any_rewrite_aux(Kids, Goal1, Ctx, [], false, Kids1), 
    Ans =.. [Head|Kids1], 
    !.

any_rewrite(Goal1, Ctx, Input, Ans) :-
    atomic(Input),
    apply_rewrite(Goal1, Ctx, Input, Ans), 
    !.



any_rewrite_aux([], _, _, _, _, _) :- false.
any_rewrite_aux([], _, _, Acc, true, Ans) :- 
    reverse(Acc,Ans).


any_rewrite_aux([X|Xs], Goal1, Ctx, Acc, Status, Ans) :-
    ( apply_rewrite(Goal1, Ctx, X, X1),
      any_rewrite_aux(Xs, Goal1, Ctx, [X1|Acc], true, Ans) 
    ; any_rewrite_aux(Xs, Goal1, Ctx, [X|Acc], Status, Ans)
    ).
    

%! all_rewrite(Goal1, Ctx, Input, Ans) 
%
% One layer traversal, apply a rewrite to all children, succeeding if all succeed.

    
all_rewrite(Goal1, Ctx, Input, Ans) :-
    is_list(Input),
    all_rewrite_aux(Input, Goal1, Ctx, Ans), 
    !.

all_rewrite(Goal1, Ctx, Input, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    all_rewrite_aux(Kids, Goal1, Ctx, Kids1), 
    Ans =.. [Head|Kids1], 
    !.

all_rewrite(Goal1, Ctx, Input, Ans) :-
    atomic(Input),
    apply_rewrite(Goal1, Ctx, Input, Ans), 
    !.



all_rewrite_aux([], _, _, []).

all_rewrite_aux([X|Xs], Goal1, Ctx, Ans) :-
    apply_rewrite(Goal1, Ctx, X, A1),
    all_rewrite_aux(Xs, Goal1, Ctx, A2),
    Ans = [A1|A2].


%! alltd_rewrite(Goal1, Ctx, Input, Ans)

alltd_rewrite(Goal1, Ctx, Input, Ans) :-
    sequence_rewrite(apply_rewrite(Goal1), all_rewrite(alltd_rewrite(Goal1)), Ctx, Input, Ans).