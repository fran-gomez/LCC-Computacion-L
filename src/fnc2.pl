
fncr(T, X) :-
    convertir(T, R),
    distribuir(R, X).

convertir(~(~X), Y) :- 
    !,
    convertir(X, Y).

convertir(~(X /\ Y), Z) :-
    !,
    convertir((~X \/ ~Y), Z).

convertir(~(X \/ Y), Z) :-
    !, 
    convertir((~X /\ ~Y), Z).

convertir(~(X => Y), Z) :-
    !, 
    convertir((X /\ ~Y), Z).

convertir(~(X <=> Y), Z) :-
    !,
    convertir((X /\ ~Y) \/ (~X /\ Y), Z).

convertir((X <=> Y), (A /\ B)) :-
    !,
    convertir((X => Y), A),
    convertir((Y => X), B).

convertir((X => Y), A) :-
    !,
    convertir((~X \/ Y), A).

convertir((X /\ Y), (A /\ B)) :-
    !,
    convertir(X, A),
    convertir(Y, B).

convertir((X \/ Y), (A \/ B)) :-
    !,
    convertir(X, A),
    convertir(Y, B).

convertir(X, X).

distribuir((X /\ Y) \/ Z, (X \/ Z) /\ (Y \/ Z)) :-
    !.

distribuir(X \/ (Y /\ Z), (X \/ Y) /\ (X \/ Z)) :-
    !.
distribuir(X, X).