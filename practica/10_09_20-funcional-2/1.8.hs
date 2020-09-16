
-- todas las listas finitas de enteros positivos (mayores o iguales a 1)
listasPositivas :: [[Int]]
listasPositivas = concat [listasQueSuman n | n <- [1..]]
listasPositivas = concatMap listasQueSuman [1..]