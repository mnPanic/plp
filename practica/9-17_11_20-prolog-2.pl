% Programacion logica parte 2

% Patrones de instanciacion
%   -: no instanciado
%   +: instanciado
%   ?: puede o no estar instanciado

% Predicados utiles
%   var(A) tiene exito si A es una variable libre (no instanciada)
%   nonvar(A) tiene exito si A no es una var libre
%   ground(A) tiene exito si A no contiene variables libres
%             es para cosas que pueden estar semi instanciadas

%% ej 1 - iesimo

% iesimo(+I, +L, -X) X es el iesimo elemento de la lista L.
% se puede asumir 
% mia
% iesimo(0, [Y|_], Y).
% iesimo(I, [_|L], X) :- J is I-1, iesimo(J, L, X).
% sin el chequeo de I > 0 termina cortando el negativo infinito con la longitud
% de la lista.

% dani
iesimo(0, [Y|_], Y).
iesimo(I, [_|L], X) :- I >= 0, J is I-1, iesimo(J, L, X).
% =\= es la desigualdad aritmetica, resuelve cada lado y despues compara
% sin el I =\= 0 justo este ej anda, pero es mejor intentar que las clausulas
% sean disjuntas
% iesimo(J-1, L, X) si hacemos eso no se resuelve.

% singleton = que se usa en un solo lugar, por lo tanto no se va a unificar y no
% tiene sentido haberle puesto un nombre

% revsersibilidad
% ?- iesimo(I, [5, 6, 7], X)
%   I = 0, X = 5; ...
iesimoR(I, L, X) :- length(L, LEN), between(0, LEN, I), iesimo(I, L, X).

%% Ej 2 - desde
desde(X, X).
desde(X, Y) :- N is X+1, desde(N, Y).

% desde(+X, ?Y)
% X necesariamente tiene que estar instanciada porque se usa al lado derecho de
% un `is`.

% desde(+X, ?Y)
% si esta instanciada, es verdadero si Y es mayor o igual que X, sino, genera
% todos en adelante.
desde2(X, Y) :- var(Y), desde(X, Y).
desde2(X, Y) :- nonvar(Y), Y >= X.

% pmq(+X, -Y): pares menores que. Instanciar en Y todos los pares menores a X.
%   Y = 0;
%   Y = 2;
%   Y = 4;
%   Y = 6;

% X mod 2 =:= 0
par(X) :- X mod 2 =:= 0.
pmq(X, Y) :- between(0, X, Y), par(Y).
% idea: desde, regla general: no esta bueno usar generacion infinita para
% generacion finita.

% tecnica llamada Generate & Test
% generar numeros posibles y testear los posibles
% pred(X1, ..., Xn) :- generate(X1, ..., Xn), test(X1, ..., Xm)

%% Ej - coprimos
% coprimos(-X, -Y) 
% que instancia en X e Y todos los pares de numeros coprimos.
% tip: usar gcd del motor aritmetico, X is gcd(2, 4) instancia X = 2.
% hacerlo usando generate & test

% armarPares(-X, -Y)
% no podemos usar dos desdes porque el 2do se va al infinito
armarPares(X, Y) :- desde(1, S), between(1, S, X), Y is S - X.
% no se puede con 2 between porque genera repetidos, lo cual no queremos.

% sonCoprimos(-X, -Y)
sonCoprimos(X, Y) :- 1 is gcd(X, Y).
% esquema de generate & test.
coprimos(X, Y) :- armarPares(X, Y), sonCoprimos(X, Y).


%%% repetidos
% es mas imperativa
% setof(-Var, +Goal, -Set)
% Genera una lista de todas las posibles instanciaciones, y le saca los
% repetidos.

%% metapredicado: toma como argumento otro predicado

%% not: es un metapredicado
% not(P) :- call(P), !, fail.
% not(P).
% not(P). Devuelve el otro.
% Si call(P) falla, el not(P). de abajo va a devolver true y se reintenta.
% Si P no falla, con ! se corta la ejecucion y con fail devuelve true.


% not da verdadero cuando no hay sustitucion posible.
% si la hay, devuelve false.

% es lo que se llama negacion por falla
% no deja las var instanciadas despues
%  not(pmq(5, 2)), 

% !: cut, sirve para podar el arbol de ejecucion.
% call: llamar a ese predicado

%% negacion por falla
% corteMasParejo(+L, -L1, -L2)
% L es una lista de numeros y L1 y L2 representan el corto mas parejo posible de
% L respecto a la suma de sus elementos (sumlist/2). Puede haber mas de uno

% ?- corteMasParejo([1, 2, 3, 4, 2], I, D).
%   I = [1, 2, 3], D = [4, 2];
%   false.
% ?- corteMasParejo([1, 2, 1], I, D).
%   I = [1], D = [2, 1];
%   I = [2, 1], D = [1];
%   false.

corteMasParejo(L, I, D) :- unCorte(L, I, D, D), not(hayMejorDiferencia(L, D))
% unCorte(+L, -L1, -L2, -D)
unCorte(L, I, D, V) :- append(I, D, L), sumlist(L, SI), sumlist(L, SD), V is abs(SI - SD).
hayMejorDiferencia(L, D) :- unCorte(L, _, _, D2), D2 < D.
% si le ponemos = siempre va a haber un corte que sea igual

% sugerencia para perimetro
% no hacer una clausula para cada una de los 4 casos
% todo instanciado y todo sin instanciar, y si alguna de yapa da otra.
% ground