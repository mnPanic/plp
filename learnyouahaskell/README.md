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

## Syntax in Functions