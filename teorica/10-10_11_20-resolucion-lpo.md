# Logica de primer orden

## Repaso

El lenguaje está determinado por

- constantes: c, c_0, ...
- funciones: f, f_0, ..., que tienen asociada una aridad > 0 (las constantes se
podrian tomar como funciones de aridad 0 pero aca nosotros no)
- simbolos de predicados, p, p_0, ..., que tienen también aridad >= 0. Y los de
  aridad 0 son las proposiciones de logica proposicional.

Uno asume un conjunto de variables x, x_0

Dos niveles

### L-terminos 

t ::= x | c | f(t_1, ..., t_n) si la aridad de f es n

Ejemplo de lenguaje para representar los naturales

- 0 constante
- s sucesor de aridad 1.
- Los l-terminos son las construcciones que permiten hablar de elementos del
  dominio. 

    t = {0, s(0), s(s(0)), x, y, s(x)}

Ejemplo de lenguaje para arboles binarios

nil
arb -> aridad 3

t = {..., nil, arb(0, nil, nil), arb(s(0), arb(0, nil, nil), nil)}

intuitivamente, sintaxis que usamos para representar datos

### Formulas

intuitivamente, para representar relaciones entre los datos (l-terminos)

A o F

atomicas: simples, lo que antes eran variables proposicionales, aca un poco mas
complejo.

A, B ::= p | p_0(t_1, ..., t_n) | ~A | A /\ B | ... (implicacion, sii,
disyuncion) | forall x.A | exists x.A

si p tiene aridad 0

luego por ej.

    menor -> aridad 2

    menor(0, s(0))

Dentro de un simbolo de predicado solo pueden aparecer l-terminos, un parametro
no puede ser otro predicado

    menor(0, menor(0, s(0))

## Resolución

Vamos a probar que la negación es insatisfactible. Para eso usamos resolución:
aplicar la regla de resolucion hasta que aparece la clausula vacia (es
insatisfactible) y asi concluyo que la forma negada de la original es
insatisfactible, y luego que la original es valida.

Esta definida para una forma normal, no para toda la sintaxis de la LP. (forma
normal conjuntiva). Representamos a todas como una conjuncion de una disyuncion
de literales.

Tratamos de hacer lo mismo para LPO, encontrar una forma normal que se pueda
escribir en terminos de conjuntos. El problema son los cuantificadores.

### Forma clausal

Es una forma normal conjuntiva en notacion de conjuntos

1. eliminar => y <=>
2. forma normal negada
3. forma normal prenexa
4. forma normal de Skolem
5. Distribuir cuantificadores universales

#### Forma normal negada

Intuitivamente:
- no puede haber algo negado dos veces. ~(~A)
- solo se puede negar las atomicas

Se puede aplicar demorgan para pasar a forma normal negada con todas las
formulas.
(en diapo)

#### Forma normal prenexa

No es totalmente necesario pero hace la vida mas simple.

Todos los cuantificadores al inicio de la formula.

rectificado: que todas las variables distintas se llamen distinto. Que todas las
variables ligadas se llamen diferentes.

#### Forma normal de Skolem

Queremos eliminar cuantificadores existenciales. Vamos a perder la equivalencia
logica pero pretendemos preservar la relación de satisfactibilidad.

exists x. A
exists x.menor(x, 0)
menor(menoracero, 0)

!!importante para el final si rendimos con herni

Preserva la satisfactibilidad pero no la validez.

##### Skolemización

Ejemplo

forall x. exists y. menor (x, y)
forall x. menor(x, mayor_a_x)       # cambie mucho la formula, estoy tomando uno

para esos casos elegimos una funcion
forall x. menor(x, mayor_a(x))

a veces se puede usar directo constante
exists y. forall x. menor(x, y)
forall x. menor(x, mayor_a_x)