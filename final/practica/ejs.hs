inc x = x + 1

{-
map' inc [1..10]
filter' (\x -> x < 5) [1..10]
filter' (< 5) [1..10]
filter' (\x -> x * 2 < 5) [1..10]
filter' ((<= 6) . (2 *)) [1..10]
-}

-- está currificada porque toma sus inputs de a uno
add x y = x + y

{-
Podemos hacer una aplicación parcial

inc' = add 1

map (add 1)
-}

data Figura = Circulo Float | Rectangulo Float Float

esCuadrado :: Figura -> Bool
esCuadrado (Rectangulo x y) = (x == y)
esCuadrado _ = False

{- Clase 1 -}
--- Map
map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map f xs

dobleL :: [Float] -> [Float]
dobleL = map (*2)

esParL :: [Int] -> [Bool]
esParL = map even

longL :: [[a]] -> [Int]
longL = map length

--- Filter
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (x:xs) =
    if f x
    then x : filter f xs
    else filter f xs

-- otra forma
filter'' _ [] = []
filter'' f (x:xs)
    | f x = x : filter f xs
    | otherwise = filter f xs


negativos :: [Float] -> [Float]
negativos = filter (< 0)

noVacias :: [[a]] -> [[a]]
-- noVacias = filter (\l -> length l > 0)
noVacias = filter ((>0) . length)

{- Clase 2 -}

foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' _ z [] = z
foldr' f z (x:xs) = f x (foldr f z xs)

-- Algunas funciones de ejemplo

sumaL :: [Int] -> Int
--sumaL = foldr' (\x r -> x + r) 0
sumaL = foldr' (+) 0

concat' :: [[a]] -> [a]
concat' = foldr' (++) []

reverso :: [a] -> [a]
-- reverso = foldr (\x xs -> xs ++ [x]) []
reverso = foldr (flip (++) . (:[])) []

-- Redefino map y filter
-- map'' f = foldr (\x r -> f x : r) []
map'' f = foldr ((:) . f) []

filter''' f = foldr (\x r -> if f x then x:r else r) []

-- Foldl

foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' _ z [] = z
foldl' f z (x:xs) = foldl' f (f z x) xs

reverse = foldl' (flip (:)) []

sumaL' = foldl' (+) 0
{-
foldl' (+) 0 [1, 2, 3, 4]
= foldl' (+) (0 + 1) [2, 3, 4]
= foldl' (+) ((0 + 1) + 2) [3, 4]
= foldl' (+) (((0 + 1) + 2) + 3) [4]
= foldl' (+) ((((0 + 1) + 2) + 3) + 4) []
= ((((0 + 1) + 2) + 3) + 4)

foldr (+) 0 [1, 2, 3, 4]
= 1 + (foldr 0 [2, 3, 4])
= 1 + (2 + (foldr 0 [3, 4]))
= 1 + (2 + (3 + (foldr 0 [4])))
= 1 + (2 + (3 + (4 + (foldr 0 []))))
= 1 + (2 + (3 + (4 + 0)))

en cambio, con a -> b en vez de b -> a
foldl' :: (a -> b -> b) -> b -> [a] -> b
foldl' _ z [] = z
foldl' f z (x:xs) = foldl' f (f x z) xs

foldl' (+) 0 [1, 2, 3, 4]
= foldl' (1 + 0) 0 [2, 3, 4]
= foldl' (2 + (1 + 0)) 0 [3, 4]
= foldl' (3 + (2 + (1 + 0))) 0 [4]
= foldl' (4 + (3 + (2 + (1 + 0)))) 0 []
= (4 + (3 + (2 + (1 + 0))))
-}

{- Folds sobre estructuras algebráicas -}

data Arbol a = Hoja a | Nodo a (Arbol a) (Arbol a) deriving Show

arbolSimple = Nodo 1 (Hoja 2) (Nodo 3 (Hoja 4) (Hoja 4))

-- quiero hacer un map sobre el árbol
mapA :: (a -> b) -> Arbol a -> Arbol b
mapA f (Hoja x) = Hoja (f x)
mapA f (Nodo x i d) = Nodo (f x) (mapA f i) (mapA f d)

-- > mapA (*2) arbolSimple
-- Nodo 2 (Hoja 4) (Nodo 6 (Hoja 8) (Hoja 8))

-- foldr sobre el arbol?
foldrA :: (a -> b) -> (a -> b -> b -> b) -> Arbol a -> b
foldrA f _ (Hoja x) = f x
foldrA f g (Nodo x i d) = g x (foldrA f g i) (foldrA f g d)

idA = foldrA (Hoja) (Nodo)

-- Árboles generales
data AG a = NodoAG a [AG a] deriving Show

agEx = NodoAG 1 [NodoAG 2 [], NodoAG 3 [NodoAG 4 []], NodoAG 5 []]

mapAG :: (a -> b) -> AG a -> AG b
--mapAG f (NodoAG x xs) = NodoAG (f x) (map (\a -> mapAG f a) xs)
mapAG f (NodoAG x xs) = NodoAG (f x) (map (mapAG f) xs)

foldrAG :: (a -> [b] -> b) -> AG a -> b
foldrAG f (NodoAG x xs) = f x (map (foldrAG f) xs)

sumaAG = foldrAG (\x xs -> x + (foldr (+) 0 xs))