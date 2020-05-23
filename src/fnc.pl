:- op(300,fx,~).     % negacion, prefija, no asociativa.
:- op(400,yfx,(/\)). % conjuncion, infija, asociativa a izquierda.
:- op(500,yfx,(\/)). % disyuncion, infija, asociativa a izquierda.
:- op(600,xfx,=>).   % implicacion, infija, no asociativa.
:- op(650,xfx,<=>).  % equivalencia, infija, no asociativa.

fncr(T, X) :-
    convertir(T, X), !.

negar(A\/B, T):-
    negar(A, X),
    negar(B, Y),
    distribuir(X/\Y, T), !.

negar(A/\B, T):-
    negar(A, X),
    negar(B, Y),
    distribuir(X\/Y, T), !.

negar((~A), A):-
    ground(a).

negar(A, ~A):-
    ground(A), !.

convertir((X <=> Y), A/\B) :-
    convertir((X => Y), A),
    convertir((Y => X), B).

convertir(X => Y, T) :-
    convertir(X, Xc),
    convertir(Y, B),
    negar(Xc, A),
    distribuir(A\/B, T), !.

convertir(X/\Y, T):-
    convertir(X, A),
    convertir(Y, B),
    distribuir(A/\B, T).

convertir(X\/Y, T):-
    convertir(X, A),
    convertir(Y, B),
    distribuir(A\/B, T).

convertir(~(A\/B), (C/\D)):-
   convertir(A, X),
   convertir(B, Y),
   negar(X, C),
   negar(Y, D), !.

convertir(~(A/\B), (C\/D)):-
    convertir(A, X),
    convertir(B, Y),
    negar(X, C),
    negar(Y, D), !.

convertir(X, X):- ground(X).

convertir((~X), (~X)):- ground(X).

convertir(top, bottom).
convertir(bottom, top).

distribuir(A\/(B/\C), (A\/B)/\(A\/C)):-
     A \= _/\_, !.

distribuir((A/\B)\/C, (A\/C)/\(B\/C)).

distribuir((A\/B)/\C, (A\/B)/\(A\/C)/\(C\/B)):-
    C \= _\/_, !.

distribuir(A/\(B\/C), (B\/A)/\(A\/C)/\(B\/C)).

distribuir((~A), B):-
    negar(A, B).

distribuir(A, A):-
    ground(A).

