:- op(300,fx,~).     % negacion, prefija, no asociativa.
:- op(400,yfx,(/\)). % conjuncion, infija, asociativa a izquierda.
:- op(500,yfx,(\/)). % disyuncion, infija, asociativa a izquierda.
:- op(600,xfx,=>).   % implicacion, infija, no asociativa.
:- op(650,xfx,<=>).  % equivalencia, infija, no asociativa.

%fncr((X /\ Y), (A /\ B)) :- fncr(X, A), fncr(Y, B), !.
%fncr((X \/ Y), R).

fncr(T, R) :- convertir(T, R), !.

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

convertir((X\/Y), (X\/Y)):-
   var(X), var(Y).

convertir((X\/Y), (X\/R)):-
    var(X),
    convertir(Y, R).

convertir((X\/Y), (R\/Y)):-
    var(Y),
    convertir(X, R).

convertir((X/\Y), (X/\Y)):-
   var(X), var(Y).

convertir((X/\Y), (X/\R)):-
    var(X),
    convertir(Y, R).

convertir((X/\Y), (R/\Y)):-
    var(Y),
    convertir(X, R).

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
    negar(Xc, A).

convertir(top, bottom).
convertir(bottom, top).

%convertir(~(~X), R) :- convertir(X, R).
%convertir(~(X /\ Y), R) :- convertir((~X \/ ~Y), R).
%convertir(~(X \/ Y), R) :- convertir((~X /\ ~Y), R).

distribuir(X /\ (Y \/ Z), (X /\ Y) \/ (X /\ Z)).
distribuir(X \/ (Y /\ Z), (X \/ Y) /\ (X \/ Z)).
distribuir(X, X):- var(X).
