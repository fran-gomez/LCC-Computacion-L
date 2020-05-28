:- [conjunto].
:- [fnc].

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
    write(T), nl,
    negar(X, NX),
    diferencia(T, [NX], DIF),
    write(DIF),  nl,
    diferencia(Ls, [T], DIF2),
    write(DIF2), nl,
    union(DIF2, [DIF], UNION),
    write(UNION), nl,
    write([Xs|UNION]), nl,
    nl, nl,
    refutar([Xs|UNION]).
refutar([[]|Ls]) :-
    refutar(Ls).
refutar([]).

% El predicado buscar_lit_complementario busca el literal
% complementario del parametro +X en la lista de listas de
% literales y devuelve la lista de literales que lo contiene
%
% Hay un error aca que no me doy cuenta como arreglar, cuando
% un literal no tiene su complementario, este predicado deberia
% fallar en lugar de devolver la lista vacia.
buscar_lit_complementario(X, [L|_Ls], T) :-
    negar(X, NX),
    pertenece(NX, L),
    T = L.
buscar_lit_complementario(X, [_L|Ls], T) :-
    buscar_lit_complementario(X, Ls, T).
buscar_lit_complementario(_, [], []). % Aca tendria que hacer algo tipo return false