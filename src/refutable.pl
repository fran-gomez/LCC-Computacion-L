
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
% TODO: ver por que si aparece un or deja de dividir
descomponer_and(A /\ B, [L|Ls]) :-
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
descomponer_clausula(A \/ B, [L|Ls]) :-
    descomponer_clausula(A, Ls),
    L = B.
descomponer_clausula(A, [A]).

% El predicado refutar recibe una lista de listas
% de literales +L, e intenta llegar a la lista
% vacia (Simbolizando a bottom), mediante el metodo
% de resoluion de literales complementarios
%
% TODO: AUN NO IMPLEMENTADO
refutar([L|Ls]) :-
    refutar(L),
    refutar(Ls).
refutar([]).

