foldNat :: a -> (a -> a) -> Integer -> a
foldNat caso0 casoSuc n | n == 0 = caso0
      | n > 0 = casoSuc (foldNat caso0 casoSuc (n-1))
      | otherwise = error "El argumento de foldNat no puede ser negativo."
