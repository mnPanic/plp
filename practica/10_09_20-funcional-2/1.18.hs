data Polinomio
    | a = X
    | Cte a
    | Suma (Polinomio a) (Polinomio a)
    | Prod (Polinomio a) (Polinomio a)
    deriving Show -- para que sepa como dibujarlo

-- Definir el esquema de recursion estructural (fold)

poli :: Polinomio Integer
poli = Suma (Cte 0) (Prod X X)

evaluar :: Num a => Polinomio a -> a -> a
evaluar X n = n
evaluar (Cte c) _ = c
evaluar (Suma p1 p2) n = (evaluar p1 n) + (evaluar p2 n)
evaluar (Prod p1 p2) n = (evaluar p1 n) * (evaluar p2 n)

-- si hicieramos otras funciones, seria muy parecido. Entonces al darse cuenta
-- de que son todas iguales, convendria abstraer.

foldPoli ::
    b -> -- por x
    (a -> b) -> -- por Cte x
    (b -> b -> b) -> -- por Suma p1 p2
    (b -> b -> b) -> -- por Prod p1 p2
    Polinomio a -> b

foldPoli fX fC fS fP X = fX
foldPoli fX fC fS fP (Cte c) = fC c
foldPoli fX fC fS fP (Suma p1 p2) = fS (rec p1) (rec p2)
    where rec = foldPoli fX fC fS fP
foldPoli fX fC fS fP (Prod p1 p2) = fP (rec p1) (rec p2)
    where rec = foldPoli fX fC fS fP

-- otra forma
foldPoli cX fC fS fP p = case p of
    X -> cX
    (Cte c) = fC c
    (Suma p1 p2) = fS (rec p1) (rec p2)
    (Prod p1 p2) = fP (rec p1) (rec p2)
        where rec = foldPoli fX fC fS fP


evaluar n = foldPoli n (\c -> c) (\recI recD -> recI + recD) (\recI recD -> recI * recD)
evaluar n = foldPoli n id (+) (*)