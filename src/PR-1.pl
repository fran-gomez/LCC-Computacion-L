:- op(300,fx,~).     % negacion, prefija, no asociativa.
:- op(400,yfx,(/\)). % conjuncion, infija, asociativa a izquierda.
:- op(500,yfx,(\/)). % disyuncion, infija, asociativa a izquierda.
:- op(600,xfx,=>).   % implicacion, infija, no asociativa.
:- op(650,xfx,<=>).  % equivalencia, infija, no asociativa.

:- include(fnc).       % carga de las operaciones para convertir una fbf
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

