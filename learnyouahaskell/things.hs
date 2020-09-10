-- intento de escribir zip
zip' :: [a] -> [b] -> [(a, b)]
zip' [] bs = []
zip' as [] = []
zip' (a:as) (b:bs) = (a, b) : zip' as bs
