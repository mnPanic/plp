data RoseTree a = Rose a [RoseTree a] deriving Show
-- deriving Show para poder llevarlo a la terminal

-- 1. recursion estructural


altura :: RoseTree a -> Int
altura (Rose x rs) = 1 + maximum (map altura rs)

-- para saber el tipo del fold, mirar el tipo de datos algebraico, como esta
-- definido, cuales son los constructores y que parametros tienen.
foldRose :: (a -> [b] -> b) -> RoseTree a -> b
foldRose f (Rose x rs) = f x (map (foldRose f) rs)

altura = foldRose (\_ rs -> 1 + maximum rs)