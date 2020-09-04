# Practica 03/09/20 - Intro a haskell

Dado

    prod :: Int -> Int -> Int
    prod x y = x * y

lo que hay en el fondo

El tipo funcion es

    a -> b

Entonces la manera correcta de leer el tipo de prod es una func que toma un
entero, y devuelve una func que toma un entero y devuelve un entero.

    prod :: Int -> (Int -> Int)

Esos parentesis estan implicitos. Esta bien hacer el "abuso" de decir que toma
dos argumentos siempre y cuando sepamos lo que esta en el fondo.

Definimos

    doble x = prod 2 x

1. Cual es el tipo de doble?

   doble :: Int -> Int

2. Que pasa si hacemos `doble = prod 2`?

   Se llama **aplicacion parcial**. Podemos no pasarle todos los argumentos.

   Cuando hacemos `prod 2` estamnos "fijando" el primer argumento, con lo cual
   el tipo que queda es `Int -> Int`. Lo hardcodeo.

3. Que significa `(+) 1`?

   > El `+` es una funcion con notacion **infija**, hacemos 1 + 2 escribiendolo en
   > el medio de los dos argumentos. Con `()` lo convertimos en una prefija.

   `(+) 1` entonces devuelve `\x -> x + 1`.

4. Definir de forma similar a la anterior `triple :: Float -> Float`

    Se puede hacer como una funcion anonima

        \x -> x*3

    Y otra opcion es

        (*3)
        (3*)

    Para tomar funciones que esperan un argumento para multiplicarlo.

`esMayorDeEdad :: Int -> Bool`

(>=18)

## Ejs

### 1

#### a

Implementar la funcion composicion

```haskell
f . g x = f(g(x))

-- () denota que se usa de forma infija
(.) :: (b -> c) -> (a -> b) -> a -> c
(.) f g x = f (g x) -- son importantes los parentesis
-- por la manera de agruparlo, si hacemos f g x haskell nos dice que f no toma 2 
-- parametros, solo 2.
-- otra forma
(.) f g = \x -> f (g x)

-- otro tipo
(.) :: (b -> c) -> (a -> b) -> (a -> c)
-- representa mejor la funcion composicion, ya que devuelve otra funcion en vez
-- de un valor.
```

`((\x -> x * 4) . (\y -> y - 3)) 10` devuelve 28

#### b

`flip` invierte los argumentos de una funcion.

    flip (\x y -> x - y) 1 5 devuelve 4

```haskell
flip :: (a -> b -> c) -> (b -> a -> c)
-- flip f x y = f y x
flip f = (\x y -> f y x)    -- con notacion lambda, se parece mas a lo que hace
```

#### c

`($)` que aplica una fn a un arg. Por ej. `id $ 6 ---> 6`

```haskell
($) :: (a -> b) -> (a -> b)
-- sol 1
($) f x = f x
-- otra, mas linda porque representa mas lo que hace la func
($) f = \x -> f x
```

Aplica la funcion al argumento

### 2

Que hace `flip ($) 0`?

flip ($) devuelve una funcion $ que toma primero el argumento y despues la
funcion que va a aplicar.

`flip ($) 0` toma una funcion y la devuelve aplicada al 0.
Es una funcion que toma una funcion y devuelve el resultado de aplicarla a 0

### 3

(== 0) . (flip mod 2)

mod 10 2 hace 10 % 2, entonces flip mod 2 x hace x % 2

(\x -> x == 0) . (\y -> mod y 2)

\y -> mod y 2 == 0

even

> mod se puede usar infijo con backticks ``mod``

## Mas ejs

Operador let .. in

```haskell

maximo :: Ord a => [a] -> a
maximo [x] = x
maximo (x:xs) =
    let m = maximo xs
    in if x > m then x else m

minimo :: Ord a => [a] -> a
minimo [x] = x
minimo (x:xs) =
    let m = minimo xs
    in if x < m then x else m

listaMasCorta :: [[a]] -> [a]
listaMasCorta [l] = l
listaMasCorta (l:ls) =
    let lmc = listaMasCorta ls
    in if length l < length lmc then l else lmc
```

Hay algun esquema recursivo que lo resuelva?

```haskell
mejorSegun :: (a -> a -> Boolean) -> [a] -> a
mejorSegun _ [x] = x
mejorSegun f (x:xs) =
    let m = (mejorSegun f xs)
    in if f x m then x else m
```

Y reescribiendo las funciones que ya tenemos, 

```haskell
maximo = mejorSegun (>)         -- usando aplicacion parcial
maximo xs = mejorSegun (>) xs   -- sin usar aplicacion parcial

minimo = mejorSegun (<)

listaMasCorta = mejorSegun (\l1 l2 -> length l1 < length l2)
```

## Listas

Formas de definir

```haskell

-- Por extension
-- es dar la lista explicita, escribiendo todos los elementos

[4, 6, 5, 1, 12, 23]

-- Secuencias
-- progresiones aritmeticas en un rango particular

[3..7]          -- es la lista que tiene todos los numeros enteros entre 3 y 7
[2, 5..18]      -- es la lista que contiene 2, 5, 8, 11, 14 y 17

-- Por comprension
-- Se definen
--  [expresion | selectores, condiciones]

-- expr      sel x        sel y      cond
[(x, y) | x <- [0..5], y <- [0..3], x+y==4]

-- x <- [0..5] es el selector de x
-- y <- [0..3] es el selector de y

-- Recorre todas las tuplas posibles
-- es la lista que tiene los pares (1,3), (2,2), (3,1) y (4,0)

### Listas infinitas

```haskell

naturales = [1..]       -- 1, 2, 3, 4, ...

multiplosDe3 = [0,3,..] -- 0, 3, 6, 9

repeat "hola"           -- "hola", "hola", ...

primos = [n | n <- [2..], esPrimo n]

infinitosUnos = 1: infinitosUnos    -- 1, 1, 1, 1, 1
```

Es posible hacer esto ya que las evaluaciones de haskell son lazy. Evalua solo
cuando es necesario, y va reduciendo de afuera hacia adentro y de izquierda
a derecha.

```haskell
-- take n toma los primeros n elementos de la lista
take :: Int -> [a] -> [a]
take 0 _ = []
take _ [] = []
take n (x:xs) = x : take (n-1) xs

inf1 :: [Int]
inf1 = 1:inf1

nUnos :: Int -> [Int]
nUnos n = take n inf1
```

Mostrar los pasos necesarios para reducir `nUnos 2`

```haskell
nUnos 2
take 2 inf1
take 2 (1:inf1)
1 : (take (2-1) inf1)
1 : (take 1 inf1)
1 : (take 1 (1:inf1))
1 : (1 : (take (1-1) inf1))
1 : (1 : (take 0 inf1))
1 : (1 : [])
[1, 1]
```

- Que sucederia si usaramos otra estrategia de reduccion?

> Si usaramos *eager* y se intentase de reducir todo lo posible cada uno,
> entonces no se terminaria nunca de reducir `inf1`.

- Existe algun termino que admita una reduccion finita pero para el cual la lazy
  no termine?

## Esquemas de recursion sobre listas

### map

```haskell
map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x:xs) = f x : map f xs
```

Definir usando map

```haskell
-- 1. shuffle, dada una lista de indices [i_1, ..., i_n] y una lista l, devuelve
-- la lista [l_i_1, ..., l_i_n]
--
-- Ayuda: l !! n devuelve el elem de l en la pos n
--
-- Ejemplo
-- shuffle [4, 1, 3] [6, 7, 8, 9, 10] ---> [10, 7, 9]
-- Asumir que los indices son validos.

shuffle :: [Int] -> [a] -> [a]
shuffle is l = map (\i -> l !! i) is
shuffle is l = map (l !!) is            -- otra opcion mas corta
```

### filter

```haskell
filter :: (a -> bool) -> [a] -> [a]
filter _ [] = []
filter f (x:xs)
    | f x = x : (filter f xs)
    | otherwise = filter f xs

-- otra de la 2da parte
filter f (x:xs) =
    if f x
    then x : (filter f xs)
    else filter f xs
```

Definir usando filter

```haskell
-- 1. filtra aquellas listas con longitud n
deLongitudN :: Int -> [[a]] -> [[a]]
deLongitudN n ls = filter (\l -> length l == n) ls

deLongitudN n = filter (\l -> length l == n)

deLongitudN n = filter ((==n) . length)

-- id $ 6 --> 6
-- ($) id 6 --> 6
-- flip ($) 6 id --> 6

-- 2. Dados un numero n y una lista de funciones, deja las que al aplicarlas a
-- n dan n.
soloPuntosFijosEnN :: Int -> [(Int -> Int)] -> [(Int -> Int)]
soloPuntosFijosEnN n fs = filter (\f -> f n == n) fs
soloPuntosFijosEnN n = filter (==n) . (flip ($) n)      -- turbio

-- reduccion
-- teniendo en cuenta que 
--  (.) f g = \x -> f (g x)
--  flip f x y = f y x
(==n) . (flip ($) n) f
\f -> (==n) (flip ($) n f)
\f -> (==n) (($) f n)
\f -> (==n) f n
```

quicksort???? Preguntar

### General

Definir sin usar recursion explicita (usando esquemas de recursión)

```haskell
-- Dada una lista de strings, devuelve una lista con cada string dado vuelta, y
-- la lista completa dada vuelta.
-- Por ej
--  reverseAnidado ["quedate", "en", "casa"] --> ["asac", "ne", "etadeuq"]
--
-- Ayuda: Ya existe la funcion `reverse` que invierte una lista
reverseAnidado :: [[Char]] -> [[Char]]
reverseAnidado ss = reverse (map reverse ss) -- los parentesis son importantes
reverseAnidado = reverse . (map reverse)

-- Dada una lista de enteros, devuelve una lista con los cuadrados de los
-- numeros pares
paresCuadrados :: [Int] -> [Int]
-- filtro los pares, y a todos esos los elevo al cuadrado
paresCuadrados xs = map (^2) (filter even xs)
paresCuadrados = (map (^2)) . (filter even)
```
