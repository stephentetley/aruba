/*
    base_transform.pl
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/    

:- module(base_transform, 
            [ fail_transform/4
            , success_transform/4
            , context_transform/4
            , apply_transform/5
            , lift_context_transform/6
            , sequence_transform/6
            , choose_transform/6
            , one_transform/5
            , any_transform/5
            ]).

:- meta_predicate 
    apply_transform(4,+,+,+,-),
    lift_context_transform(2,4,+,+,-),
    sequence_transform(4,4,+,+,+,-),
    choose_transform(4,4,+,+,+,-),
    one_transform(4,+,+,+,-),
    any_transform(4,+,+,+,-).

% Always fails.
fail_transform(_, _, _, _) :- false.


%! success_transform(Ctx, Input, Init, Ans)
% 
% Always succeeds.

success_transform(_, _, _ ,_) :- true.


%! context_transform(Ctx, Input, Init, Ans)
% 
% Get the context.

context_transform(Ctx, _, _, Ctx).


%! apply_transform(Goal1, Ctx, Input, Ans)
% 
% Apply a transform - if it fails, catch error and return false.

apply_transform(Goal1, Ctx, Input, Init, Ans) :-
    catch(call(Goal1, Ctx, Input, Init, Ans),
        _,
        false).


lift_context_transform(Update, Goal1, Ctx, Input, Acc, Ans) :-
    catch((call(Update, Ctx, Ctx1), call(Goal1, Ctx1, Input, Acc, Ans)),
            _,
            false).

%! sequence_transform(Goal1, Goal2, Ctx, Input, Init, Ans)
% 
% Apply two transforms, one after the other.
sequence_transform(Goal1, Goal2, Ctx, Input, Init, Ans) :-
    apply_transform(Goal1, Ctx, Input, Init, A1),
    apply_transform(Goal2, Ctx, Input, A1, Ans).


%! choose_rewrite(Goal1, Goal2, Ctx, Input, Ans)
% 
% Apply the first rewrite, if it fails try the second.
choose_transform(Goal1, Goal2, Ctx, Input, Init, Ans) :-
    ( apply_transform(Goal1, Ctx, Input, Init, Ans) 
    ; apply_transform(Goal2, Ctx, Input, Init, Ans)
    ).

%! one_transform(Goal1, Ctx, Input, Init, Ans)
%
% One layer traversal, apply a rewrite to the first child for which it can succeed.

% Descend, if a list...
one_transform(Goal1, Ctx, Input, Init, Ans) :-
    is_list(Input),
    one_transform_aux(Input, Goal1, Ctx, Init, Ans), 
    !.

% Destructure, if a functor...
one_transform(Goal1, Ctx, Input, Init, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    one_transform_aux(Kids, Goal1, Ctx, Init, Kids1), 
    Ans =.. [Head|Kids1], 
    !.


one_transform(Goal1, Ctx, Input, Init, Ans) :-
    atomic(Input),
    apply_transform(Goal1, Ctx, Input, Init, Ans), 
    !.


one_transfrom_aux([], _, _, _, _) :- false.

one_transform_aux([X|Xs], Goal1, Ctx, Init, Ans) :-
    ( apply_transform(Goal1, Ctx, X, Init, Ans)
    ; one_transform_aux(Xs, Goal1, Ctx, Init, Ans)
    ).


%! any_transform(Goal1, Ctx, Input, Init, Ans)
%
% One layer traversal, apply a transform to any children where it can succeed.

% Descend, if a list...
any_transform(Goal1, Ctx, Input, Init, Ans) :-
    is_list(Input),
    any_transform_aux(Input, Goal1, Ctx, false, Init, Ans), 
    !.

% Destructure, if a functor...
any_transform(Goal1, Ctx, Input, Init, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    any_transform_aux(Kids, Goal1, Ctx, false, Init, Kids1), 
    Ans =.. [Head|Kids1], 
    !.


any_transform(Goal1, Ctx, Input, Init, Ans) :-
    atomic(Input),
    apply_transform(Goal1, Ctx, Input, Init, Ans), 
    !.


any_transfrom_aux([], _, _, false, _, _) :- false.
any_transfrom_aux([], _, _, true, Acc, Acc).

any_transform_aux([X|Xs], Goal1, Ctx, Status, Init, Ans) :-
    ( apply_transform(Goal1, Ctx, X, Init, A1), 
      any_transform_aux(Xs, Goal1, Ctx, true, A1, Ans)
    ; any_transform_aux(Xs, Goal1, Ctx, Status, Init, Ans)
    ).


%! all_transform(Goal1, Ctx, Input, Init, Ans)
%
% One layer traversal, apply a transform to all children, all must succeed.

% Descend, if a list...
all_transform(Goal1, Ctx, Input, Init, Ans) :-
    is_list(Input),
    all_transform_aux(Input, Goal1, Ctx, Init, Ans), 
    !.

% Destructure, if a functor...
all_transform(Goal1, Ctx, Input, Init, Ans) :-
    compound(Input),
    Input =.. [Head|Kids],
    all_transform_aux(Kids, Goal1, Ctx, Init, Kids1), 
    Ans =.. [Head|Kids1], 
    !.


all_transform(Goal1, Ctx, Input, Init, Ans) :-
    atomic(Input),
    apply_transform(Goal1, Ctx, Input, Init, Ans), 
    !.

all_transform_aux([], _, _, Acc, Acc).

all_transform_aux([X|Xs], Goal1, Ctx, Acc, Ans) :-
    apply_transform(Goal1, X, Ctx, Acc, A1),
    all_transform_aux(Xs, Goal1, Ctx, A1, Ans).

