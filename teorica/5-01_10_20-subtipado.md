# Subtipado

## Recursion

Definimos un programa recursivo como un punto fijo de una determinada funcion.

### Fix

Introducimos `fix`, que es un operador de punto fijo.

fix M : Nat -> Nat donde M :: (Nat -> Nat) -> (Nat -> Nat)

fix (\f : Nat -> Nat. M) -> M{ f <- (\f: Nat -> Nat.M)}

fix M ->
    \x : Nat . if iszero(x) then 1 else x * ( (fix M) (pred(x)) )

En haskell,

Punto fijo = un valor que si le sigo aplicando f no cambia

fix f = f ( fix f )

Seria

    f ( f ( f ...))

Uno toma como 1er parametro de f a lo mismo que intento definir de forma
recursiva.

Y por que no defino la semantica como

    fix V -> V (fix V)

El problema esta con la evaluacion, sigue evaluando infinitamente. *call by
value*. Cuando tengo una aplicacion tengo que evaluar completamente el
argumento.

Intuicion: Si quiero definir factorial en terminos del fix tengo que definir una
func mas generica que tome como 1er arg un parametro que representa a la funcion
que estoy definiendo.

fact x = \f:nat->nat. \x:nat. if iszero(x) then 1 else x f(pred(x))

### Ejemplos

Podemos definir funciones parciales

    fix (\x: Nat.succ x) : Nat

Intentando de evaluar

    fix (\x: Nat.succ x)
    -> succ( fix (\x: Nat.succ x) )
    -> succ( succ (fix (\x: Nat.succ x) ) )
    ...

Infinitos succs.

Con esto cambiamos las propiedades del calculo, sigue habiendo progreso y
determinismo pero pierdo la terminacion. Computaciones de terminos bien tipados
y cerrados pueden no terminar.

--

Sea M el termino
    \s: Nat -> Nat -> Nat
      \x: Nat.
        \y: Nat.
          if iszero(x) then y else succ(s pred(x)y)
en
    let suma = fix M in suma 2 3

### letrec

letrec f : sigma -> sigma = \x : sigma. M in N

let f = fix ( \f : )

## Subtipado

Definimos un lenguaje y nos quedamos con un subconj de esos programas (los que
tipan) y esos son los que nos interesan. Ahi descartamos programas que no son
necesariamente malos.

    if true then 1 else true

Subtipado es una tecnica usada en distintos contextos para dar mas flexibilidad
al sistema de tipos. Es una manera estandar de extender de forma sistematica el
conj de terminos bien tipados.

Por ej

    (\x: {a: Nat}. x.a) {a = 1, b = 2}

Quiere proyectar la etiqueta `a` del registro que tome.

Ahi queremos ver que uno es un *subtipo* o caso particular de otro. Se escribe
con

$$\sigma <: \tau$$

*sigma es un subtipo de tau*

Puedo usar cualquier expr de tipo sigma en cualquier lugar donde se espera algo
de tipo tau.

Se refleja con una nueva regla llamada **subsumption**.

Con esto se pierde la **unicidad**, en el mismo contexto se puede tipar de dos
formas.

### Subtipado de tipos base

- Nat <: Float
- Int <: Float
- Bool <: Nat

### Subtipado como preorden

Es reflexiva y transitiva, sin antisimetria y simetria

- reflexiva: $\sigma <: \sigma$
- transitiva: $\sigma <: \tau, \tau <: \rho -> \sigma <: \rho$

### Subtipado de registros a lo ancho

- `{a:Nat, b:Bool} <: {a:Nat, c:Bool}`: No
- `{a: Nat, c: Bool} <: {a: Nat}`: Si

Nota

- {} es como un singleton, unit, ya que $\sigma <: {}$ para todo tipo de
  registro $\sigma$

### En profundidad

Para poder tener tipos diferentes

### Subtipado de funciones

Los subtipos se pueden ver como una relacion de inclusion

    {a:Nat, b: Bool} <: {a:Nat}

la func que me dan se tiene que poder calcular al menos sobre todos los
elementos de sigma'. sigma tiene que ser un conjunto mas grande.

```
sigma' <: sigma
-----------------------------
sigma -> tau <: sigma' -> tau
```

### Subtipado de referencias

Si vas a escribir, el tipo de la referencia donde vas a escribir tiene que ser
igual o mas alto (menos informativo)

> Si voy a escribir en un Float, puedo escribir un Int.

Si vas a leer, el tipo de la referencia a leer tiene que ser igual o mas bajo
(mas informativo)

> Si voy a leer un Int, puedo leer un Float.
