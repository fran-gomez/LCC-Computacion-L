:- begin_tests(descomponer_and).


descomponer_and(A /\ B, [A|Ls]) :-
    descomponer_and(B, Ls).
descomponer_and(A, [A|_Ls]).

test(descomponer_and) :-
    descomponer_and((a/\b), L).

test(descomponer_and) :-
    findall(L, descomponer_and((a/\b), L)).

test(descomponer_and) :-
    findall(L, descomponer_and((a/\b), L)).

test(descomponer_and) :-
    findall(L, descomponer_and((a/\b), L)).

test(descomponer_and) :-
    findall(L, descomponer_and((a/\b), L)).


:- end_tests(descomponer_and).
