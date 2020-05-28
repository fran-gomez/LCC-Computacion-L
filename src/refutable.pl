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
refutar([[X|_Xs]|Ls]) :-
    buscar_lit_complementario(X, Ls), !.
%    negar(X, NX),
%    diferencia(T, [NX], DIF),
%    diferencia(Ls, [T], DIF2),
%    union(DIF2, [DIF], UNION),
refutar([[_X|Xs]|Ls]) :-
    refutar([Xs|Ls]).
refutar([[]|Ls]) :-
    refutar(Ls).
refutar([]).
refutar(bottom).

% El predicado buscar_lit_complementario busca el literal
% complementario del parametro +X en la lista de listas de
% literales
buscar_lit_complementario(X, [L|_Ls]) :-
    negar(X, NX),
    pertenece(NX, L).
buscar_lit_complementario(X, [_L|Ls]) :-
    buscar_lit_complementario(X, Ls).

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

test(refutar) :-
    refutar([[a], [~b], [a, b], [a, ~b], [b, ~a], [~a, ~b]]).

:- end_tests(refutar).

