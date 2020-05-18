lista([]).
lista([_X|Xs]) :- lista(Xs).

crear_lista(X, Y, L) :- L = [X, Y].

insertar_inicio(X, Xs, [X|Xs]).

insertar_final(X, [], [_|X]).
insertar_final(X, [_L|Ls], RTA) :- insertar_final(X, Ls, RTA).

concatenar([], Y, Y).
concatenar([X|Xs], Y, [X|Ls]) :- concatenar(Xs, Y, Ls).

lista_member(X, [X|_Xs]).
lista_member(X, [_Y|Ys]) :- lista_member(X, Ys).

invertir([], []).
invertir([X|Xs], L) :- invertir(Xs, Inv), concatenar(Inv, [X], L).

terminar([], []).
terminar([X|Xs], [X|L]) :- terminar(Xs, L).

borrar_una(_X, [], []).
borrar_una(X, [X|Xs], L) :- terminar(Xs, L).
borrar_una(X, [Y|Ys], [Y|L]) :- borrar_una(X, Ys, L).

borrar_todas(_X, [], []).
borrar_todas(X, [X|Xs], L) :- borrar_todas(X, Xs, L).
borrar_todas(X, [Y|Ys], [Y|L]) :- borrar_todas(X, Ys, L).

cambiar_una(_X, _N, [], []).
cambiar_una(X, N, [X|Xs], [N|L]) :- terminar(Xs, L).
cambiar_una(X, N, [Y|Ys], [Y|L]) :- cambiar_una(X, N, Ys, L).

cambiar_todas(_X, _N, [], []).
cambiar_todas(X, N, [X|Xs], [N|L]) :- cambiar_todas(X, N, Xs, L).
cambiar_todas(X, N, [Y|Ys], [Y|L]) :- cambiar_todas(X, N, Ys, L).