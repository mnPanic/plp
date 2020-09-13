# Learn You a Haskell for Great Good!

Notas de http://learnyouahaskell.com, en spanglish. Don't @ me.

## Introduction

- **Referential transparency**: If a function is called twice with the same
  parameters, it's guarenteed to return the same result. It allows the compiler
  to reason about the progam's behaviour, and also allows you to easily deduce
  (and prove) that a function is correct and then build more complex functions
  by gluing them together.

- **Lazy**: Haskell has *lazy evaluation*, meaning it won't execute functions
  and calculate things until it's forced to show a result.

- Haskell is **statically typed**: When the program is complied, the compiler
  knows which piece of code is a number, a string, etc.

  It uses a type sistem that has **type inference**. You don't have to
  explicitly label everything with types because the type system can
  intellingently figure out a lot about them. For example,

  ```haskell
  a = 5 + 4
  ```

  You don't have to tell haskell that `a` is a number, it can figure it out by
  itself.

### GHCi

Es el interprete interactivo de haskell. Permite cargar programas mediante

```bash
# asumiendo somefile.hs
:l somefile
```

Si se cambia el file, se puede cargar devuelta o directamente usar `:r` que hace
eso.

## Starting Out

- Numeros negativos: Es necesario ponerlos entre parentesis porque sino ghci te
  putea. i.e `(-3)` en vez de `-3`

- Inequality: En vez de el usual `!=` es `/=`
  
  ```haskell
  ghci> 5 != 4
  # err
  ghci> 5 /= 4
  True
  ```

- **inflix** function: (funcion infija) por ejemplo `*`, es una funcion que toma
  dosn umeros y los multiplica, y la podemos poner entre ellos `5 * 4`. La
  mayoria de las funciones que no se usan con numeros son _prefix_ functions.

### Functions

A diferencia de los lenguajes imperativos, las funciones no se llaman con
parentesis y separando los parametros con comas, sino que separados con
espacios.

```haskell
-- f(1, 2, 3)
f 1 2 3
```

Function application (calling a function) has the highest precedence of them
all. Son equivalentes:

```haskell
ghci> succ 9 + max 5 4 + 1
16
ghci> (succ 9) + (max 5 4) + 1
16
```

Si una funcion toma dos parametros, tambien podemos usarla infija usando
backticks.

```haskell
> div 92 10
9
> 92 `div` 10
9
```

### If

```haskell
-- hace el doble solo si es menor a 100
doubleSmallNumber x =
    if x > 100
    then x
    else x*2
```

A diferencia de algunos lenguajes imperativos, el `else` es obligatorio.

Los ifs en haskell son *expresiones*. Una expresion es un cacho de codigo que
retorna un valor.

### Funciones sin parametros (definitions)

```haskell
conanO'Brien = "It's a-me, Conan O'Brien!"
```

(las funciones no pueden comenzar con mayusculas). Como no toma parametros,
decimos que es una *definition* o un *name*.

### Lists

In haskell lists are a **homogenous** data structure, they store several
elements of *the same type*.

Los `string` no son mas que `[Char]`. Y si `'a'` es un char, `"hola"` no es mas
que syntactic sugar para la lista `['h', 'o', 'l', 'a']`.

- `(++)`: Concatena dos listas
  
  ```haskell
  > [1, 2, 3] ++ [4, 5, 6]
  [1, 2, 3, 4, 5, 6]
  ```

- `(:)`: Cons operator. Concatena al principio de una lista.
  
  ```haskell
  > 'A':" CAT"
  "A CAT"
  ```

- `(!!)`: Para obtener el elemento i-esimo (comenzando de 0)

  ```haskell
  > [1, 2, 3, 4] !! 2
  3
  ```

- `head`: Dada una lista retorna la cabeza (primer elemento)
- `tail`: Dada una lista retorna la cola, todo menos la cabeza.
- `last`: Retorna el ultimo elemento.
- `init`: Retorna todo menos el ultimo.
- `length`: Retorna la longitud de la lista
- `null`: Chequea si esta vacia.
- `reverse`: Invierte una lista

#### Texas Ranges

Por ejemplo, para hacer una lista que contenga los naturales del 1 al 20, se
puede escribir `[1..20]`.

#### Infinite lists

Es mas elegante escribir `take 24 [13, 26..]` que `[13,26..24*13]` para obtener
los primeros 24 multiplos de 13.

Funciones que producen listas infinitas:

- `cycle`: Repite una lista y la convierte en infinita

  ```haskell
  ghci> take 10 (cycle [1,2,3])  
  [1,2,3,1,2,3,1,2,3,1]  
  ghci> take 12 (cycle "LOL ")  
  "LOL LOL LOL "
  ```

- `repeat` obtiene un elemento y produce una lista infinita de solo ese
  elemento. Es equivalente a hacer cycle de un solo elemento.

### Tuples

No son homogeneos, pueden contener tipos diferentes.

## Types and Typeclasses

- Haskell tiene un sistema de tipado **estatico**, con lo cual el tipo de cada
  expr se sabe en tiempo de compilacion.

- Tiene **inferencia de tipos**, si escribimos un numero, no hay que decirle a
  haskell que es un numero.

Para examinar los tipos en GHCi se puede usar el comando `:t`, que dada una
expresion dice su tipo.

### Polimorphic functions

Una funcion polimorfica es aquella que tiene *type variables*, es decir
variables que pueden tomar valores de cualquier tipo.

```haskell
ghci> :t head
head :: [a] -> a
```

### Typeclasses

Son como interfaces. Si un tipo es parte de una typeclas, es porque soporta e
implementa el comportamiento que esta describe.

```haskell
ghci> :t (==)  
(==) :: (Eq a) => a -> a -> Bool  
```

Todo lo que esta antes del `=>` es un **class constraint**

Hay una lista copada de typeclasses en el [LYAH](http://learnyouahaskell.com/types-and-typeclasses)

#### Type annotations

Es como un type assertion en go. Es para decir de forma explicita cual deberia
ser el tipo de una expresion.

```haskell
ghci> read "5" :: Int  
5  
ghci> read "5" :: Float  
5.0  
```

#### fromIntegral

Funcion util para pasar de Integrals (Int / Integer) a Num.

## 4. Syntax in Functions

### Pattern matching

Consiste en especificar *patrones* a los cuales algunos datos se deberian
ajustar, y luego chequear para ver si lo hace para deconstruir la data acorde a
esos patrones. Por ejemplo,

```haskell
lucky :: (Integral a) => a -> String  
lucky 7 = "LUCKY NUMBER SEVEN!"
lucky x = "Sorry, you're out of luck, pal!"
```

Cuando se llame a `lucky`, se van a chequear los patrones de arriba abajo y se
usa el primero que matche.

Tambien puede fallar,

```haskell
charName :: Char -> String  
charName 'a' = "Albert"  
charName 'b' = "Broseph"  
charName 'c' = "Cecil"  

ghci> charName 'a'  
"Albert"  
ghci> charName 'b'  
"Broseph"  
ghci> charName 'h'  
"*** Exception: tut.hs:(53,0)-(55,21): Non-exhaustive patterns in function charName  
```

Cuando uno hace patrones, deberia poner a lo ultimo un "catch-all" de forma tal
que no crashee cuando encuentra uno que no matchea.

#### Patterns

Son utiles para no repetir el patron para referirse al entero

```haskell
capital :: String -> String  
capital "" = "Empty string, whoops!"  
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]  
```

### Guards

Es como un if pero es mas readable.

```haskell
bmiTell :: (RealFloat a) => a -> String  
bmiTell bmi  
    | bmi <= 18.5 = "You're underweight, you emo, you!"  
    | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"  
    | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"  
    | otherwise   = "You're a whale, congratulations!"  
```

### `where`

Suponiendo que se quisiera calcular el bmi ahi

```haskell
bmiTell :: (RealFloat a) => a -> a -> String  
bmiTell weight height  
    | weight / height ^ 2 <= 18.5 = "You're underweight, you emo, you!"  
    | weight / height ^ 2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"  
    | weight / height ^ 2 <= 30.0 = "You're fat! Lose some weight, fatty!"  
    | otherwise                   = "You're a whale, congratulations!"  
```

Y se puede omitir la repeticion de calcularlo usando un `where` binding

```haskell
bmiTell :: (RealFloat a) => a -> a -> String  
bmiTell weight height  
    | bmi <= 18.5 = "You're underweight, you emo, you!"  
    | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"  
    | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"  
    | otherwise   = "You're a whale, congratulations!"  
    where bmi = weight / height ^ 2  
```

### `let`

Los *let bindings* son muy similares a los where. Se usan de la forma

```
let <bindings> in <expr>
```

Mas ejemplos en el lyah

### Case expressions

La sintaxis general es

```haskell
case expression of pattern -> result  
                   pattern -> result  
                   pattern -> result  
                   ...  
```

Y cuando uno define funciones por pattern matching no es mas que un syntactic
sugar para un case of.

```haskell
head' :: [a] -> a  
head' [] = error "No head for empty lists!"  
head' (x:_) = x

-- es syntactic sugar de
head' :: [a] -> a  
head' xs = case xs of [] -> error "No head for empty lists!"  
                      (x:_) -> x  
```

La ventaja que tienen es que, al ser una *expression*, se pueden usar en
cualquier lado. Por ejemplo:

```haskell
describeList :: [a] -> String
describeList xs = "The list is " ++ case xs of [] -> "empty."
                                               [x] -> "a singleton list."
                                               xs -> "a longer list."
```

Pero como se pueden usar como pattern matching, se podria haber definido

```haskell
describeList :: [a] -> String
describeList xs = "The list is " ++ what xs
    where what [] = "empty."
          what [x] = "a singleton list."
          what xs = "a longer list."
```

## 5. Recursion

Nada nuevo

## 6. Higher order

### Curried functions

Function in haskell oficially take only one parameter. All functions that accept
several parameters are **curried functions**.

For example the type of `max` is `max :: (Ord a) => a -> a -> a`. It could also
be written as `max :: (Ord a) => a -> (a -> a)`, which better reflects what
happens. `max` takes an `a` and returns *a function* that takes an `a` and
returns an `a`.

If we call a function with *too few* parameters, we get back a **partially
applied** function, one that takes as many parameters as we left out.

Inflix functions can also be partially applied using *sections*. To section an
inflix function surround it with parantheses and only supply a parameter on one
side, which returns a function that applies the parameter to the side which is
missing an operand.

```haskell
ghci> (10/) 100
0.1
ghci> (/10) 100
10.0
```

### flip

Flip takes a function and returns another that applies the parameters flipped

### `map` & `filter`

`map` takes a function and a list and applies that function to every element in
the list, producing a new list (with the same length).

```haskell
map :: (a -> b) -> [a] -> [b]  
map _ [] = []  
map f (x:xs) = f x : map f xs  
```

`filter` is a function that takes a predicate and a list, and returns the list
of elements that satisfy the predicate.

```haskell
filter :: (a -> Bool) -> [a] -> [a]  
filter _ [] = []  
filter p (x:xs)
    | p x       = x : filter p xs  
    | otherwise = filter p xs  
```

### `takeWhile`

`takeWhile` takes a predicate and a list and then goes from the beginning and
returns elements while the predicate holds true. Once an element for which it
doesn't hold is found, it stops.

### Lambdas

Lambdas are anonymous functions used because some functions are needed only
once.

### Folds

A fold takes a binary function, a starting value (the *accumulator*) and a list
to fold up. The binary function is called with the accumulator and the first (or
last) element and it produces a new accumulator. Then it is called again with
the following, and so on.

`foldl`, also called *left fold*, folds the list up from the left side. The
binary function is applied between the starting value and the head of the list.

```haskell
sum' :: (Num a) => [a] -> a
sum' xs = foldl (\acc x -> acc + x) 0 xs
-- sum' = foldl (+) 0 -- succint as fuck
```

The right fold, `foldr`, works in a similar way, only the accumulator eats up
the values from the right. Also the parameters on the binary function are the
other way around (`\x acc -> ...`)

We can implement map and filter with folds

```haskell
map' :: (a -> b) -> [a] -> [b]  
map' f = foldr (\x acc -> f x : acc) []
map' f = foldl (\acc x -> acc ++ [f x]) []
```

As `++` is more expensive than `:`, we usually use `foldr` instead of `foldl`
when building up new lists from a list.

**One big difference** is that right folds work on infinite lists, while left
ones don't.

Folds can be used to implement any function where you traverse a list once,
element by element, and then return something based on that.

### Scans

Los scans son como los folds, solo que devuelven los valores intermedios del
acumulador en una lista.

### `$` (function application)

The `$` function, also called *function application*, is defined like so

```haskell
($) :: (a -> b) -> a -> b
f $ x = f x
```

Function application with a space has a really high precedence, `$` has the
lowest precedence. Function application with a space is left-associative
(`f a b c` is the same as `(((f a) b) c)`), but with `$` is right associative
(`f (g (z x))` is equal to `f $ g $ z x`).

It is usually used to save parentheses.

```haskell
sum (map sqrt [1..130])
sum $ map sqrt [1..130]
```

When a `$` is encountered, the expression on its right is applied as the
parameter of the function to its left.

But it also means that function application can be treated just like another
function. So we can, for example, map it over a list of functions

```haskell
ghci> map ($ 3) [(4+), (10*), (^2), sqrt]
[7.0,30.0,9.0,1.7320508075688772]  
```

### `.` (Composition)

In mathematics, function composition is defined like $(f \circ g)(x) = f(g(x))$

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c  
f . g = \x -> f (g x)  
```

Function composition is also right-associative, so we can compose many at a
time. `f (g (z x))` is equivalent to `(f . g . z) x`.

```haskell
ghci> map (\xs -> negate (sum (tail xs))) [[1..5],[3..6],[1..7]]  
[-14,-15,-27]  
ghci> map (negate . sum . tail) [[1..5],[3..6],[1..7]]  
[-14,-15,-27]  
```