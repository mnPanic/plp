type Conj a = a -> Bool

vacio :: Conj a
-- vacio = (\x -> False)
-- vacio _ = False
-- 
vacio = const False

agregar :: Eq a => a -> Conj a -> Conj a
agregar x c = \y -> (c y) || (y == x)

interseccion :: Conj a -> Conj a -> Conj a
interseccion c1 c2 = \x (c1 x) && (c2 x)

union :: Conj a -> Conj a -> Conj a
union c1 c2 = \x (c1 x) || (c2 x)

--

-- inf :: Conj (a -> b)
-- tarea

