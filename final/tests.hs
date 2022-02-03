data Natural = Zero | Succ Natural

dameNumero :: Natural -> Int
dameNumero Zero = 0
dameNumero (Succ n) = dameNumero n + 1


lonigtud :: [a] -> Int
longitud [] = 0
longitud x:xs = 1 + long xs