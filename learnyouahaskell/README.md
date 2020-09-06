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