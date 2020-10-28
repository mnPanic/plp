# Inferencia

error 1: no se puede usar un sigma cualquiera

error 2:

 - El termino que se devuelve es uno con anotaciones de tipos, M, y U es sin
   anotaciones de tipo. U puede tener una lambda, lista vacia, etc. y debe ser
   anotada.
 - x no necesariamente esta en gamma, en cuyo caso hay que usar una variable
    fresca de tipo.
 - al gamma hay que sacarle la x si es que estaba, porque no esta mas libre. Si
   llega a haber alguna otra x, es otra variable que se llama igual, no es la
   misma.

app

- La recursion puede dar cualquier cosa, y despues hay que unificarlo. No
  necesariamente es tipo flecha.
- Al MGU le falta información de los contextos.
- En el resultado final hay que aplicar S a los contextos.

## inferencia

### 1

\f . \x. f (f x)    7
    |
\x. f (f x) 6

f (f x) 5

1 f         f x     4
        2 f     x   3


1. {f: t1} |> f: t1
2. {f: t2} |> f: t2
3. {x: t3} |> x: t3
4. mgu {t2 =.= t3 -> t4} = {t2 <- t3 -> t4}
   {f: t3 -> t4, x: t3} |> f x : t4
5. mgu {t1 =.= t3 -> t4, t1 =.= t4 -> t5}

    t1 <- t3 -> t4 . mgu {t3 -> t4 = t4 -> t5}
    t1 <- t3 -> t4 . mgu {t3 =.= t4, t4 =.= t5}
    t1 <- t3 -> t4 . t3 <- t4 . mgu {t4 =.= t5}
    t1 <- t3 -> t4 . t3 <- t4 . t4 <- t5
    ------------------------------------
    t1 <- t5 -> t5, t3 <- t5, t4 <- t5

   = {t1 <- t5 -> t5, t3 <- t5, t4 <- t5}

   {f: t5 -> t5, x: t5} |> f (f x) : t5

7. {f: t5 -> t5} |> \x: t5. f (f x) : t5 -> t5

8. {} |> \f: t5 -> t5 . \x: t5. f (f x) : (t5 -> t5) -> t5 -> t5
   (tiene que ir con paretensis)

### 2

   x (\x. x)    4
   /    \
1 x    \x. x   3
         |
         x      2

1. {x: t1} |> x: t1
2. {x: t2} |> x: t2
3. {} |> \x: t2. x : t2 -> t2       en las abs se agrega una flecha
4. mgu {t1 =.= (t2 -> t2) -> t3}
    de los contextos no hay que decir nada porque ya hay uno que es vacio
    = {(t2 -> t2) -> t3 / t1}

  {x: (t2 -> t2) -> t3} |> x (\x: t2. x) : t3

### 3

   \x. x y x    6
      |
     x y x  5
    /    \
4 x y    x 3
   |  \
  1 x   y 2

1. {x: t1} |> x: t1
2. {y: t2} |> x: t2
3. {x: t3} |> x: t3
4. mgu {t1 =.= t2 -> t4}
   = {t2 -> t4 / t1}    (no hay otra opcion)

   {x: t2 -> t4, y: t2} |> x y : t4

5. mgu {t4 =.= t3 -> t5, t3 =.= t2 -> t4}   occur check: error

no tipa

## Extensiones

W(foldr map)

mgu { (a -> b -> b) -> b -> [a] -> b =.= ( (c -> d) -> [c] -> [d] ) -> t1}
(1. descomp)
mgu {
    (a -> b -> b) =.= (c -> d) -> [c] -> [d],
    b -> [a] -> b =.= t1
}

(swap)
mgu {
    (a -> b -> b) =.= (c -> d) -> [c] -> [d],
    t1 =.= b -> [a] -> b
}
b -> [a] -> b / t1 .
mgu {
    a -> b -> b =.= (c -> d) -> [c] -> [d],
}
(4. descomp)
b -> [a] -> b / t1 .
mgu {
    a =.= (c -> d),
    b -> b =.= [c] -> [d],
}
b -> [a] -> b / t1 . c->d/a .
mgu {
    b =.= [c],
    b =.= [d]
}
elim
b -> [a] -> b / t1 . c->d/a . [c]/b .
mgu {[c] =.= [d]}
descomp
b -> [a] -> b / t1 . c->d/a . [c]/b .
mgu {c =.= d}
elim
b -> [a] -> b / t1 . c->d/a . [c]/b . d / c
= {d/c, [d]/b, d->d / a, [d] -> [d->d] -> [d] / t1}

W(foldr map) = {} |> foldr_{d->d, [d]} map_{d d} : [d] -> [d->d] -> [d]

### definir W

{{en las diapos falta el llamado recursivo}}

```
W(\<x, y> . U) = \Gamma - {x, y} |> \ <x, y>: <t_x, t_y> . M : <t_x, t_y> -> tau
tenemos un termino que es un subtermino, entonces tenemos que 

W(U) = \Gamma |> M : tau

t_x = {alfa si x:alfa \in \Gamma | var fresca sino}
t_y = {beta si y:beta \in \Gamma | var fresca sino}
```

### listas - case of

W (Case U of [] ---> V; h :: t --> W) =
    S Gamma_1 U S Gamma_2 U S Gamma_3' |> Case M of [] --> N; h :: t --> O : S sigma

donde

W(U) = \Gamma_1 |> M : phi
W(V) = \Gamma_2 |> N : rho
W(W) = \Gamma_3 |> O : sigma

\Gamma_3' = \Gamma_3 - {h, t}

-- no necesariamente es una lista con tipo var fresca,
-- si ya tenia un tipo va a ser bool, no necesariamente var fresca.
tau_t = {beta si t:beta \in Gamma_3 | var fresca sino.}
tau_h = {alpha si h:alpha \in Gamma_3 | var fresca sino.}

S = mgu
    { rho =.= sigma, phi =.= tau_t, [tau_h] =.= tau_t } U
    {a_1 =.= a_2 | y : a_1 \in \Gamma_i, y:a_2 \in \Gamma_i, i, j \in {1, 2, 3'}}

### switch

W (switch U {case V_1 ... V_k default: V})
    = U_{i=0}^{k+1} S Gamma_i |> 
        S (switch M_0 {Case M_1 ... M_k default: M_{k+1}}) : S sigma_1

donde

\forall i, j \in {1..k}, i != j => n_i != n_j

W(U) = \Gamma_0 |> M_0 : sigma_0
W(V_i) = \Gamma_i |> M_i : sigma_i, i \in {1..k}
W(U) = \Gamma_0 |> M_0 : sigma_0
W(V) = \Gamma_{k+1} |> M_{k+1} : sigma_{k+1}

mgu
    { sigma_i =.= sigma_j | i, j \in {1..k+1} } U
    { sigma_0 =.= Nat } U
    { a_1 =.= a_2 | y : a_1 \in \Gamma_i, y:a_2 \in \Gamma_i, i, j \in {0..k+1} }

Como no se esta uniendo nda a ningun contexto no se esta ligando ninguna variable.