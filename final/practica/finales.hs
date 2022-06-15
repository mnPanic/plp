{- Final Laura VR telegram -}

data MiDato a b = C1 (MiDato a b) | C2 a | C3 a b deriving Show

foldMiDato :: (c -> c) -> (a -> c) -> (a -> b -> c) -> (MiDato a b) -> c
foldMiDato f g h (C1 x) = f (foldMiDato f g h x)
foldMiDato _ g _ (C2 a) = g a
foldMiDato _ _ h (C3 a b) = h a b

miDatoEx = C1 (C1 (C2 3))
miDatoEx2 = C1 (C1 (C3 3 4))
miDatoEx3 = C2 3

cuenta = foldMiDato (+1) (const 0) (const (const 0))
-- (const . (const 0)) también


-- ### Definir map usando foldl y foldr. Qué pasa con foldl y foldr con listas infinitas?

-- map :: (a -> b) -> [a] -> [b]
-- foldr :: (a -> b -> b) -> b -> [a] -> b
-- foldl :: (b -> a -> b) -> b -> [a] -> b

-- map' f = foldr (\x r -> f x : r) []
map' f = foldr ((:) . f) []

--map'' f = foldl (\r x -> r ++ [f x]) []
-- map'' f = foldl ( (++) . (:[]) . flip f) no se como sería esto

-- foldr anda bien con listas infinitas mientras que foldl se cuelga, porque
-- necesita terminar de recorrer toda la lista para poder terminar, mientras que
-- foldr lo podes ir aplicando con take.

-- #### Definir fold sobre árbol binario. Usar ese fold para definir:
-- truncar10:: ArbolBinario Int -> ArbolBinario Int
-- Ejemplos:

-- truncar10 (Hoja n) = Hoja n
-- truncar10 (Nodo 1 (Hoja 2) (Hoja 5)) = Hoja (1+2+5)
-- truncar10 (Nodo 4 (Hoja 5) (Hoja 2)) = (Nodo 4 (Hoja 5) (Hoja 2))

-- Es decir, agrupa recursivamente nodos que con sus hijos suman menos de 10

-- Solución:
data ArbolBinario a = Hoja a | Nodo a (ArbolBinario a) (ArbolBinario a) deriving Show

foldAB :: (a -> b) -> (a -> b -> b -> b) -> (ArbolBinario a) -> b
foldAB fH _ (Hoja x) = fH x
foldAB fH fN (Nodo x l r) = fN x (foldAB fH fN l) (foldAB fH fN r)

truncar10 = foldAB (\x -> Hoja x) fN

fN x (Hoja y) (Hoja z) = if x + y + z < 10 then (Hoja (x + y + z)) else (Nodo x (Hoja y) (Hoja z))
fN x l r = (Nodo x l r)

-- #### Explicar uncurry y definirla
-- suma x y = x +y -- curificada
-- suma (x, y) = x + y -- no currificada, con una tupla

-- uncurry' :: (a -> b -> c) -> ((a, b) -> c)
-- uncurry' f = (\t -> f (fst t) (snd t))
-- es igual a, lo cual tiene sentido aplicar parcialmente
uncurry' f (a, b) = f a b

-- #### Explicar curry y definirla
curry' f a b = f (a, b)