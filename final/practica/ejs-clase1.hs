-- tal que dobleL xs es la lista que contiene el doble de cada elemento en xs
dobleL :: [Float] -> [Float]
dobleL [] = []
dobleL (x:xs) = 2*x : dobleL xs
dobleL = map (\x -> 2 * x)

-- tal que la lista esParL xs indica si el correspondiente elemento en xs es par
-- o no
esParL :: [Int] -> [Bool] 
esParL [] = []
esParL (x:xs) = (x `mod` 2 == 0) : esParL xs
esParL = map mod

-- tal que longL xs es la lista que contiene las longitudes de las listas en xs
longL :: [[a]] -> [Int]
-- longL [] = []
-- longL (x:xs) = (length x) : longL xs
longL = map length

-- esquema recursivo de map:

-- map :: [a] -> [b]
-- map [] _ = []
-- map f (x:xs) = f x : map f xs

-- filter

-- tal que negativos xs contiene los elementos negativos de xs
negativos :: [Float] -> [Float]
negativos [] = []
negativos (x:xs)
    | x < 0 = x : (negativos xs)
    | otherwise = negativos xs

- tal que la lista noVacias xs contiene las listas no vacı́as de xs
noVacias :: [[a]] -> [[a]]
noVacias [] = []
noVacias (l:ls)
    | (length l > 0) = l : (noVacias ls)
    | otherwise = noVacias ls

-- esquema recursivo:
filter :: (a -> Bool) -> [a] -> [a]
filter _ [] = []
filter p (x:xs) = if (p x) then x : (filter p xs)
                  else (filter p xs)