:- [conjunto].

:- discontiguous negar/2.

% El predicado refutable recibe una fbf en forma
% normal conjuntiva y verifica si es refutable
% +FNCR: fbf en forma normal conjuntiva reducida
refutable(FNCR) :-
    descomponer_and(FNCR, LC),
    descomponer_or(LC, LL),
    refutar(LL).

% El predicado descomponer_and recibe una fbf en
% fncr +(A/\B), y la descompone en una lista de
% clausulas (Disyuncion de literales) -L
%
% Aclaracion: Al tratarse de un conjunto, el orden
% de los literales no importa
% TODO: ver por que si las expresiones van a ser
% parentizadas o no
descomponer_and(A,[]):-
    not(ground(A)).


descomponer_and(A, [A]):-
    A \= _/\_.

descomponer_and(A, T):-
    A = X/\Y,
    descomponer_and(X, R),
    descomponer_and(Y, S),
    append(R, S, T).

% El predicado descomponer_or recibe una lista
% de clausulas +LC y la descompone en una lista
% que contiene todas las listas de literales que
% formaban las clausulas recibidas -LL
descomponer_or([LC|LCs], [LL|LLs]) :-
    descomponer_clausula(LC, LL),
    descomponer_or(LCs, LLs).
descomponer_or([], []).

% El predicado auxiliar descomponer_clausula recibe
% una clausula +(A\/B) y la descompone en una lista
% de literales -L

descomponer_clausula(A,_):-
    not(ground(A)).

descomponer_clausula(A, [A]):-
    A \= _\/_.

descomponer_clausula(A, F):-
    A = X\/Y,
    descomponer_clausula(X, R),
    descomponer_clausula(Y, M),
    append(R, M, F).


% El predicado refutar recibe una lista de listas
% de literales +L, e intenta llegar a la lista
% vacia (Simbolizando a bottom), mediante el metodo
% de resoluion de literales complementarios
refutar(S) :-
    generar_todas_resolventes(S, T),
    pertenece([], T).
refutar(S) :-
    generar_todas_resolventes(S, T),
    not(pertenece([], T)),
    not(iguales(S, T)),
    refutar(T).
refutar([]).

% El predicado iguales verifica si dos conjuntos
% de resolventes +X e +Y son iguales
iguales([X|Xs],Y):-
    pertenece(X,Y),
    diferencia(Y,[X],AUX),
    iguales(Xs,AUX).
iguales([],[]).

% El predicado generar_todas_resolventes genera todas
% las resolventes del conjunto +S, y las guarda en el
% conjunto T
generar_todas_resolventes(S, T) :-
    findall(R,(pertenece(X,S),pertenece(Y,S),resolvente(X,Y,R1),sort(R1,R)),TMP),
    sort(TMP, T).

% El predicado resolvente genera la resolvente por
% literales complementarios de dos conjuntos +X e +Y,
% y la devuelve en -R
% Si no hay literal complementario entre ellos, devuelve
% al conjunto X como resolvente
resolvente([], _, []).
resolvente(X, X, X).
resolvente([X|Xs], Y, [X|R]) :-
    negar(X, NX),
    not(pertenece(NX, Y)),
    resolvente(Xs, Y, R).
resolvente([X|Xs], Y, R) :-
    negar(X, NX),
    pertenece(NX, Y),
    diferencia(Y, [NX], R1),
    union(Xs, R1, R).