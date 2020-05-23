:- op(300,fx,~).     % negacion, prefija, no asociativa.
:- op(400,yfx,(/\)). % conjuncion, infija, asociativa a izquierda.
:- op(500,yfx,(\/)). % disyuncion, infija, asociativa a izquierda.
:- op(600,xfx,=>).   % implicacion, infija, no asociativa.
:- op(650,xfx,<=>).  % equivalencia, infija, no asociativa.

fncr(T, X) :-
    convertir(T, X), !.

negar(A, ~A):-
    var(A).

negar((~A), A):-
    var(A).

negar(A\/B, X/\Y):-
    negar(A, X),
    negar(B, Y), !.

negar(A/\B, X\/Y):-
    negar(A, X),
    negar(B, Y), !.

convertir(X, X):- var(X).

convertir((~X), (~X)):-var(X).

convertir((X/\Y), (X/\Y)):-
   var(X), var(Y).

convertir((X/\Y), T):-
    var(X),
    not(var(Y)),
    convertir(Y, R),
    distribuir(X/\R, T), !.

convertir((X/\Y), T):-
    var(Y),
    convertir(X, R),
    distribuir(R/\Y, T), !.

convertir((X/\Y), M/\N):-
    convertir(X, Z),
    convertir(Y, T),
    distribuir(Z, M),
    distribuir(T, N),
    !.

convertir((X\/Y), (X\/Y)):-
   var(X), var(Y).

convertir((X\/Y), T):-
    var(X),
    not(var(Y)),
    convertir(Y, R),
    distribuir(X\/R, T).

convertir((X\/Y), T):-
    var(Y),
    convertir(X, R),
    distribuir(R\/Y, T).

convertir((X\/Y), M\/N):-
    convertir(X, Z),
    convertir(Y, T),
    distribuir(Z, M),
    distribuir(T, N), !.

convertir(~X, T):-
    convertir(X, Y),
    negar(Y, T).

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

convertir((X <=> Y), A/\B) :-
    convertir((X => Y), A),
    convertir((Y => X), B).

convertir(X => Y, A\/B) :-
    convertir(X, Xc),
    convertir(Y, B),
    negar(Xc, A), !.

convertir(top, bottom).
convertir(bottom, top).

distribuir(A, A):- var(A).

distribuir(A\/B, A\/B):- var(A), var(B), !.

distribuir((~A)\/B, (~A)\/B):- var(A), var(B), !.

distribuir(A\/(~B), A\/(~B)):- var(A), var(B), !.

distribuir((~A)\/(~B), (~A)\/(~B)):- var(A), var(B), !.

distribuir(A/\B, A/\B):- var(A), var(B), !.

distribuir((~A)/\B, (~A)/\B):- var(A), var(B), !.

distribuir(A/\(~B), A/\(~B)):- var(A), var(B), !.

distribuir(A/\(B/\C), A/\B/\C).

distribuir(A\/(B\/C), A\/B\/C).

distribuir((A\/B)/\C, (A\/B)/\(A\/C)/\(C\/B)):- var(C),!.

distribuir(A/\(B\/C), (A\/C)/\(B\/A)/\(B\/C)):- var(A), !.

distribuir((A/\B)\/C, (A\/C)/\(B\/C)):- var(C), !.

distribuir(A\/(B/\C), (A\/B)/\(A\/C)):- var(A), !.

distribuir((A/\B)\/C, R/\S):-
    distribuir(A\/C, R),
    distribuir(B\/C, S).


