{- Final Laura VR telegram -}

data MiDato a b = C1 (MiDato a b) | C2 a | C3 a b deriving Show

foldMiDato :: (c -> c) -> (a -> c) -> (a -> b -> c) -> (MiDato a b) -> c
foldMiDato f g h (C1 x) = f (foldMiDato f g h x)
foldMiDato _ g _ (C2 a) = g a
foldMiDato _ _ h (C3 a b) = h a b

miDatoEx = C1 (C1 (C2 3))
miDatoEx2 = C1 (C1 (C3 3 4))
miDatoEx3 = C2 3

cuenta = foldMiDato (+1) (const 0) (const (const 0))
-- (const . (const 0)) también

