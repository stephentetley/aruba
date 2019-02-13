/*
    base_transform.pl
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/    

:- module(base_transform, 
            [ fail_transform/3
            , success_transform/3
            , context_transform/4
            , lift_context_transform/6
            , sequence_trafo/6
            ]).

:- meta_predicate 
    lift_context_transform(2,4,+,+,-),
    sequence_trafo(4,4,+,+,+,-).

% Always fails.
fail_transform(_, _, _) :- false.

success_transform(_, _ ,_) :- true.

context_transform(Ctx, _, _, Ctx).

lift_context_transform(Update, Goal1, Ctx, Input, Acc, Ans) :-
    call(Update, Ctx, Ctx1),
    catch(call(Goal1, Ctx1, Input, Acc, Ans),
        _,
        false).


sequence_trafo(Goal1, Goal2, Ctx, Input, Acc, Ans) :-
    call(Goal1, Ctx, Input, Acc, A1),
    call(Goal2, Ctx, Input, A1, Ans).