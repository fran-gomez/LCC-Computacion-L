:- op(300,fx,~).     % negacion, prefija, no asociativa.
:- op(400,yfx,(/\)). % conjuncion, infija, asociativa a izquierda.
:- op(500,yfx,(\/)). % disyuncion, infija, asociativa a izquierda.
:- op(600,xfx,=>).   % implicacion, infija, no asociativa.
:- op(650,xfx,<=>).  % equivalencia, infija, no asociativa.


fncr(T, X) :-
    convertir(T, R),
    reducir(R, F),
    eliminarRep(F, X), !.

negar(A\/B, R):-
    distribuir(A, M),
    negar(M, X),
    distribuir(B, N),
    negar(N, Y),
    distribuir(X/\Y, T),
    reducir(T, R), !.

negar(A/\B, R):-
    distribuir(A, M),
    negar(M, X),
    distribuir(B, N),
    negar(N, Y),
    distribuir(X\/Y, T),
    reducir(T, R), !.

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

convertir(A\/(~A), top).

convertir(A/\(~A), bottom).

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

convertir(~A, S):-
    convertir(A, T),
    negar(T, R),
    distribuir(R, S),
    !.

convertir(A\/A, A).

convertir(A/\A, A).

convertir(A/\(~A), bottom).

convertir(X, T):- distribuir(X, T).

convertir(top, bottom).
convertir(bottom, top).

distribuir(top\/_A, top).

distribuir(_A\/top, top).

distribuir(A\/A, A).

distribuir((~A)\/A, top).

distribuir(A/\A, A).

distribuir(A/\B, X/\Y):-
    distribuir(A, X),
    distribuir(B, Y).

distribuir(A\/B, R):-
    distribuir(A, X),
    distribuir(B, Y),
    listar2(X, L),
    listar2(Y, M),
    combinarOr(L, M, N),
    sort(N, O),
    separar2(O, R).

distribuir(A, A):-
    ground(A).

%Distribuye los contenidos de las dos listas separadas por un \/.
combinarOr([], [], []).

combinarOr([A], [A], [A]).

combinarOr([A], [B], [A\/B]).

combinarOr([_A], [], []).

combinarOr([A], [B | Tail2], R):-
    combinarOrAux([A], [B | Tail2], R).

combinarOr([A | Tail1], [B | Tail2], R):-
    combinarOrAux([A], [B | Tail2], L),
    combinarOr(Tail1, [B | Tail2], M),
    append(L, M, R).

combinarOrAux([_A | _Tail1], [], []).

combinarOrAux([A | Tail1], [A | Tail2], [A | R]):-
    combinarOrAux([A | Tail1], Tail2, R).

combinarOrAux([A | Tail1], [B | Tail2], [A\/B | R]):-
    combinarOrAux([A | Tail1], Tail2, R).

%Reduce las expresiones, eliminando elementos iguales.
reducir(top, top).

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

reducir(A/\(~A), bottom).

reducir(A/\A, A).

reducir(A\/(~A), top).

reducir(A\/A, A).

reducir(A, A).

reducir(A, top):-
    not(ground(A)).

%Lista los elementos de una formula disyuntiva.
listar(A,_):-
    not(ground(A)).

listar(A, [A]):-
    A \= _\/_.

listar(A, F):-
    A = X\/Y,
    listar(X, R),
    listar(Y, M),
    append(R, M, T),
    checkForTop(T, F).

checkForTop(L, []):-
    member(top, L).

checkForTop(L, L).

% Verifica que no este A y ~A simultaneamente en una lista. Si encuentra
% a A y a ~A en la lista, retorna top. Caso contrario, retorna la misma
% lista.
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

transformar2(A, top):-
    transformar(A).

separar([A], A).

separar([A,B], A\/B).

separar([A | Tail], A\/T):-
    separar(Tail, T).

eliminarRep(A, _):-
    not(ground(A)).

eliminarRep(L, T):-
    listar2(L, S),
    not(member(bottom, S)),
    sort(S, R),
    separar2(R, T).

eliminarRep(_L, bottom).

listar2(top, []).

listar2(A,[]):-
    not(ground(A)).

listar2(A, [A]):-
    A \= _/\_.

listar2(A, T):-
    A = X/\Y,
    listar2(X, R),
    listar2(Y, S),
    append(R, S, T).


separar2([], []).

separar2([A], A).

separar2([A, B], A/\B).

separar2([A | Tail], A/\T):-
    separar2(Tail, T).

