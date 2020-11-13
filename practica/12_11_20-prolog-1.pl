natural(cero).
natural(suc(N)) :- natural(N).

% hernan
add(U, cero, U).
add(X, suc(Y), suc(Z)) :- add(X, Y, Z).

%% ej
suma(X, Y, Z) :- add(X, Y, Z), natural(X), natural(Y).

resta(X, Y, Z) :- suma(Y, Z, X).

%% desde
desde(X, X).
desde(X, Y) :- N is X + 1, desde(N, Y).
% is es un aspecto extra logico.

% queremos definir entre(+X, +Y, -Z) esperamos que nos pasen instanciados X e Y,
% y tenemos que encarganos de calcular Z.
%entre(X, Y, Z) :- desde(X, Z), desde(Z, Y).
% hay dos generadores infinitos a la vez, no termina nunca
entre(Z, _, Z).
entre(X, Y, Z) :- W is X + 1, W =< Y, entre(W, Y, Z).

%% append
% viene con prolog, es reversible
% append(?L1, ?L2, ?L3)

% prefijo(+Lista, ?Pref)
prefijo(L, P) :- append(P, _, L).
sufijo(L, P) :- append(_, P, L).


% insertar(?X, +L, ?LconX)
insertar(X, L, LconX) :- append(Prefijo, Sufijo, L), append(Prefijo, [X|Sufijo],LconX)./
