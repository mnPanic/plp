%% ejercicios de la clase de prolog de dani, 1c2020
% make. recarga el programa

% el predicado coronavirus es cierto cuando tiene como argumento murcielago
% dicho coloquialmente, el murcielago produce coronaviurs.
coronavirus(murcielago).

% pl: comio es verdadero cuando su primer arg es carlos y el segundo es ensalada
% coloquialmente, carlos comio una ensalada
comio(carlos, ensalada).
comio(alicia, murcielago).

tomaron_mate(sandra, alicia).
tomaron_mate(alberto, carlos).

infectado(X) :- comio(X, Y), coronavirus(Y).
infectado(X) :- tomaron_mate(X, Y), infectado(Y).

%%%% Ej 1 %%%%
% functor natural/1 dado por
natural(cero).                  % el cero es un natural
natural(suc(X)) :- natural(X).  % el sucesor de un natural es natural

% Escribir el predicado para el functor menor/2
% menor(X, Y) es verdadero cuando X < Y

% forma mia
% menor(X, suc(X)) :- natural(X).
% menor(X, suc(Y)) :- menor(X, Y).

% otra forma, clase dani
menor(cero, suc(X)) :- natural(X).
menor(suc(X), suc(Y)) :- menor(X, Y).
% no es necesario hacer esto ya que se chequea en el caso base.
% menor(suc(X), suc(Y)) :- natural(X), natural(Y), menor(X, Y).

% interesante: se comportan diferente para el goal menor(X, Y).

%%%% Ej 2 %%%%
% definir entre(+X, +Y, -Z) que es verdadero cuando el numero entero Z esta
% comprendido entre los numeros enteros X e Y (inclusive)

% mi sol
% entre(Z, _, Z).
% entre(X, Y, Z) :- W is X+1, W =< Y, entre(W, Y, Z).

% clase dani
% entre(X, Y, Z) :- X = Z. es lo mismo que
% entre(X, _, X). % ya que se saltea el paso de unificacion
% idea: "recursivamente" incrementar X

% esta bien pero no se va a evaluar X+1, podes poner terminos
% entre(X,Y,Z) :- entre(X+1, Y, Z).

entre(X, Y, X) :- X =< Y.
entre(X,Y,Z) :- X < Y, W is X+1, entre(W, Y, Z).

% ya esta definido en el motor logico y se llama between.

%%%% Listas %%%%
%% Ej 1 - long/2 %%
% definir el predicado para el functor long/2 que relaciona una lista con su
% longitud.

% long(+LS, -N)
% long([], N) :- N = 0.                         % tambien vale pero es al pedo
long([], 0).                                    % Caso base, lista vacia
long([_ | XS], L) :- long(XS, L2), L is L2+1.   % "Llamado recursivo"

% Ya viene en el motor de prolog y se llama length.

%% Ej 2 - sinConsecRep/2
% Sin consecutivos repetidos que relaciona una lista con otra que contiene los
% mismos elementos sin las repeticions consecutivas.
%   ?- sinConsecRep([1, 2, 2, 2, 3, 2], L).
%   L = [1, 2, 3, 2].

% sinConsecRep(+L1, -L2)
sinConsecRep([], []).
sinConsecRep([X], [X]).
sinConsecRep([X, X | XS], L) :- sinConsecRep([X|XS], L).
% tengo que especificar si o si que son distintos, no basta con que
% las variables se llamen distinto.
sinConsecRep([X, Y | XS], [X|L]) :- X \= Y, sinConsecRep([Y|XS], L).

%% Ej 3 %%
% Usando
append([], L, L).
append([X | L1], L2, [X | L3]) :- append(L1, L2, L3).
% Dice si L1 + L2 = L3

% Implementar
% prefijo(+L, ?P): tiene exito si P es un prefijo de la lista L.
prefijo(L, P) :- append(P, _, L).

% sufijo(+L, ?S): tiene exito si S es un sufijo de la lista L.
sufijo(L, S) :- append(_, S, L).

% sublista(+L, ?SL): tiene exito si SL es una sublista de L.
% esta mal, rehacer
sublista(_, []).
sublista([X|L], [S|SL]) :- X = S, prefijo(L, SL).
sublista([X|L], [S|SL]) :- X \= S, sublista(L, [S|SL]).

% insertar(?X, +L, ?LX): Tiene exito si LX puede obtenerse insertando a X en
% alguna posicion de L.

% ej.
% 3 [1, 2] [3, 1, 2], [1, 3, 2], [1, 2, 3]
% pista: usando append
insertar(X, L, LX) :- 
    %prefijo(L, P), sufijo(L, S), append(P, S, PS), L = PS,
    append(P, S, L),
    append(P, [X|S], LX).

% permutacion(+L, ?P): Tiene exito si P es una permutacion de los elementos de
% L.
permutacion([], []).
% si ya tengo las permutaciones del resto de la lista, basta con insertar el
% primero en todas las posiciones posibles.
permutacion([L|LS], P) :- permutacion(LS, P2), insertar(L, P2, P).

%% Ej 4 %%
% Considerando el siguiente predicado
member(X, [X, _]).
member(X, [_, L]) :- member(X, L).

% Realizar un seguimiento de las siguientes consultas (haciendo el arbolito y
% viendo como funciona)
% ?- member(2, [1, 2]).
% ?- member(X, [1, 2]).
% ?- member(5, [X, 3, X]).
% length(L, 2), member(5, L), member(2, L).