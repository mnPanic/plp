-- [1, 1, 3] `elem` (listasQueSuman 5) deberia ser true
-- No alcanza con el paso anterior, necesito mas que eso (recursion global)
listasQueSuman :: Int -> [[Int]]
listasQueSuman 0 = [[]]
-- tiene mal el tipo de salida, porque listasQueSuman k devuelve una lista de
-- listas. Por lo tanto el tipo de retorno es una lista de lista de listas.
-- listasQueSuman n = [ map ((n-k):) listasQueSuman k | k <- [0 .. n-1] ]
-- Se soluciona usando concat para concatenar todas juntas
listasQueSuman n = concat [ map ((n-k):) listasQueSuman k | k <- [0 .. n-1] ]
listasQueSuman n = foldr (++) [] [ map ((n-k):) listasQueSuman k | k <- [0 .. n-1] ]
