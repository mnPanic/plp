# Finales

Links:

- [Gdoc con resueltos](https://docs.google.com/document/d/1o5P-UkgM4Eq9K6ESD9aSqnzXsrl9NAYivCugw4qGgME/edit#)
- [PDF con resueltos de cubawiki](https://www.cubawiki.com.ar/images/8/87/Plp-final-orales.pdf)
- [Repaso de prototipos en js](https://www.youtube.com/watch?v=DQ40dC4Z8i4&ab_channel=ParadigmasdeLenguajesdeProgramaci%C3%B3n)

## Jess verano 2022

- Haskell
  - diferencias entre foldl y foldr
  - ¿cualquier recursion se puede hacer con foldr?
- De calculo lambda:
  - que se perdia con ref

    que termine

  - si me da lo mismo evaluar un registro de izquierda a derecha (regla E-rcd o
    algo asi) o de derecha a izquierda con referencias

    No da lo mismo, ambas tienen cosas que se rompe.

    Si el valor de una etiqueta de un registro tiene side effects (al reducirse
    modifica memoria) y otro lo lee, dependiendo del orden en el que se ejecute

    let r: Ref Nat = ref 0 in
      { a = r := 1, b = !r}.b

- Subtipado:
  - Subtipado algoritmico qué es para qué sirve, me alcanza para todo?

    sirve para no descartar cosas "buenas", por ej. si tenés una suma que toma
    dos floats, le podrías pasar dos ints total se pueden pasar a 2.0. Mejor
    ejemplo puede ser registros

    para hacer el algoritmo tenés que hacer que sea determinístico. Sacás
    subsumption poniéndolo en la aplicación y sacas trans y refl agregando más
    casos bases

    nat float, bool float (trans)
    nat nat, float float, bool bool (sacar refl)

    si alcanza para todo, pero a nivel teórico es más restrictivo (no podes
    tipar de la nada 0 como float por ej. si no hay aplicaciones)

  - Regla de subtipado del if

    en gdoc de cubawiki

- calculo sigma:
  - diferencias en semantica con calculo lambda, big step small step cual era "mejor"

    big step = recursivo?
    small step = iterativo?

  - De prototipado que pasa si tengo objeto A = {p : 1}  que prototipa O = {}, y hago O.p, y que pasa si hago O.p = 5

    O.p busca el valor de p en O, pero como O no lo sabe responder lo busca en
    su prototipo (A), y luego de asignarle 5 se agrega la definición de O
    "desvinculandolo" de A en p.

- Resolución:
  - ¿resolucion lineal es completa?

    si

  - Resolucion sld
  - un ejemplito de si podia resolver en un paso una formulita que creo es igual a uno de los finales viejos (no me la acuerdo)
  - que onda el not, que pasa con not(G) si G es finito y no tiene sc, si es finito y tiene sc y si es infinito en ambos casos

Los folds cambian como ves a la lista, por ej [1, 2, 3, 4, 5]

foldr

  (1: (2: (3: (4: (5: [])))))

foldr (-) 0 [1, 2, 3] -> (1 - (2 - (3 - 0))) --> 2
foldl (-) 0 [1, 2, 3] -> (((0-1)-2)-3) --> -6

- Como se puede hacer recursión sin fix, usando ref.


-- Dado este foldD me pidio dar la estructura a la que lo estoy aplicando

```haskell
foldD :: (c->c) -> (a -> c -> c) -> (b -> c) -> D a b -> c

D a b = C1 (D a b) | C2 a (D a b) | C3 b
```

## Laura VR

```haskell
data MiDato a b = C1 (MiDato a b) | C2 a  | C3 a b
foldMiDato :: (c -> c) -> (a -> c) -> (a -> b-> c) -> (MiDato a b) -> c 
```

### Inferencia

Dar el algoritmo de inferencia para

```text
{x1:rho,...,xn:rho} > N : sigma   
-------------------------------
      {} > ?N : sigma
```

{x1: Nat, x2: Nat} > \x3 : Bool . (isZero(x1 + x2) or x3) : Bool
{} > \y : Bool . ?(isZero(x1 + x2) or y) : Bool


G, x :tau > M : sigma
--- (T-Abs)
G > \x : tau. M : sigma

isZero(x1 + .. + xn) : Bool sii xi : Nat

?isZero(x1 + ... + xn) : Bool

- Te permite decir que una variable tiene el tipo que quieras
- Te permite tener variables libres que no estén ligadas por una abs

Asumiendo
W(N) = {x1: rho_1 ... xn: rho_n} > N : sigma
S = MGU{rho_1 =.= rho_2, ..., rho_{n-1} =.= rho_n}

W(?N) = {} > S?N: S sigma

Ejemplos
?x + (if y then 0 else 1)
isZero(x1 + x2) or x3
\x3 . ?isZero(x1 + x2 + x3)

## Logica

¿Por qué si las reglas para LPO no son completas, en Prolog se pueden usar igual y anda?

Es completo para clausulas de Horn y en prolog es todo cláusula de horn.

Cómo funciona el not para árboles de resolución finitos e infinitos.

Vimos unos casitos de unificación, y discutimos si se podía unificar en un paso
a la cláusula {}:

```
* {p(X,a)}, {~p(b,X)}

  si renombamos si

* {p(X), q(a)}, {~p(b), ~q(Y)}

  1. {p(X), q(a)}
  2. {~p(b), ~q(Y)}
  3. {q(a), ~q(Y)}
  4. {}

  no hay refutación porque es SAT
  (paratodo X . p(X) o q(a)) y (paratodo Y . no p(b) o no q(Y))
  alcanza con elegir un modelo / estructura tq a tq valga q(a) y b tq no valga p(b)
```

7. Explicar la regla de resolución de primer orden

{B_1, ..., B_k, A_1, ..., A_n}  {no D_1, ..., no D_j, C_1, ..., C_m}
---- (resol LPO)
sigma({B_1, A_1, ..., A_n, C_1, ..., C_m})

donde sigma = MGU{B_1 ... B_k D_1 ... D_j}.

8. Se puede unificar en un paso?

buena practica: renombro las definiciones y no el goal
```
{P(a, f(X_2)), P(X_2,Y)}   {~P(a,X)}
X_2 = a
Y = f(a)
X = Y = f(a)

si
```

9. Soluciones de s(X) en este programa con cut:

s(X):- p(X).
s(0).

p(X) :- q(X).
p(1).

q(X):- r(X),!.
q(2).

r(3).
r(4).

X = 3; X = 1; X = 0

De lógica: not(P(X)), cuando falla, cuando no. Si el árbol de resolución es infinito, ¿qué pasa?
  not(g)  :- g,!,fail
  not(g). 

bombero(tomi).


