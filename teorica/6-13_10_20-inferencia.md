# Inferencia

No es lo mismo chequeo de tipos que inferencia de tipos.

## Sustitucion

Formalmente la sustitucion es una función total, pero nosotros solo queremos
reemplazar algunas. Para eso, hacemos que en el resto de los casos se comporte como la identidad.

S x = z  si x = y
      x  c.c

soporte: conj de variables del dominio que voy a efectivamente sustituir. La func identidad tiene soporte vacio, es la sustitucion identidad.

## W

Algoritmo de inferencia, toma U un termino **sin anotaciones**

Devuelve un juicio de tipado

- Corrección: W(U) = \Gamma |> M  : sigma implica
  - ERASE(M) = U
  - \Gamma |> M : sigma es derivable
- Completitud: Si \Gamma |> M : sigma es derivable y ERASE(M) = U, entonces
  - W(U) tiene exito y
  - produce un juicio \Gamma' |> M' : sigma' tal que \Gamma |> M : sigma es instancia del mismo (se dice que W(.) computa un **tipo principal**)
    _tiene que devolver el mas general_
    Ejemplo:

    U = \x.x
    M = \x:Nat.x
    Le vamos a pedir que nos devuelva
    M = \x:s.x

- W(0) =def= vacio > 0 : Nat
- W(true) = vacio > true : Bool
- W(false) = vacio > false : Bool
- W(x) = {x: s} > x
- W(succ(u)) = quiero ver si existe S tq S tau = Nat. Si se puede instanciar a nat.

**problema de unificacion**: Si puedo encontrar sustituciones tal que sintacticamente sean iguales.

```
x: sigma \in Gamma
----
Gamma > x: sigma
```