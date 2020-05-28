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
descomponer_and( ( (A) /\ (B) ), [L|Ls]) :-
    descomponer_and(A, Ls),
    L = B.
descomponer_and(A, [A]).

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
descomponer_clausula( ( (A) \/ (B) ), [L|Ls]) :-
    descomponer_clausula(A, Ls),
    L = B.
descomponer_clausula(A, [A]).

% El predicado refutar recibe una lista de listas
% de literales +L, e intenta llegar a la lista
% vacia (Simbolizando a bottom), mediante el metodo
% de resoluion de literales complementarios
refutar([[X|Xs]|Ls]) :-
    buscar_lit_complementario(X, Ls, T),
    negar(X, NX),
    diferencia(T, [NX], DIF),
    diferencia(Ls, [T], DIF2),
    union(DIF2, [DIF], UNION),
    refutar([Xs|UNION]).
refutar([[]|Ls]) :-
    refutar(Ls).
refutar([]).
refutar(bottom).

% El predicado buscar_lit_complementario busca el literal
% complementario del parametro +X en la lista de listas de
% literales y devuelve la lista de literales que lo contiene
buscar_lit_complementario(X, [L|_Ls], T) :-
    negar(X, NX),
    pertenece(NX, L),
    T = L.
buscar_lit_complementario(X, [_L|Ls], T) :-
    buscar_lit_complementario(X, Ls, T).

%=======================================%
%   Unidades de testeo de predicados    %
%=======================================%
:- begin_tests(refutar).

test(refutar) :-
    refutar([]).

test(refutar) :-
    refutar([ [a, ~b], [b, ~a] ]).

test(refutar) :-
    refutar([ [a, b], [~a, ~c], [~b, c] ]).

test(refutar) :-
    refutar([ [a, c, d], [~b, ~d], [~a, ~c, b] ]).

test(refutar) :-
    refutar([ [a, c, d], [~b, ~d], [~a, ~c, b], [f] ]).

test(refutar) :-
    refutar([ [a, c, d], [~b, ~d], [~a, ~c, b], [f], [g, ~f] ]).

test(refutar) :-
    refutar([ [~a, ~b, ~c, ~d], [a, b, c, d] ]).

test(refutar) :-
    refutar([ [a], [b], [c], [d], [~d], [~a], [~c] ]).

test(refutar) :-
    refutar([a, b, c, d]).

test(refutar) :-
    refutar([ a, b, ~a, ~b ]). % Recien me avive que esto reduce a top en fncr...

test(refutar) :-
    refutar([top]).

test(refutar) :-
    refutar([bottom]).

:- end_tests(refutar).

