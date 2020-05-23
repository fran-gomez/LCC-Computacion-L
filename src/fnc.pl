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

negar(A\/B, T):-
    negar(A, X),
    negar(B, Y),
    distribuir(X/\Y, T), !.

negar(A/\B, T):-
    negar(A, X),
    negar(B, Y),
    distribuir(X\/Y, T),!.

convertir(X, X):- var(X).

convertir((~X), (~X)):-var(X).

convertir((X/\Y), T):-
   var(X),
   var(Y),
   distribuir(X/\Y, T), !.

convertir((X/\Y), T):-
    var(X),
    not(var(Y)),
    convertir(Y, Z),
    distribuir(X/\Z, T), !.

convertir((X/\Y), T):-
    not(var(X)),
    var(Y),
    convertir(X, Z),
    distribuir(Z/\Y, T), !.

convertir((X/\Y), T):-
    not(var(X)),
    not(var(Y)),
    convertir(X, M),
    convertir(Y, N),
    distribuir(M/\N, T),
    !.

convertir((X\/Y), T):-
   var(X), var(Y), distribuir(X\/Y, T).

convertir((X\/Y), T):-
    var(X),
    not(var(Y)),
    convertir(Y, R),
    distribuir(X\/R, T).

convertir((X\/Y), T):-
    not(var(X)),
    var(Y),
    convertir(X, R),
    distribuir(R\/Y, T).

convertir((X\/Y), T):-
    not(var(X)),
    not(var(Y)),
    convertir(X, M),
    convertir(Y, N),
    distribuir(M\/N, T), !.

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

convertir(X => Y, T) :-
    convertir(X, Xc),
    convertir(Y, B),
    negar(Xc, A),
    distribuir(A\/B, T), !.

convertir(top, bottom).
convertir(bottom, top).

distribuir(A, A):- var(A).

distribuir((~A), (~A)):- var(A).

distribuir(A\/B, A\/B):- var(A), var(B), !.

distribuir(A\/B, A\/Y):-
    var(A),
    not(var(B)),
    distribuir(B, Y), !.

distribuir(A\/B, X\/B):-
    not(var(A)),
    var(B),
    distribuir(A, X), !.

distribuir(A\/B, X\/Y):-
    not(var(A)),
    not(var(B)),
    distribuir(A, X),
    distribuir(B, Y), !.

distribuir(((A\/B)/\C), X/\Y/\Z):-
    distribuir(A, M),
    distribuir(B, N),
    distribuir(C, O),
    distribuir(M\/N, X),
    distribuir(M\/O, Y),
    distribuir(O\/N, Z), !.

distribuir((A/\(B\/C)), X/\Y/\Z):-
    distribuir(A, M),
    distribuir(B, N),
    distribuir(C, O),
    distribuir(M\/O, X),
    distribuir(N\/M, Y),
    distribuir(N\/O, Z), !.

distribuir(A/\B, A/\B):- var(A), var(B), !.

distribuir(A/\B, X/\B):-
    not(var(A)),
    var(B),
    distribuir(A, X).

distribuir(A/\B, A/\Y):-
    var(A),
    not(var(B)),
    distribuir(B, Y), !.

distribuir(A/\B, X/\Y):-
    not(var(A)),
    not(var(B)),
    distribuir(A, X),
    distribuir(B, Y), !.

distribuir((A/\B)\/C, (A\/C)/\(B\/C)):- var(C), !.

distribuir(A\/(B/\C), (A\/B)/\(A\/C)):- var(A), !.

distribuir((A/\B)\/C, R/\S):-
    distribuir(A\/C, R),
    distribuir(B\/C, S).

distribuir(C\/(A/\B), R/\S):-
    distribuir(C\/A, R),
    distribuir(C\/B, S).









