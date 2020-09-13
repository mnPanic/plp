-- 5 - Recursion

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
--quicksort (x:xs) = (quicksort [y | y <- xs, y < x]) ++ [x] ++ (quicksort [y | y <- xs, y >= x])
quicksort (x:xs) = leftSorted ++ [x] ++ rightSorted
    where leftSorted = quicksort $ filter (<x) xs
          rightSorted = quicksort $ filter (>=x) xs
