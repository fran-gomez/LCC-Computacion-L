:- op(300,fx,~).     % negacion, prefija, no asociativa.
:- op(400,yfx,(/\)). % conjuncion, infija, asociativa a izquierda.
:- op(500,yfx,(\/)). % disyuncion, infija, asociativa a izquierda.
:- op(600,xfx,=>).   % implicacion, infija, no asociativa.
:- op(650,xfx,<=>).  % equivalencia, infija, no asociativa.

fncr(T, X) :-
    convertir(T, R),
    reducir(R, F),
    eliminarRep(F, X), !.

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

convertir((X <=> Y), M/\N) :-
    convertir((X => Y), A),
    convertir((Y => X), B),
    distribuir(A, Z),
    reducir(Z, M),
    distribuir(B, T),
    reducir(T, N).

convertir(X => Y, T) :-
    convertir(X, Xc),
    convertir(Y, B),
    negar(Xc, A),
    distribuir(A\/B, T), !.

convertir(A\/(~A), _).

convertir(A/\(~A), _).

convertir(X/\Y, T):-
    convertir(X, A),
    distribuir(A, M),
    convertir(Y, B),
    distribuir(B, N),
    distribuir(M/\N, T).

convertir(X\/Y, T):-
    convertir(X, A),
    distribuir(A, M),
    convertir(Y, B),
    distribuir(B, N),
    distribuir(M\/N, T).

convertir(~(A\/B), T):-
   convertir(A, X),
   convertir(B, Y),
   negar(X, C),
   negar(Y, D),
   distribuir(C, M),
   distribuir(D, N),
   distribuir(M/\N, T), !.

convertir(~(A/\B), T):-
    convertir(A, X),
    convertir(B, Y),
    negar(X, C),
    negar(Y, D),
    distribuir(C, M),
    distribuir(D, N),
    distribuir(M\/N, T), !.

convertir(~A, R):-
    convertir(A, T),
    negar(T, R),
    !.

convertir(A\/A, A).

convertir(A/\A, A).

convertir(X, T):- distribuir(X, T).

convertir(top, bottom).
convertir(bottom, top).

distribuir(A\/A, A).

distribuir((~A)\/A, _).

distribuir(A/\A, A).

distribuir(A\/(B/\C), X/\Y):-
     A \= _/\_,
     distribuir(B, M),
     distribuir(C, N),
     distribuir(A\/M, X),
     distribuir(A\/N, Y), !.

distribuir((A/\B)\/C, X/\Y):-
     C \= _/\_,
     distribuir(A, M),
     distribuir(B, N),
     distribuir((M\/C), X),
     distribuir((N\/C), Y), !.


distribuir((A\/B)/\C, T):-
     C \= _\/_,
     distribuir(A/\C, X),
     distribuir(B/\C, Y),
     distribuir(X\/Y, T), !.

distribuir(A/\(B\/C), T):-
    A \= _\/_,
    distribuir(A/\B, X),
    distribuir(A/\C, Y),
    distribuir(X\/Y, T).

distribuir(A/\(B/\C), M/\N/\O):-
    distribuir(A, M),
    distribuir(B, N),
    distribuir(C, O),!.

distribuir(A\/(B\/C), M\/N\/O):-
    distribuir(A, M),
    distribuir(B, N),
    distribuir(C, O),!.

distribuir(A\/B, X\/Y):-
    A \= B,
    (~A) \= B,
    distribuir(A, X),
    distribuir(B, Y).

distribuir(A/\B, X/\Y):-
    distribuir(A, X),
    distribuir(B, Y).

distribuir(A, A):-
    ground(A).

addElement(A, Conjunto, [A | Conjunto]).

reducir(A, _):-
    not(ground(A)).

reducir(A\/B, T):-
    distribuir(A, X),
    distribuir(B, Y),
    listar(X\/Y, L),
    sort(L, R),
    transformar2(R, T).

reducir(A/\B, Z):-
    distribuir(A, M),
    distribuir(B, N),
    reducir(M, X),
    reducir(N, Y),
    distribuir(X/\Y, Z).

reducir(A/\A, A).

reducir(A\/A, A).

reducir(A, A).

listar(A,_):-
    not(ground(A)).

listar(A, [A]):-
    A \= _\/_.

listar(A, T):-
    A = X\/Y,
    listar(X, R),
    addElement(Y, R, T).

transformar([A | Tail]):-
    member((~A), Tail).

transformar([(~A) | Tail]):-
    member(A, Tail).

transformar([_A | Tail]):-
    transformar(Tail).

transformar2(A, B):-
    not(transformar(A)),
    separar(A, X),
    distribuir(X, B).

transformar2(A, _):-
    transformar(A).

separar([A], A).

separar([A,B], A\/B).

separar([A | Tail], A\/T):-
    separar(Tail, T).

eliminarRep(A, _):-
    not(ground(A)).

eliminarRep(L, T):-
    listar2(L, S),
    sort(S, R),
    separar2(R, T).


listar2(A,_):-
    not(ground(A)).

listar2(A, [A]):-
    A \= _/\_.

listar2(A, T):-
    A = X/\Y,
    listar2(X, R),
    addElement(Y, R, T).


separar2([], []).

separar2([A], A).

separar2([A, B], A/\B).

separar2([A | Tail], A/\T):-
    separar2(Tail, T).

