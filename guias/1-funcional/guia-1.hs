-- practica 2, funcional
-- solo se pueden usar esquemas recursivos, y no recursion explicita.

--- Currificacion y tipos
-- TODO

--- Listas por comprension
-- ej 3
-- > [ x | x <- [1..3], y <- [x..3], (x + y) `mod` 3 == 0 ]
-- x = 1, y = 1, 2, 3   --> 1
-- x = 2, y = 2, 3
-- x = 3, y = 3         --> 3
-- --> [1, 3]

-- ej 4
pitagoricas :: [(Integer, Integer, Integer)]
-- pitagoricas = [(a, b, c) | a <- [1..], b <-[1..], c <- [1..], a^2 + b^2 == c^2]

-- No va a terminar nunca, porque con a = 1 y b = 1, 2 = c^2 si c = sqrt(2) pero
-- solo toma valores enteros. Entonces va a recorrer c para siempre.

pitagoricas = [(a, b, c) | c <- [1..], a <- [1..c^2], b <-[1..c^2], a^2 + b^2 == c^2]

-- ej5
prime :: Int -> Bool
prime = (==2) . length . divisores
    where divisores k = [d | d <- [1..k], k `mod` d == 0]

allPrimes :: [Int]
allPrimes = [x | x <- [1..], prime x]

firstPrimes = take 1000 allPrimes

-- ej 6
-- TODO

-- ej 7
-- Dado n devuelve todas las listas de enteros positivos cuya suma sea n.
-- Se puede usar recursion explicita.
listasQueSuman :: Int -> [[Int]]
-- Idea: Si tengo todas las listas que suman (n - k), les agrego k y van a sumar
-- n. "Recursion global"
listasQueSuman 0 = [[]]
listasQueSuman n = concat [map (\l -> k:l) $ listasQueSuman (n-k) | k <- [1..n]]

-- ej 8
-- Lista que contenga todas las listas finitas de enteros positivos
listasPositivas :: [[Int]]
-- listasPositivas = concat [listasQueSuman n | n <- [1..]]
-- listasPositivas = concat $ map listasQueSuman [1..]
listasPositivas = concatMap listasQueSuman [1..]

--- Esquemas de recursion
-- ej 9
type DivideConquer a b = 
    (a -> Bool) -- determina si es o no el caso trivial
    -> (a -> b) -- resuelve el caso trivial
    -> (a -> [a]) -- parte el problema en sub-problemas
    -> ([b] -> b) -- combina resultados
    -> a -- estructura de entrada
    -> b -- resultado

dc :: DivideConquer a b
dc trivial solve split combine x =
    | trivial x = solve x
    | otherwise   = combine (map dc (split x))

--

mergeSort :: Ord a => [a] -> [a]
mergeSort = dc trivial solve split combine
    where
        trivial = (==1) . length
        solve = id
        split = 
        combine = 
        