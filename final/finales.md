# Finales

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
