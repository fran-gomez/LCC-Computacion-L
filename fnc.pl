:- op(300,fx,~).     % negacion, prefija, no asociativa.
:- op(400,yfx,(/\)). % conjuncion, infija, asociativa a izquierda.
:- op(500,yfx,(\/)). % disyuncion, infija, asociativa a izquierda.
:- op(600,xfx,=>).   % implicacion, infija, no asociativa.
:- op(650,xfx,<=>).  % equivalencia, infija, no asociativa.

fncr((X /\ Y), (A /\ B)) :- fncr(X, A), fncr(Y, B).
%fncr((X \/ Y), R).

fncr(T, R) :- convertir(T, R).

convertir(~(~X), R) :- convertir(X, R).
convertir(~(X /\ Y), R) :- convertir((~X \/ ~Y), R).
convertir(~(X \/ Y), R) :- convertir((~X /\ ~Y), R).
convertir((X <=> Y), R) :- convertir((X => Y), R), convertir((Y => X), R).
convertir((X => Y), R) :- convertir((~X \/ Y), R).
convertir(X, X).

distribuir(X /\ (Y \/ Z), (X /\ Y) \/ (X /\ Z)).
distribuir(X \/ (Y /\ Z), (X \/ Y) /\ (X \/ Z)).
distribuir(X, X).
