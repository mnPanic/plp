# Prolog

Clase de dani de 1c2020

Prolog

- Lenguaje de programación lógica
- Se escriben en un subconj de la LPO
- Es declarativo
- Computo basado en clausulas de Horn y resolucion SLD
- Mundo cerrado: solo se puede suponer lo que se declaro, todo lo demas se
  supone como falso
- Tiene un solo tipo: terminos. Hay formas de escribir cosas parecidas a
  estructuras de datos algebraicas a traves de ellos.

Se recomienda usar SWI-Prolog

## Bases de conocimiento

Describe el dominio del problema, formados por **hechos** y **reglas** de
inferencia.

Y podemos hacer consultas

```prolog
coronavirus(murcielago).

comio(carlos, ensalada).
comio(alicia, murcielago).

tomaron_mate(sandra, alicia).
tomaron_mate(alberto, carlos).

infectado(X) :- comio(X, Y), coronavirus(Y).
infectado(X) :- tomaron_mate(X, Y), infectado(Y).
```

Los predicados establecen relaciones entre sus argumentos.

Ejemplos de consulta:

- `infectado(carlos).`: instanciar el argumento X en carlos
- `infectado(X)`: no devuelve, muestra las diferentes instanciaciones de X.

    `;` para pedir mas soluciones

    `enter` para terminar.

## Sintaxis

- **variables**: `X, Persona, _var`. valores que no fueron ligados.
  Si la unificas con un valor (ligar), no la podes cambiar.

- **Numeros**: `10, 15.6`.
- **Atomos**: `coronavirus, 'hola mundo'`. Nombres, texto, constantes, nombres
  de terminos compuestos, empiezan con minuscula o estan entre comillas simples.

- **Términos compuestos** o **estructura**: `tomaron_mate(sandra, alicia)`.

  Un nombre (atomo) seguido de n argumentos, cada uno de los cuales es un
  termino. Decimos que n es la *aridad* del termino compuesto.

  `tomaron_mate` tiene aridad 2 y sus argumentos son `sandra` y `alicia`.

- **Functor**: `coronavirus/1`, `tomaron_mate/2`: Nombre de un termino compuesto
  junto con su aridad.

- **Termino**: variable, numero, atomo o termino compuesto.
- **Clausula**: una linea del programa, que termina con punto.
  - **Hechos**: `coronavirus(murcielago).`
  - **Regla**: `cabeza :- cuerpo.`. `:-` se puede pensar como un $\Leftarrow$ y
    las comas como $\wedge$.
    Ej. `infectado(X) :- comio(X, Y), coronavirus(Y).`
- **Predicado**: coleccion de clausulas sobre el mismo functor.
- **Objetivo (goal)**: Consulta hecha al motor de prolog. Conjunción de atomos o
  terminos compuestos. Por ej: `comio(carlos, X), coronavirus(X).`

## Sustitución y unificación

Term el conj de todos los posibles terminos. Una **sustitucion** es una func s:
variables -> Term. Y la podemos extender a Term -> Term de la siguiente manera

- `z(c) = c`: si hay una constante no la modifico
- `z(f(t1, ..., tn)) = f(z(t1), ..., z(tn))`: Si es un termino compuesto aplica
  la sust a cada uno de los argumentos.

Por ej. `z = {X <- a, Y <- Z}` (Z es una var tambien)

```text
s(b(X, Y, c)) = b(s(X), s(Y), s(c))
              = b(a, Z, c)
```

Dado un conjunto de ecuaciones de unificacion `S = { s_1 =.= t_1, ..., s_n =.= t_n}`
con s_i, t_i terminos. Queremos saber si existe una sustitucion `z` tal que
`z(s_1) = s(t_1)` para todo `i`. si existe, `z` es el **unificador** de S.

> Ejemplo: f(X) =.= f(Y) se puede resolver con la sust `z = {X <-, Y <- 0}` ya
> que quedaria f(0) = f(0), pero claramente parece mas general las sust de la
> forma `z' = {X <- Y}`. (MGU is back BABY)

Estamos interesados en encontrar el **unificador mas general (MGU)** de S.

### Resolución

Dado un programa lógico P y un goal G_1, ..., G_n (no necesariamente es solo un
termino sino que puede ser una conjuncion). Se quiere ver si el goal es
consecuencia logica de P. Se usa la regla de resolución

$$\frac{
    G_1, \dots, \bm{G_i}, \dots G_n \quad H \ \text{:-}\ A_1, \dots, A_k \quad \sigma
    \ \text{es el MGU de } G_i \ \text{y}\ H
}{
    \sigma(G_1, \dots, G_{i-1}, \bm{A_1, \dots, A_k}, G_{i+1}, \dots, G_n)
}$$

Queremos que algun goal G_i unifieuqe con alguna regla H, con algun unificador
$\sigma$. Se reemplaza en el lugar donde estaba G_i el cuerpo de la regla, y a
todo le aplicamos la sustitucon (el MGU). La conclusion de la regla de
resolucion es el nuevo goal a resolver.

Prolog resuelve empezando de izquierda a derecha (G_1) y recorre el arbol de
resolución con DFS.
Para cada G_i, recorre el programa de arriba hacia abajo cual es la primera que
unifica con mi goal, buscando unificar G_i con la cabeza de una cláusula.

**Por lo tanto, el orden de las cláusulas y sus literales en el programa
influyen en el resultado.**

### Ejercicio

Motrar el arbol de ejecucion de la siguiente consulta para el programa dado

```prolog
gato(garfield).
tieneMascota(john, odie).
tieneMascota(john, garfield).
amaALosGatos(X) :- tieneMascota(X, Y), gato(Y).
```

Consulta: `amaALosGatos(Z).`

```text
          amaALosGatos(Z).
                | Z <- X
    tieneMascota(X, Y), gato(Y).
        |       | X <- john, Y <- odie
        |   gato(odie).
        |       |
        |     false. % no existe unificacion que haga que sea verdadero.
        |     % se llega a una clausula que no puede unificar mas,
        |     % hacemos backtracking.
        |
        | X <- john, Y <- garfield
        |
    gato(garfield).
        |
      true. % unifica con el primer hecho, entonces unifica con una clausula vacia.

=> Z = john.
```

Si intercambiásemos el orden del predicado del functor `tieneMascota`, nunca se
tomaría la rama de odie porque primero se tomaría la de garfield.
Como prolog sabe que le queda otra rama, uno le puede seguir pidiendo.

Devolvería

```text
=> Z = john;
   false.
```

Al evaluar un goal, los resultados posibles son:

- `true`: La resoluicon termino en una clausula vacia
- `false`: La resolucion termino en una clausula que nbo unifica con ninguna
  regla del programa.
- El proceso de aplicacion de la regla de resolución no termina.

La consulta **no devuelve** john, sino que muestra las unificaciones que se
hicieron.

## Reversibilidad

Un predicado define una relación entre elementos, no hay parámetros de entrada y
salida. Pero conceptualmente, podrían cumplir ambos roles dependiendo de como se
consulte.

Un predicado podría estar implementado asumiendo que ciertas variables ya están
instanciadas.

### Patrones de instanciación

El modo de instanciación esperado por un predicado se comunica a través de
comentarios en el código.

```prolog
% pow(+B, +E, -P)
pow(...) :- ...
```

- `+X`: Debe estar instanciado
- `-X`: **No** debe estar instanciado
- `?X`: Puede o no estar instanciado.

> Mirandolo con cariño, como si fuera un programa de imperativo o funcional, a
> pow le entran como argumentos B y E y devuelve P. Pero en realidad no
> significa eso.

Si hago una consulta con argumentos instanciados de otra manera, el resultado
puede no ser el esperado.

## Aritmética

El motor de operaciones aritméticas de Prolog es **independiente del motor
lógico** (es extra-lógico)

Expresión aritmética:

- Un numero
- Una variable ya instanciada en una expresion aritmetica (X = 2, X es una expr
  aritmetica)
- `E1+E2, E1-E2, ...` etc. siendo E1 y E2 expresiones aritméticas.

Operadores aritméticos

- Comparadores: `E1 < E2, E1 =< E2, E1 =:= E2, E1 =\= E2` evalua ambas
  expresiones aritmeticas y realiza la comparación indicada.

  `=:=` es igualdad de **expresiones aritmeticas**

- `X is E`: tiene exito sii X **unifica** con el resultado de evaluar la
  expresión aritmética E.

### Operadores no aritméticos

- `X = Y` tiene exito sii X **unifica** con Y. (sin evaluar Y)
- `X \= Y`: X no unifica con Y. Para esto ambos tienen que estar instanciados.

## Listas

Sintaxis

- `[]`
- `[X, Y, ..., Z | L]`

Ejemplos

- `[1, 2], [1, 2 | []], [1 | [2]], [1 | [2 | []]]`
- `[1, cero, 'hola mundo', [3, 5]]`: "adentro de la lista puedo tener cualquier
  verdura" - dani

