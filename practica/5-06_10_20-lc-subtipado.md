# LC - Practica - Subtipado

## 3.7

```text
\x: Bool.(\y: Nat.suc(y)) x
```

Antes no tiparia porque no se puede interpretar Bool como nat.

Probar que tipa

ej

```text
( \x: Bool.(\y: Nat.suc(y)) x ) true
( \y: Nat.suc(y) ) true
suc(true)
```

Bool <: Nat <: Int <: Float

Hay que probar `Γ |> \x: Bool.(\y: Nat.suc(y)) x : sigma` buscando Γ y sigma.
Propongo sigma Bool -> Nat, gamma {}

```text
                                              OK
                                              ---------------------
                                              x: Bool \in {x: Bool}
                                              --------------------- (T-Var)
y : Nat     => sigma = Nat                    {x: Bool} |> x : Bool, Bool <: Nat
------------------------- (T-Succ)            --------------------- (T-Sub)
{x: Bool, y: sigma} |> suc(y) : Nat           {x: Bool} |> x : Nat
------------------------- (T-Abs)             ---------------------
{x: Bool} |> \y: Nat.suc(y) : sigma -> Nat    {x: Bool} |> x : sigma
-------------------------------------------------------------------- (T-App)
Γ, x: Bool |> (\y: Nat.suc(y)) x : Nat
---------------------------- (T-Abs)
{} |> \x: Bool.(\y: Nat.suc(y)) x : Bool -> Nat

```

## Bool

Imaginen que queremos dies;ar un leng en el cual los bool pueden ser
reemplazados por cualquier numero, en el cual 0 es false y el resto true.

### a


Definir la regla de subtipado necesaria para soportar esta modificacion

```
---- (S-FloatBool)
Float <: Bool
```

### b

En caso de ser verdadero, demostrar el siguiente juicio de tipado

```
ok
------- (T-Var)
Γ |> x : Bool    Bool <: Float <: Nat
------- (T-Sub)
Γ |> x : Nat
------------------------- (T-Succ)
Γ |> succ(x): Nat  Float <: Bool <: Nat
-------------------------- (T-Sub)
Γ |> succ(x) : Bool    Γ |> 0 : Float   Γ |> succ(0) : Float            ok
----------------------------------------- (T-If)                        ---------------
Γ = {x: Bool} |> if suc(x) then 0 else suc(0) : Float                   -1: Int     Bool <: Float <: Int
--------------------------------------- (T-Abs)                         --------------- (T-Sub)
{} |> \x: Bool. if suc(x) then 0 else suc(0) : Bool -> Float            {} |> -1 : Bool
--------------------------------------------------------------------------------------- (T-App)
{} |> (\x: Bool. if suc(x) then 0 else suc(0)) (-1) : Float
```

solucion de pablo

```
ok                                  (S-NatInt)  (S-IntFloat)
-------------------- (T-Var)        ----------  ------------
{x: Bool} |> x: Bool  Bool <: Nat   Nat <: Int  Int <: Float
------------------- (T-Sub)         ------------ (T-Trans)
{x: Bool} |> x: Nat                 Nat <: Float            Float <: Bool
------------ (T-Succ)               ----------------------------- (T-Trans)
succ(x): Nat                        Nat <: Bool                                     (S-IntFloat)    (S-FloatBool)
------------------ (T-Sub)      (facil)          (facil)                            -------------   --------------
Γ |> succ(x): Bool              Γ |> 0: Nat      Γ |> suc(0): Nat                   Int <: Float    Float <: Bool
----------------------------------------------------------------- (T-If)            --------------------- (T-Trans)
Γ = {x: Bool} |> IF : Nat                                                           -1: Int   Int <: Bool           (S-NatInt)  (S-IntFloat)
------------------------- (T-Abs)                                                   -------------- (T-Sub)          ----------- ------------
{} |> LAMBDA: Bool -> Nat                                                           {} |> -1: Bool                  Nat <: Int  Int <: Float
------------------------------------------------------------------------------------------ (T-App)                  ------------------------ (T-Trans)
{} |> EXPR: Nat                                                                                                     Nat <: Float
-------------------------------------------------------------------------------------------------------------------------------------------- (T-Sub)
{} |> (\x: Bool. if suc(x) then 0 else suc(0)) (-1) : Float
```

## 3.14

Siguiendo la tecnica combinatoria,

??
---------------------------------- (S-Comp)
\x: Comp(lf, lo) <: Comp(lf', lo')


1. lf <: lf'       lo <: lo'
2. lf :> lf'       lo <: lo'
3. lf <: lf'       lo :> lo'
4. lf :> lf'       lo :> lo'

p(c: comp(c++, obj)) {
    var p : Prog_c++
    res = compilar(c, p)
    return res
}

hip

lf :> lf'       lo <: lo'
---

si fuera cierta, le puedo pasar Comp(c, lo)
