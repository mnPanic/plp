-- usando foldr

elem' :: Eq a => a -> [a] -> Bool
--elem' x = foldr (\y r -> (x == y) || r) False
elem' x = foldr ( (||) . (x==) ) False

--sumaAlt :: Num a => [a] -> a
--sumaAlt x = foldr (-)

-- sumaAlt [1, 2, 3]
-- foldr (-) 0 [1, 2, 3]
-- (-) 1 ( foldr 0 [2, 3] )
-- (-) 1 ( (-) 2 ( foldr 0 [3] ) )
-- (-) 1 ( (-) 2 ( (-) 3 ( foldr 0 [] ) ) )
-- (-) 1 ( (-) 2 ( (-) 3 ( 0 ) ) )



-- cantidad de veces que se repite un elemento en una lista
cantApariciones :: Eq a => a -> [a] -> Int
cantApariciones x = foldr ( \y r -> (if (y == x) then 1 else 0) + r) 0

take' :: Int -> [a] -> [a]
take' n xs = foldr ( \i r -> (xs !! i):r ) [] [0..n]

-- cuando tenes que hacer recursion sobre otra cosa ademas de la lista tenes
-- que devolver funciones.
take'' :: [a] -> (Int -> [a])
take'' = foldr fLoca (\n -> [])
    where fLoca = ( \x r -> ( \n -> if n <= 0 then [] else x:(r n-1)) ) 

-- elimina la 1ra aparicion de un elemento en la lista
sacarPrimera :: Eq a => a -> [a] -> [a]
sacarPrimera x = foldr (\y r -> (if y == x then r else y:r)) []
sacarPrimera x xs = foldr () [] 