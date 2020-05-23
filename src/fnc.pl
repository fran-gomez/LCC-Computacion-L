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

convertir(~(A\/B), T):-
   convertir(A, X),
   convertir(B, Y),
   negar(X, C),
   negar(Y, D),
   distribuir(C/\D, T), !.

convertir(~(A/\B), T):-
    convertir(A, X),
    convertir(B, Y),
    negar(X, C),
    negar(Y, D),
    distribuir(C\/D, T), !.

convertir(A\/A, A).

convertir(A/\A, A).

convertir(X, T):- distribuir(X, T).

convertir(top, bottom).
convertir(bottom, top).

distribuir(A\/(B/\C), X/\Y):-
     A \= _/\_,
     distribuir(A\/B, X),
     distribuir(A\/C, Y),!.

distribuir((A/\B)\/C, X/\Y):-
     distribuir((A\/C), X),
     distribuir((B\/C), Y), !.

distribuir((A\/B)/\C, X/\Y/\Z):-
     C \= _\/_,
     distribuir(A\/B, X),
     distribuir(A\/C, Y),
     distribuir(C\/B, Z), !.

distribuir(A\/A, A).

distribuir(A/\A, A).

distribuir(A/\(B\/C), X/\Y/\Z):-
     distribuir(B\/A, X),
     distribuir(A\/C, Y),
     distribuir(B\/C, Z),!.

distribuir(A\/(B\/C), X\/Y\/Z):-
    distribuir(A, X),
    distribuir(B, Y),
    distribuir(C, Z).

distribuir(~(~A), A).


distribuir(A, A):-
    ground(A).

