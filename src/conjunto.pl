% Predicado auxiliar
lista_member(X, [X|_Xs]).
lista_member(X, [_Y|Ys]) :- lista_member(X, Ys).

% El predicado es_conjunto verifica si la
% lista +L modela un conjunto, es decir, no
% tiene elementos repetidos
es_conjunto([L|Ls]) :-
    not(lista_member(L, Ls)),
    es_conjunto(Ls).
es_conjunto([]).

% El predicado pertenece verifica si el
% elemento +X pertenece o no al conjunto
% +C (Requiere que C sea un conjunto valido)
pertenece(X, [_C|Cs]) :-
    pertenece(X, Cs).
pertenece(X, [X|_Xs]).

% El predicado agregar agrega el elemento +X
% al final del conjunto +C y lo retorna en la
% lista -L
%
% Aclaracion: Si el elemento X ya pertenece al
% conjunto, el predicado lo mueve al final del
% conjunto
agregar(X, [X|Cs], L) :-
    agregar(X, Cs, L).
agregar(X, [C|Cs], [C|Ls]) :-
    agregar(X, Cs, Ls).
agregar(X, [], [X]).

% El predicado union nos devuelve la union
% entre el conjunto +A y el conjunto +B
% en el conjunto -U
union([A|As], B, U) :-
    pertenece(A, B),
    !,
    union(As, B, U).
union([X|As], B, [X|U]) :-
    union(As, B, U).
union([], C, C).

% El predicado intersectar nos devuelve el
% conjunto con los elementos en comun entre
% el conjunto +A y +B en el conjunto -U
intersectar([X|As], B, U) :-
    pertenece(X, B),
    !,
    U = [X, Us],
    intersectar(As, B, Us).
intersectar([_|As], B, U) :-
    intersectar(As, B, U).
intersectar([], _B, []).
intersectar(_A, [], []).

% El predicado diferencia nos devuelve el
% conjunto que se obtiene de eliminar del
% conjunto +A los elementos que tiene en 
% comun con el conjunto +B, y lo devuelve
% en el conjunto -U
diferencia([], _, []).
diferencia(A, [], A).
diferencia([X|As], B, U) :-
    pertenece(X, B),
    !,
    diferencia(As, B, U).
diferencia([X|As], B, [X|U]) :-
    diferencia(As, B, U).