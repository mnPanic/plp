-- ej 2

-- Dado un numero devuelve su valor absoluto
valorAbsoluto :: Float -> Float
--valorAbsoluto n = if n > 0 then n else -n
valorAbsoluto n | n > 0 = n
                | otherwise = -n

bisiesto :: Int -> Bool
bisiesto n = (divisible n 4) && ( (not (divisible n 100)) || divisible n 400)
    where divisible = (\x y -> ((x `mod` y) == 0))

-- (n)! = n * (n-1)! ...
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

prime :: Int -> Bool
prime n = foldr (\x r -> (n `mod` x /= 0) && r) True [2..n-1]

primosHasta :: Int -> [Int]
primosHasta n = [x | x <- [1..n], prime x]

cantDivisoresPrimos :: Int -> Int
cantDivisoresPrimos x = foldr (\p r -> if (x `mod` p == 0) then r+1 else r) 0 (primosHasta x)

-- ej 3
inverso :: Float -> Maybe Float
inverso 0 = Nothing
inverso n = Just (1/n)

aEntero :: Either Int Bool -> Int
aEntero (Left n) = n
aEntero (Right True) = 1
aEntero (Right False) = 0

-- ej 4
limpiar :: String -> String -> String
limpiar ss [] = []
limpiar ss (w:ws) = if w `elem` ss then rest else w:rest
    where rest = limpiar ss ws

-- high order
-- limpiar ss ws = filter (\x -> not (x `elem` ss)) ws
-- limpiar ss ws = filter (not . (flip elem ss)) ws

-- ej 5 - arboles binarios

data AB a = Nil | Bin (AB a) a (AB a) deriving Show

-- indica si un arbol es vacio
vacioAB :: AB a -> Bool
vacioAB Nil = True
vacioAB _ = False

-- dado un arbol de booleanos construye otro formado por la negacion de cada uno
-- de los nodos.
negacionAB :: AB Bool -> AB Bool
negacionAB Nil = Nil
negacionAB (Bin izq r der) = Bin (negacionAB izq) (not r) (negacionAB der)

-- calcula el producto de todos los nodos del árbol.
productoAB :: AB Int -> Int
productoAB Nil = 1
productoAB (Bin izq r der) = (productoAB izq) * r * (productoAB der)