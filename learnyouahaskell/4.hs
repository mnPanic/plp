head' :: [a] -> a
head' [] = error "No se puede llamar head de la lista vacia"
head' (x:_) = x

tell :: (Show a) => [a] -> String
tell [] = "Empty"
tell (x:[]) = "One element: " ++ show x
tell (x:y:[]) = "Two elements: " ++ show x ++ " and " ++ show y
tell _ = "This list is too long!"