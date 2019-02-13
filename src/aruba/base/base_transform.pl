/*
    base_transform.pl
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/    

:- module(base_transform, 
            [ success_transform/3
            , context_transform/4
            , lift_context_transform/6
            ]).

:- meta_predicate lift_context_transform(2,4,+,+,-).


success_transform(_, _ ,_) :- true.

context_transform(Ctx, _, _, Ctx).

lift_context_transform(Update, Goal1, Ctx, Input, Acc, Ans) :-
    call(Update, Ctx, Ctx1),
    catch(call(Goal1, Ctx1, Input, Acc, Ans),
        _,
        false).

