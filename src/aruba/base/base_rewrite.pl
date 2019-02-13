/*
    base_rewrite.pl
    Copyright (c) Stephen Tetley 2019
    License: BSD 3 Clause
*/    

:- module(base_rewrite, 
            [ id_rewrite/3
            , fail_rewrite/2
            , apply_rewrite/4
            , contextfree_rewrite/4
            , const_rewrite/4
            , sequence_rewrite/5
            ]).

:- meta_predicate
    apply_rewrite(3,+,+,-), 
    contextfree_rewrite(2,+,-),
    sequence_rewrite(3,3,+,+,-).



% In KURE R(rewrite) is a restriction of T(transform) where input and output types
% are the same

% In Prolog we can (should?) use arity to distinguish between 
% trafos and rewrites.
% (But this has been error prone so far...)


% Always succeeds.
id_rewrite(_, Ans, Ans).

% Always fails.
fail_rewrite(_, _) :- false.

% Apply a rewrite - if it fails, catch error and return false.
apply_rewrite(Goal1, Ctx, Input, Ans) :-
    catch(call(Goal1, Ctx, Input, Ans),
        _,
        false).

% Apply a rewrite that doesn't depend on it's context.
contextfree_rewrite(Goal1, _, Input, Ans) :- 
    catch(call(Goal1, Input, Ans),
        _,
        false).

% A contextonly rewrite would imply the type of the context and the input are the same.

const_rewrite(Ans, _, _, Ans).



sequence_rewrite(Goal1, Goal2, Ctx, Input, Ans) :-
    catch((call(Goal1, Ctx, Input, A1),
           call(Goal2, Ctx, A1, Ans)),
           _,
            false).
