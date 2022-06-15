## Funcional

#### Definir map usando foldl y foldr. Qué pasa con foldl y foldr con listas infinitas?
foldl :: (b -> a -> b) -> b -> [a] -> b
foldr :: (a -> b -> b) -> b -> [a] -> b

map :: (a -> b) -> [a] -> [b]
map f = foldr (\x l -> ((f x) : l)) []

map f = foldl (\l x -> (l ++ [f x])) []

Foldr funciona con listas infinitas (por ejemplo si usamos take k de un map a una lista infinita) y foldl no, se cuelga. 

foldr _ z [] = z
foldr f z (x:xs) = f x (foldr f z xs)

foldl _ z [] = z
foldl f z (x:xs) = foldl f (f z x) xs = foldl f (f (f z x) x2) xs2
foldl es asociativo a izquierda: f (f (f z x1) x2) x3
foldr es asociativo a derecha: f x1 (f x2 (f x3 z))

foldr es aplicar f sobre el primer elemento y el resultado recursivo de tail. La primera f que calcula es entre el último elemento y el caso base.
foldl es aplicar f sobre el último elemento y el resultado recursivo de body. La primera f que calcula es entre el primer elemento y el caso base.

Ejemplos:
No es lo mismo foldr (-) 0 l que foldl (-) 0 r.
foldl (\r x -> r ++ [x]) es la identidad
foldr (:) es la identidad

#### Definir fold sobre árbol binario. Usar ese fold para definir:
truncar10:: ArbolBinario Int -> ArbolBinario Int
Ejemplos:

truncar10 (Hoja n) = Hoja n
truncar10 (Bin 1 (Hoja 2) (Hoja 5)) = Hoja (1+2+5)
truncar10 (Bin 4 (Hoja 5) (Hoja 2)) = (Bin 4 (Hoja 5) (Hoja 2))

Es decir, agrupa recursivamente nodos que con sus hijos suman menos de 10

Solución:
data ArbolBinario a = Hoja a | Nodo (ArbolBinario a) a (ArbolBinario a)

foldA :: (a -> b) -> (b -> a -> b -> b) -> ArbolBinario a -> b
foldA f _ (Hoja x) = f x
foldA f g (Nodo l x r) = g (foldA f g l) x (foldA f g r)
 
sumA = foldA (\(Hoja x) -> x) (\l x r -> l+x+r)

truncar10 = foldA id (\l x r -> if sumA (Nodo l x r) <= 10 then Hoja (sumA (Nodo l x r)) else (Nodo l x r)

#### Se puede definir un árbol binario infinito? Qué pasaría cuando le aplicas truncar10
t = (Nodo t 5 (Hoja 1)). define un árbol infinito.
Supongo que la pregunta sobre truncar10 apunta a ver si funciona como foldl o como foldr. Con cómo resolví el ejercicio anterior, truncar10 de un árbol infinito no se puede hacer en ningún caso porque necesitás sí o sí hacer la suma de todos los elementos. Viendo esto, tal vez la idea en el ejercicio anterior era que truncar no mirara la suma total sino solo entre el padre y sus hijos inmediatos, pero en este caso no estoy seguro de cómo sería el agrupamiento.
En cualquier caso, diría que el funcionamiento de foldA es parecido al de foldr porque lo de más afuera es el llamado a g. Por ejemplo, si llamamos a foldA (\x -> 0) (\l x r -> 0) t, no se cuelga. En cambio si llamamos a foldl (\r x -> 0) [1..], se cuelga.

#### Explicar uncurry y definirla
Uncurry es una operación sobre funciones, es la operación opuesta a curry. Lo que hace uncurry es tomar a una función currificada y descurrificarla. La función currificada dado un elemento de tipo a devuelve una función que recibe un elemento de tipo b y devuelve un elemento de tipo c. En cambio, la función descurrificada recibe una tupla con un elemento de tipo a y otro de tipo b devuelve un elemento de tipo c.
Se define de la siguiente forma:

uncurry :: (a -> b -> c) -> ((a, b) -> c)
uncurry f (x, y) = f x y

#### Explicar el concepto de curry, por qué la querrías usar?
Curry es una función que, dada una función con dominio en tuplas, devuelve su versión currificada.

curry :: ((a, b) -> c) -> (a -> b -> c)
curry f x y = f (x, y)

Es útil usar funciones currificadas porque permiten aplicación parcial. Esto es, evaluar a una función en solo uno de sus argumentos y obtener una función que tiene ese argumento fijo. Esto nos da un montón de flexibilidad. Por ejemplo, map (*2) es la función que duplica todos los elementos de una lista. Acá estamos usando que tanto el producto como map están currificadas.

#### Se puede definir fold en función de map o filter?
map :: (a -> b) -> [a] -> [b]
filter :: (a -> Bool) -> [a] -> [a]
foldr :: (a -> b -> b) -> b -> [a] -> b

No se puede, en particular porque map y filter devuelven listas y foldr devuelve un tipo cualquiera.

#### Dado el tipo data D a = C (D a) (D a), cómo sería el fold? A qué evalúa foldD C miD?
foldD :: (b -> b -> b) -> (D a) -> b
foldD f (C x y) = f (foldD f x) (foldD f y)

C :: (D a) -> (D a) -> (D a)

foldD C (C x y) --> C (foldD C x) (foldD C y) --> C (C (foldD C x1) (foldD C x2)) (C (foldD C y1) (foldD C y2))

Es la función identidad. El tema es que miD es necesariamente infinito, con lo cual para ver esto habría que aplicarle alguna función que tome un subconjunto finito.

#### foldl f g =?= foldr f g
No, primero porque el tipo de foldl y el tipo de foldr no son el mismo:
foldl :: (b -> a -> b) -> ...
foldr :: (a -> b -> b) -> ...
Si nos olvidamos de eso, en el caso finito diría que sí, si lo que nos estamos preguntando es si la igualdad entre los resultados da true. En el caso infinito diría que no porque, como el orden de las operaciones es distinto, hay casos en los que foldr termina y foldl no. Ej: foldl (\r x -> 0) [1..] se cuelga y foldr no.

#### Con foldr puedo escribir cualquier función recursiva sobre listas?

No, por ejemplo dropWhile no se puede hacer con foldr sin cambiar el tipo de lo que devuelve. 
dropWhile :: (a -> Bool) -> [a] -> [a]
Para hacer dropWhile tu finción recursiva tiene que conocer toda la estructura que le queda por recorrer (para el caso en el que tiene que dejar de filtrar). Si lo hacemos con foldr, tenemos usar un resultado tipo tupla e ir guardando esta estructura ahí. Con recr dropWhile se puede hacer en forma directa.
recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr _ z [] = z
recr f z (x:xs) = f x xs (recr f z xs)

Recursión global permite escribir más funciones que recr. Podés acceder a la estructura que queda por resolver y a todos los resultados para las subestructuras. Es más general que recr, que es recursión primitiva. Por ejemplo, tomar los elementos en las posiciones pares de la lista requiere recursión global, es tomar el primer elemento y la solución para el tail del tail. 

#### Si definieras elem :: a -> [a] -> Bool con fix, como un fix M, que tipo tiene M ?

Regla de tipado de fix:
Si G |> M : s -> s, entonces G |> fix M : s.
Entonces el tipo de M debería ser una función de s -> s. La pregunta es quién es s.
Lo usual para definir funciones recursivas con fix es que s sea el tipo de la función que queremos definir. Entonces s = a -> [a] -> Bool. Más aún, la definición sería algo así:

elem = fix (\f -> g f)
	where g f e [] = false
	            g f e (x:xs) = if e == x then true else f e xs

(En mezcla de haskell y cálculo lambda)

## Calculo Lambda

#### Dadas las reglas de LC con registros, ¿por qué pedimos que para aplicar una proyección todos los campos de los registros sean valores y no proyectamos directamente?
Si tenemos M.l primero hacemos que M llegue a ser un valor y luego proyectamos. Además, para evaluar M, vamos de izquierda a derecha llevando los atributos de M a valores. Esto último entiendo que se hace para que la evaluación sea determinística. Ahora, supongamos que permitimos M.li -> Mi, con Mi el término de M. El problema es que perdemos el determinismo y la evaluación ya no es dirigida por la sintaxis. Esto porque dada M.li podemos elegir entre seguir evaluando los atributos de M y proyectar.

#### Si sacamos la regla siguiente para arreglarlo, ¿ahora anda o sigue roto?
 M -> M’
 -------------
 M.l -> M’.l
 Con esto recuperamos el determinismo. El problema es que dejamos de poder evaluar algunas cosas, por ejemplo:
 - ((\x : Nat. {edad = x}) 10).edad

#### Hablamos de la propiedad de progreso
Progreso en lambda cálculo es que todo término cerrado y bien tipado que no es un valor se puede seguir evaluando. Es decir, no hay deadlocks en la evaluación.

#### Por qué correctitud = progreso + preservación? (intuición)
Progreso es lo que dije en la pregunta anterior. Preservación es que el tipo se mantiene al evaluar un término cerrado y bien tipado. Necesitamos progreso para poder evaluar las cosas, pero sin preservación no nos sirve de mucho, porque tal vez evaluamos a algo que no está bien tipado (se rompió) y entonces no llegamos a un valor. La correctitud nos garantiza que no hay estados de error. Lo que entiendo que le faltaría a la correctitud es terminación. Es algo así como: "si termina, termina bien", tipo algo1, tiene sentido.

#### Pasa algo si se cambia el orden de las reglas de evaluación de la aplicación? (primero se evalúa el parámetro a un valor, después la función a un valor, después se hace la aplicación)
Actualmente hacemos M N --> V N --> V V' --> V' sustituido en el cuerpo de V
Supongamos que hacemos M N --> M V' --> V V' --> V' sust en el cuerpo de V.
Me parece que en general es más eficiente evaluar primero la función y después el parámetro. Así por ejemplo si la función no depende de ese parámetro no hace falta calcular el valor. Para terminar de evaluar el término siempre vas a tener que evaluar la función, en cambio el valor no necesariamente.
No sé si habrá alguna ventaja de evaluar el valor primero en algún caso, entiendo que por esto último que dije no, pero tal vez me equivoco. Caso infinito por ejemplo?

#### Qué propiedad se pierde al agregar referencias? Qué pasa con la propiedad de progreso?
Yo creo que se pierde la transparencia referencial: La evaluación de una expresión no depende solo de la evaluación de sus subexpresiones sino también de la memoria. Además, evaluar una expresión puede generar efectos colaterales en la memoria.
La propiedad de progreso cambia. Con referencias nos dice que todo término cerrado y bien tipado (vacío | Sigma > M : s) o bien es un valor o bien para cualquier memoria mu consitente con G | Sigma (G | Sigma > mu), existe M' y mu' tal que M | mu va a mu'. Es decir, todo término cerrado y bien tipado con algún sigma avanza para cualquier memoria consistente.

**Se pierde terminación también**. Hay un ejemplo en clase. Creo que esto es importante.

#### Dado el LC con Nat y Bool, queremos extenderlo a Int, donde predn(0) debería ser un valor. Qué cambios habría que hacer en las reglas de evaluación?
Primero hay que agregar términos predn(M) y el tipo Int y reglas de tipado para los Int. Suponiendo que eliminamos los Nat, las reglas de tipado dirían que 0 tiene tipo Int y predn(T) tiene tipo Int si T es Int y lo mismo para suc(T).
Tanto pred^n^(0) como suc^n^(0) serían valores. Habría que mantener las reglas de pred(M) -> pred(M') y suc(M) -> suc(M'). Habría que sacar la regla que dice que pred(0) -> 0 y mantener la regla de que pred(suc(V)) -> V y agregar una que diga que suc(pred(V)) -> V. isZero(0) -> true, isZero(predn(0)) -> false, isZero(succn(0)) -> true. Creo que eso sería todo.
Si no elimináramos Nat es un poco raro me parece, tal vez habría que usar subtipado, no sé.

#### Cómo definirías fix en haskell? Eso funcionaría en LC?
fix es una función que recibe una función f: s -> s y te devuelve un valor de tipo s tal que f(s) = s.
Lo encontré acá: https://en.wikibooks.org/wiki/Haskell/Fix_and_recursion
Se puede definir así:
fix :: (s -> s) -> s
fix f = let {x = f x} in x

fix :: (s -> s) -> s
fix f = f fix f
también anda y me parece que es la que espera hernán.

Y por ejemplo si definimos
fact2 :: (Int -> Int) -> (Int -> Int)
fact2 fact n | n > 1 = n * (fact (n-1))
                     | n == 1 = 1
Entonces fix fact2 5 es 120.
No siento que sea muy útil porque fix en LC se usa para implementar recursión, pero en haskell está permitida en forma directa. Funciona para encontrar puntos fijos igual.

En lambda cálculo no funciona la regla fix f -> f fix f porque para aplicar f a fix f necesitás que fix f sea un valor, con lo cual vas a tener que evaluar eso primero y no vas a terminar nunca. La regla que sí funciona es fix f -> f{fix f/x}, que es lo mismo pero adelantando un paso más, haciendo el paso de la aplicación aunque fix f no sea un valor.

#### Ref es contravariante? Por qué? Hablar de Sink y Source.
Ref no es contravariante (ni covariante). Contravariante significa que s < t --> Ref t < Ref s
Ahora por ejemplo si tomamos s = Bool y t = Int. Vale s < t, y supongamos que vale Ref Int < Ref Bool.
Entonces en un contexto en el que espero Ref Bool me deberían poder dar Ref Int y que esté todo bien. Pero entonces si leo me pueden dar un Int cuando yo esperaba un Bool. Luego estaría operando con ese Int como si fuera Bool y se rompe todo (tal vez Bool e Int no es el mejor ejemplo igual).

Sink y Source son dos tipos que se pueden agregar para representar referencias de solo escritura o de solo lectura (respectivamente).
Ambos son subtipos de Ref, y leer un Sink no tipa y escribir un Source tampoco.

#### Qué es que con subtipado algo sea covariante?
En subtipado, un tipo que depende de otro tipo (como por ejemplo Ref t, funciones s -> t, registros, etc.) es covariante si es "creciente" con respecto a la relación de subtipado, en el sentido de que si s <: s', T s  <: T s'.

#### Dados los tipos (Ref tau) − > Bool,  (Sink tau) − > Bool. Alguno es subtipo del otro?
Son dos tipos de funciones, con lo cual tenemos la regla s -> t <: s' -> t' si s' <: s y t <: t'.
El codominio es el mismo así que lo podemos ignorar porque la relación de subtipado es reflexiva.
Sink tau <: Ref tau, con lo cual las funciones que sale de Ref tau (y van a bool) son subtipo de las funciones que salen de Sink tau (y van a bool).

#### Diferencia entre subtipado y subtipado algorítmico. Por qué querría eliminar la regla T-sub? Cómo lo harías?
Al implementar un algoritmo de chequeo de tipos es importante que las reglas estén dirigidas por la sintaxis. Esto es, que la aplicación de reglas sobre un término sea siempre determinística en el sentido de que no haya más de una forma de tiparlo.
La regla T-sub dice que si s <: t y G |> M : s, entonces G |> M : t. Esta regla agrega no determinismo porque por ejemplo para tipar M N, puedo aplicar T-sub sobre M con subtipado de funciones, sobre N con subtipado del tipo del argumento, o sobre M N con subtipado del tipo del resultado.
Por ejemplo, para decir que G |> (L x : Bool. x) x : Int, puedo decir que (L x : Bool. x) tiene tipo Bool -> Int usando T-sub, o decir que  (L x : Bool. x) x : Bool y por lo tanto tiene tipo Int usando T-sub.

Para eliminar la regla T-sub, alcanza con meter la posibilidad de tomar un subtipo en la aplicación de una función, no hace falta subtipar en ningún otro lado. Es decir, cambiar la regla de la aplicación para que sea: s <: s' y G |> M : s' -> t y G |> N : s ---> G |> M N : t. Con esto, las reglas de TIPADO quedan dirigidas por la sintaxis. Las reglas de SUBTIPADO no, para hacer eso hay que sacar S-refl y S-trans, dejando solo la reflexibidad de los tipos básicos.
Con este cambio en las reglas de tipado, no vale más que G |> True : Int por ejemplo, pero en la práctica no lo necesitamos. Lo importante, me parece, es que el conjunto de términos que tipan sea el mismo.

#### Cómo definirías el algoritmo de inferencia para la siguiente regla?
G, x : s |- M : t    G, x : t |- M : s   -------> G |- x + M : (s, t)
La regla dice: Si suponiendo que x tiene tipo s sabemos que M tiene tipo t y suponiendo que x tiene tipo t sabemos que M tiene tipo s, entonces sabemos que x + M tiene tipo (s, t).
No sé, muy muy raro esto. No sé tampoco si está bien la solución que pusieron en cubawiki.


#### Cómo definirías el algoritmo de inferencia para la siguiente regla?
Gamma |- M : tau     Gamma, x: tau |- N : sigma   --------> Gamma |- M * N : sigma
Está bien definida esta regla? Qué es x con respecto a M y N? Muy raro.

Un intento:
Queremos definir W(M x N)
Supongamos 
 - W(M) = G1 |> M : t1.
 - W(N) = G2 |> N : t2.
Ahora si G2 tiene información de tipos para x, digamos G2 = G2' U {x : t3}.
Ahora tomamos el MGU: sust = MGU({t3 =. t1} U {s1 =. s2 | x : s1 \in G1 y x : s2 \in G2 para algún x)}.
Luego W(M x N) = sustG1 U sustG2 |> sust (M x N) : sust(t2).

#### Si tenés cálculo lambda de bool y naturales, sin el fix, podés tener recursión?
No. Con las aplicaciones y funciones lambda básicas no se puede porque las funciones no tienen nombre, con lo cual no las podés llamar desde adentro de sí mismas. Ahora ponele que usamos let y decimos: let x : Nat = suc(x) in x. No estoy seguro de si esto tipa. La regla dice que G |> suc(x) : Nat. No estoy seguro de si acá podemos decir que G incluye a {x: Nat}. Me parece que no, suc(x) tiene que ser un térimno cerrado y bien tipado. Igual, si dicen CL con bool y naturales tal vez ni está el let.
Podemos guardar una funcion en una referencia, luega actualizarla para que desreferencie la misma referencia dentro. Y así definir por ejemplo el factorial. Ref F = (\x:Nat. 0);  
F := (\x:Nat. If isZero(x) Then 1 else ((!F) (x-1)) * x);  
F 10

#### Si agregás referencias pero no agregas el fix, podes tener recursión?
Qué pregunta...
Supongamos que p es una referencia a una función.
Una idea podría ser hacer algo así: p := \x. Ref x -> Unit: !x x.
Esto no funciona porque la p de adentro de la lambda debería estar definida en sigma, y al evaluar eso quedaría la definición que tiene en sigma de p, no la nueva.
Diría que no. Un argumento un poco más general sería que para definir una función que se llame a sí misma, tenemos que poder referenciarla en su cuerpo, pero no hay forma de que esté definida.
En C/asm esto funciona: Pongo en la posición p a una función que llama a la función que está en la posición p.

**Creo que un ejemplo válido de recursión sin fix es el ejemplo de no terminación con referencias**

#### Para qué sirve subtipado?
Subtipado sirve para permitir que tipen más términos que tiene sentido que tipen. Por ejemplo dada una función (\r : {a: Int, b: Int}. M) queremos que la aplicación de esa función a un registro {b = 5, a = 6} ande, por más que tengan tipos distintos.

#### Definir con fix la función 'esPar'
let esPar = fix M in esPar 5
M tiene que ser una función que reciba una función de Int en Int y devuelva otra.
M = (\esPar : (Int -> Int). \n : Int. if n = 0 then True else ¬(esPar n-1)) 

#### Que problema hay con definir la regla de semántica de "fix f -> f fix f" (lease f como un lambda)
Mm. Sería lo mismo si en el siguiente paso usáramos la regla de la aplicación entre f y fix f y reemplazáramos en el cuerpo de f con fix f. El problema de hacerlo así es que primero se evalúa el argumento fix f hasta llegar a un valor, pero esto no va a llegar nunca a un valor porque le va a pasar lo mismo, entonces la evaluación no termina.

#### Qué relación hay entre el juicio de tipado de un término M, y el juicio de tipado producto de hacer W(Erase(M)))
Erase elimina las notaciones de tipos de las lambdas. La diferencia es que el juicio de tipado de W(Erase(M)) va a ser más general. El juicio de tipado de M va a ser instancia del juicio resultante de W(Erase(M)). Un juicio de tipado G |> M : tau es instancia de G' |> M': tau' si existe s sustitución de tipos tal que G' contiene a sG, sM' = M y s(tau') = tau.
Por ejemplo si tengo M = (\x : Nat. x). Un juicio de tipado es vacío |> M : Nat -> Nat y W(Erase(M)) sería vacío |> (\x: s. x) : s -> s. La sustitución es {Nat/s}.

#### Encontrar un término M tal que al hacer W(Erase(M)), te queda un término distinto sintácticamente a M, pero del mismo tipo
(\x : Nat. 0). W(Erase(M)) da el juicio del término (\x: s. 0) : Nat, para algún s.

#### (Mía) Por qué hace falta un Sigma en los juicios de tipado para agregar referencias a LC
Por ejemplo, queremos decidir si (\x. Int. suc(x)) !r tipa. La regla de la aplicación nos va a pedir que !r tenga tipo Int.
Cuál es la regla de tipado para !r?
G |> r : Ref Int ---> G |> !r : Int
Perfecto. Ahora cómo deribamos que G |> r : Ref Int?

Cómo evalúa el término ref 2?
ref 2 --> l, y l se agrega a la memoria.

#### (Mía) Qué pasa con la propiedad de preservación al agregar referencias en LC?
Se mantiene pero modificada. Al avanzar de M -> M', se avanza también de mu a mu', y el tipo de M y M' coinciden, bajo la hipótesis de que Sigma y Sigma', es decir, los contextos de tipos de las referencias, sean mantengan (salvo que Sigma' podría tener nuevas etiquetas).

#### (Mía) Describir las reglas de subtipado para registros
Un tipo de registros a es subtipo de otro b si: las etiquetas de a contienen a las de b, las etiquetas de b que están en a tienen en a tipos que son subtipos de las de b (notar que no importa el orden de las etiqeutas).

#### (Mía) Qué significa ; en LC?
M1 ; M2 --> (\x : Unit. M2) M1 (suponiendo que x no pertencece a FV(M2))
Obs: M1 debería ser de tipo Unit.

#### (Mía) Dar el algoritmo de inferencia de tipos para if then else
W(if B then M else N) = SG1 U SG2 U SG3 |> if B then M else N : t2

W(B) = G1 |> B : t1
W(M) = G2 |> M : t2
W(N) = G3 |> N : t3

S = MGU({t2 =. t3, t1 =. Bool} U {s1 =. s2 | x : s1 \in Gi y x : s2 \in Gj, i != j})

if True then (\y: Int. True) suc(x) else x

W(True) = 0 |> True : Bool
W((\y. True) suc(x)) = {x : Int} |> (\y : Int. True) suc(x) : Bool
W(x) = {x : s} |> x : t3

S = MGU({Bool =. t3, Bool =. Bool}) = {Bool/t3}

W(if True then (\y: Int. True) suc(x) else x) = {x : Int} U {x : Bool} |> ...
  



## Objetos

#### Explicar method dispatch estático vs. dinámico.
Method dispatch es, dado un envío de mensaje a un objeto, encontrar el método correspondiente, es decir, el código que se ejecuta al realizarse ese llamado. La búsqueda es estática si es en tiempo de compilación y es dinámica si es en tiempo de ejecución. Obviamente, estático siempre es más eficiente, pero no siempre se puede hacer saber quién es el método que se tiene que ejecutar en tiempo de compilación. Por ejemplo en javascript, que uno puede por código asignar métodos, en tiempo de compilación puede ni existir el método al que nos referimos.

#### Diferencias entre semántica operacional entre LC y SC.
(Small step y big step)
La semántica operacional en Sigma Cálculo es big step porque en una sola reducción transforma cualquier término en un valor. Los términos a reducir en SC son asignaciones a métodos y accesos a métodos. Los valores son objetos. Cuando asignamos o.lj <= s(x) b, primero reducimos o un valor y después seteamos el método y nos queda un valor. Cuando accedemos a o.lj, primero necesitamos que o sea un valor, y después evaluamos el método hasta llegar a un valor y el resultado es ese valor.
SC se podría hacer como en LC. Para la asignación podríamos decir que vamos reduciendo de a un paso o y cuando es un valor hacemos el seteo. Para la proyección lo mismo.
LC se podría hacer big step me parece. Por ejemplo para evaluar M N la regla sería. Si M -> (\ ...) y N -> V, entonces M N -> (\...){V/N}.

#### ¿Cómo se evidencia "que un programa se colgó" en la semántica operacional de lambda cálculo? ¿Y en sigma cálculo?
La evaluación de un término en LC se luega si llegamos a un término en el que no se puede aplicar ninguna regla pero que no es un valor. Es decir, aplicamos reglas one-step desde el término inicial hasta que en algún momento se cuelga. Por otro lado en SC si un término se cuelga, no podemos aplicar nada, se cuelga directamente. Si tenemos una selección o.lj, puede ser que se cuelgue la evaluación de o o que se cuelgue la evaluación del método lj de o. Si tenemos una asignación o.lj <= s(x) b, puede ser que se cuelgue la evaluación de o, aunque no sabemos muy bien cómo. Tal vez igual siguiendo la recursión se puede ver cuál es la subestructura de o que se rompe.

#### Se pierde o gana alguna propiedad al traducir cálculo lambda en cálculo sigma?
No, porque no introducimos sintaxis ni semántica nuevas, es solo azucar sintáctico.

#### Se puede evaluar una función sin pasarle un parámetro?
Una función es un objeto que tiene un atributo argumento y un método para evaluarla. Por cómo lo definimos en clase, si se intenta evaluar una función sin haber asignado el argumento, se cuelga la evaluación. Esto porque el valor inicial del argumento es y.arg (con y ligada a self), entonces al hacer la selección de .val y evaluarse el método se cuelga haciendo infinitas selecciones de .arg. 

#### Diferencia entre los ligadores λ y σ. Relacionar con javascript.
Con lambda se liga el argumento de la aplicación (N en M N) a la variable en M. Con sigma se liga el objeto receptor del mensaje (o en o.lj) a la variable en bj.
En javascript, el lambda sería parecido al argumento de una función y el sigma sería como this. No sé si hay algo más para decir acá.

#### Puedo extraer un método de un objeto? Qué pasa con self en ese caso?
En cálculo sigma diría que no se puede extraer el método en sí, siempre lo evalúas antes. Solo que si evalúa a un objeto que representa una función, lo podés asignar en otro método evaluando a la función con this (esto se usa para definir clases y subclases). En javascript sí se puede hacer más directamente porque todo es un atributo. Entonces por ejemplo podés decir f = o.move, si move es un método de o (sin evaluar move()). En este caso si move accede a a this, al llamar a f this se va a ligar a undefined.

#### ¿Puede haber recursión infinita? Dar un ejemplo.
Sí, un ejemplo muy sencillo es el término {a = sig(s) s.a}.a

## Lógico

#### Diferencias entre la regla de resolución para proposicional vs. lógica de primer orden.
En la regla en sí, la diferencia es que en primer orden hace falta una regla que permita unificar varios átomos a la vez con sus negaciones de la otra cláusula (unificando todo con todo). En cambio en proposicional alcanzaba con una regla binaria que unificara de un átomo de cada cláusula. Lo que le falta a la regla binaria en primer orden es la posibilidad de factorizar. Es decir, unificar un conjunto de átomos dentro de una cláusula, que no son sintácticamente iguales. Esto en proposicional no hacía falta porque si eran unificables eran iguales porque son solo proposiciones.

Otra diferencia en el proceso de resolución es que en proposicional termina sí o sí y en primer orden no necesariamente si la fórmula que queremos probar que es insatisfactible, es satisfactible. Puede pasar que nos quedemos buscando la refutación para siempre.

#### ¿Por qué si las reglas para LPO no son completas, en Prolog se pueden usar igual y anda?
Mm, las reglas para LPO tengo entendido que son completas. Lo que no es completo es SLD, porque solo resuelve para fórmulas que se pueden escribir como cláusulas de Horn. En prolog justamente la sintaxis solo permite escribir cláusulas de Horn.

#### Cómo funciona el not para árboles de resolución finitos e infinitos.
El not se fija si el término que le ponemos unifica con algo en nuestra base de conocimientos. Si encuentra alguna unificación corta y devuelve false. Si recorre todo y no encuentra devuelve true. Si el árbol que tiene que recorrer es infinito busca hasta encontrar algo y si no encuentra se cuelga (puede pasar porque no hay unificación o porque hay pero se queda en una rama infinita del árbol que viene primero.

#### Vimos unos casitos de resolución, y discutimos si se podía unificar en un paso a la cláusula {}:
 * {p(X,a)}, {~p(b,X)}
 * {p(X), q(a)}, {~p(b), ~q(Y)}
 * {P(a, f(X)), P(X,Y)}   {~P(a,X)}

#### Explicar la regla de resolución de primer orden
La regla dice que si tengo dos cláusulas {A1, ..., An, B1, ..., Bm}, {¬C1, ..., ¬Ck, D1, ..., Dr}
(es decir, tengo la fórmula (A1 v ... v Bm) ^ (¬C1 v ... v Dr) ^ ...)
Si A1,...,An unifican entre sí y además unifican con todos los C1, ..., Ck.
Entonces es equivalente en cuanto a validez a la fórmula que además tiene la cláusula sig({B1, ..., Bm, D1, ..., Dr}).
Duda: Qué es la unificación en términos lógicos?

#### Soluciones de s(X) en este programa con cut:

s(X):- p(X).
s(0).

p(X) :- q(X).
p(1).

q(X):- r(X),!.
q(2).

r(3).
r(4).

Las soluciones son:
Unifica con la primera regla y tiene que resolver p(X). Para eso unifica con la primera de p(X) y tiene que resolver q(X). Para eso unifica y tiene que resolver r(X), !. Ahí instancia X en 3. Luego llega al cut, que tiene éxito, con lo cual se devuelve X=3, y además elimina la búsqueda de alternativas para q(X), con lo cual el backtracking continúa desde p, y se encuentra X=1 y X=0.
cut elimina el backtracking sobre todas las alternativas de los términos a la izquierda de ! en la misma regla y sobre todas las alternativas de la regla que contiene al cut, pero nada más.

#### Qué podría pasar si cambiáramos el orden de búsqueda en prolog?
Por ejemplo de arriba hacia abajo en vez de de abajo hacia arriba? Supongo que funcionaría igual, pero cambiaría el orden en el que encuentra las soluciones y para el caso infinito podrían colgarse cosas que ahora no se cuelgan y viceversa.

#### Dado el siguiente programa, qué responde prolog a p(W).?
p(X):- q(X).
p(1).
q(X) :- r(X),!.
q(b).
r(a).
r(b).

Solución: Primero unifica W con X en la primera regla y pasa a resolver q(X). Ahora en r(X) unifica X con a y se mueve hacia el q y tiene éxito, con lo cual se devuelve W=a. Como efecto secundario del cut, se eliminan las alternativas para r (no se considera r(b)) y se eliminan las alternativas para q (no se mira q(b)). Luego el backtracking continúa desde p y se obtiene W=1 con la segunda regla de p.

#### Tenemos un programa en prolog que dado el goal ¬p(X) devuelve primero X=1 y después se cuelga. Qué pasa si evaluamos not(p(X))? Qué pasa si evaluamos not(not(p(X))), X==2.?


#### Arbolito SLD y que ramas no se recorrían con un cut (es el arbolito que está como ejemplo de cut de SLD)

#### Qué pasa con not(not(p(X))?
not(p(X)) es call(p(X)), !, fail
Es decir, va a intentar unificar p(X) y si lo logra devuelve falso y si no lo logra (y chequea todas las posibilidades) devuelve true.
Es importante notar que not no instancia X en nada. No es negación lógica, no nos permite decir definir una regla del tipo de serAlto(X) :- not(serBajo(X))., porque not(serBajo(X)) lo que hace es fijarse que no haya nadie que sea bajo.

not(not(p(X)) va a intentar unificar not(p(X)).
Si p(X) unifica con algo, entonces not(p(X)) va a dar false y not(not(p(X))) va a dar true.
Si p(X) no unifica con nada, entonces not(p(X)) va a dar true y not(not(p(X))) va a dar false.
Es distinto de decir p(X) que, si X no está instanciado, lo va a intentar instanciar en un X que cumpla p(X).

#### (Mía) Dado el siguiente programa en prolog. V o F jusitifcando con árboles SLD

a(1, 2).
a(1, 3).
b(3).
p(X, Y) :- a(X, Y), b(Y).

Y la siguiente modificación: a(1, 2) := !.
a) No se altera el conjunto de soluciones para las consultas ground.
Verdadero. Una consulta ground sobre a es a(x, y) para x e y átomos. No cambia nada porque no es posible que unifique con a(1, 2) y con a(1, 3). Si fuera posible cambiaría porque en la versión modificada unificaría con a(1, 2) y dejaría de buscar.
Una consulta ground sobre p es p(x, y) con x e y átomos, y no va a haber ninguna diferencia por lo que dije sobre a.

b) La consulta not(p(X, Y)) produce distintos resultados si se cambia el programa.
Falso, sí cambia.
not(p(X, Y)) en la primera versión, busca soluciones para p(X, Y) y como encuentra X = 1, Y = 3 retorna false.
En la segunda versión, intenta resolver p(X, Y). Primero toma a(X, Y) y unifica con a(1, 2) y se encuentra con el cut, que elimina el backtracking sobre a. Luego b(2) falla y no tiene adonde backtrackear con lo cual termina la búsqueda y responde true a not(p(X, Y)).

#### Sean F y G dos cláusulas para las cuales no existe resolvente. Entonces ¬F v ¬G es una tautología.
Sabemos que no existe resolvente para {{F}{G}}, que es F ^ G. Como no existe resolvente, F ^ G es satisfacible, por contrarrecíproco de la completitud. Entonces F ^ G = ¬(¬F v ¬G) es satisfacible, pero no necesariamente una tautología.
Por ejemplo si F = P(x) y G = Q(x), no hay resolvente y ¬P(x) v ¬Q(x) no es una tautología.

#### (Mía) Dar un ejemplo de no terminación del método de resolución en LPO

#### (Mía) Dar un ejemplo de no terminación en prolog, y mostrar cómo afecta el orden de búsqueda.

## Otros finales

Final con fotos:
https://www.cubawiki.com.ar/index.php/Final_11/08/2021_(Paradigmas)

Otro final multiple choice:
https://www.cubawiki.com.ar/index.php/Final_28/09/2020_(Paradigmas)

Jess:

- Haskell
    . diferencias entre foldl y foldr
    . ¿cualquier recursion se puede hacer con foldr?

- De calculo lambda: 
   . que se perdia con ref
   . si me da lo mismo evaluar un registro de izquierda a derecha (regla E-rcd o algo asi) o de derecha a izquierda con referencias
- Subtipado:
    . Subtipado algoritmico qué es para qué sirve, me alcanza para todo? 
    . Regla de subtipado del if
- calculo sigma:
    . diferencias en semantica con calculo lambda, big step small step cual era "mejor"
    . De prototipado que pasa si tengo objeto A = {p : 1}  que prototipa O = {}, y hago O.p, y que pasa si hago O.p = 5
- Resolución:
    . ¿resolucion lineal es completa?
    . Resolucion sld
    . un ejemplito de si podia resolver en un paso una formulita que creo es igual a uno de los finales viejos (no me la acuerdo)
    . que onda el not, que pasa con not(G) si G es finito y no tiene sc, si es finito y tiene sc y si es infinito en ambos casos


--Dado este foldD me pidio dar la estructura a la que lo estoy aplicando

foldD :: (c->c) -> (a -> c -> c) -> (b -> c) -> D a b -> c
data D a b = C1 (D a b) | C2 a (D a b) | C3 b

:t C3 "hola" --> D a String
C1 (C3 "hola")
x = C2 5 x

--me pidio definir top que devuelve el primer valor que encuentra en el dato

top :: D a b -> Either a b
top (C3 x) = Right x
top (C2 x y) = Left x
top (C1 x) = top x

top = foldD id (\x rec -> Left x) (\x -> Right x)Int

top = foldD (\rec -> rec) (\a rec -> Left a) (\b -> Right b)
--Como C2 y C3 pueden devolver distintos tipos me guió a que use Either

--me pidio dar un dato infinito para esta estructura
dato :: A Int Bool
dato = C2 1 dato


--no se me ocurrio y me lo hizo pensar primero en listas y despues me salió
unaLista :: [Int]
unaLista = 0 : unaLista






--reducir "top dato" hablando de que como es lazy no se cuelga por mas que sea infinita y todo eso
top dato -> foldD (\rec -> rec) (\a rec -> Left a) (\b -> Right b) dato 
 -> foldD (\rec -> rec) (\a rec -> Left a) (\b -> Right b)  (C2 1 dato)
-> (\a ->( rec -> Left a) ) 1 (foldD … dato)

f = id 
g = (\x rec -> Left x)
h = (\x -> Right x)
top dato --> top C2 1 dato --> (foldD f g h) C2 1 dato --> g 1 (foldD f g h dato) --> Left 1

--Me preguntó sobre la reduccion de registros (me dejó verlas en las diapos)
--Me hizo explicar como funciona E-Rcd (Que va reduciendo de izquierda a derecha)
--Dijo que era una reduccion muy cara porque tenes que reducir todo cuando capaz te interesa una sola etiqueta
--Entonces propuso sacar E-Rcd y el problema está en que no podes reducir {l1 = Mi} 
--Pero no podrias reducir esto, entonces perdes progreso
{l1 = if true then 0 else succ(0)}

--Entonces propuso dejar E-Rcd y modificar E-ProjRcd pidiendo que solo sea un valor la que quiero proyectar
--Pierdo determinismo porque puedo reducir las etiquetas y despues proyectar o al revés

{l1 = Mi,..,ln = Mn}.ln


-----------------

--Me dio esta definicion y pidio definir el W

Gamma |> M : tau       Gamma,x:tau > N : sigma
----> Gamma |> (x ? M -> N) : sigma

tau = Bool
sigma = Int
x ? True -> if x then 5 else 2

W(x ? M -> N) = SG1 U SG2 |>

W(M) = G1 |> M : t1
W(N) = G2 |> N : t2

t3 = {alfa si {x: alfa} \in G2, s con s variable fresca si no}

W(x ? M -> N) = SG1 U S(G2 (-) x) |> S(x ? M -> N) : St2

S = MGU({t1 =. t3} U {s1 =. s2 | {x : s1} en G1 y {x : s2} en G2})


W( x? U -> V) = S gamma1 U S gamma2’ > S x? S U -> S V -> S sigma
W(U) = gamma1 > U : tau
W(V) = gamma2 > V : sigma
x_ro {Si x:ro pertenece a gamma2 -> x:ro
    sino x:t t variable fresca}
gamma2’ = gamma2 - {x}
x no tiene que pertenecer a gamma1
S=MGU{sigma1=sigma2 | x:sigma1  }{ro=tau}

-------

--Definir el objeto Either que se comporta como en haskell
--Este fue muy charlado y lo armamos juntos 

o = [right = s(x) ..., left = s(x) ..., ] : [right: a, left: b]






o :: Maybe Int

f :: Maybe Int -> Bool
case x of 
   Left v -> f v


= [val = 
 
]

Left1 = [case: function(l r){return l val},
val = 1]
Right1 [case: function(l r){return  r val}
val = true]

--preguntó que diferencia hay entre reducir en lambda y en sigma
--también como que llegue a un error en sigma y en lambda, hablando de progreso y no terminacion


-------

--un monton de preguntas de resolucion
--diferencias entre proposicional y primer orden
--porqué no es completo resolucion binaria en primer orden y cómo hago para que sea completo
--Le estaba dando este ejemplo de factorizacion y preguntó si podía llegar a la clausula vacia en un paso con general
{{¬P(X),¬P(Y)}, {P(a),P(b)}} -> {P(Z)}

--Que de una clausula que no pueda ser de Horn
{P(x), Q(y)}

P(X) v P(y


P(X) v Q(Y)
{{P(X),Q(Y)}}

--Me pregunto como seria la clausula de abajo en Forma Skolemizada
--no terminamos de definirlo y pasó a prolog
EZ VX (¬p(X,Z) v EW p(Z,W)) --> EZ VX (¬p(X,Z) v p(Z,f(Z)) --> VX (¬p(X,c) v p(c, f(c))

--pregunto si unificaba, como son 2 clausulas funciona

{{¬p(X,f(Y))},{p(f(Y),f(X)}}

--preguntas de prolog
--si el arbol SLD tenia todas las soluciones y porque prolog podria no encontrarlas
--si cambia el arbol o las soluciones si modifico el orden en que escribo las reglas en prolog

--un monton de casos con ! y not que fue borrando

p(X) :- q(X).
p(a).
q(X) :- r(X),!.
q(b).
r(c).
r(d).

p(W).
X= c, X=d, X=b, X=a
