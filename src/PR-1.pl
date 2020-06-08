:- op(300,fx,~).     % negacion, prefija, no asociativa.
:- op(400,yfx,(/\)). % conjuncion, infija, asociativa a izquierda.
:- op(500,yfx,(\/)). % disyuncion, infija, asociativa a izquierda.
:- op(600,xfx,=>).   % implicacion, infija, no asociativa.
:- op(650,xfx,<=>).  % equivalencia, infija, no asociativa.

:- include(fnc2).       % carga de las operaciones para convertir una fbf
                       % a forma normal conjuntiva reducida
:- include(refutable). % carga de las operaciones para refutar una fbf en fncr

teorema(T) :-
    write('Iniciando prueba de teorema por refutacion...\n'),
    negar(T, NT),
    fncr(NT, FNCR),
    teoremaAux(FNCR), !.

teoremaAux(bottom).

teoremaAux(T):-
    refutable(T).

:- begin_tests(teorema).

test(teorema) :-
    teorema( ((a => b) /\ (a => c)) => (a => (b /\ c)) ).

test(teorema) :-
    teorema( ((a => b) /\ (a /\ c)) => (b \/ c) ).

% Este falla
test(teorema) :-
    teorema( (~(a \/ b)) <=> (~a /\ ~b) ).

% Este tambien
test(teorema) :-
    teorema( ((a => (b /\ (c \/ D))) /\ (~b \/ ~c)) => (a => D) ).

test(teorema) :-
    teorema( (((a => b) => c) => ((a => b) => (a => c))) ).

test(teorema) :-
    teorema( ((~a => b) => (~b => a)) ).

test(teorema) :-
    teorema( (~b => ~a) => ((~b => a) => b) ).

:- end_tests(teorema).
