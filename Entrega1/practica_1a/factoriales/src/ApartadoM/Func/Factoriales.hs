
module ApartadoM.Func.Factoriales where

   -- función de pliegue
    fact7 :: (Enum a, Num a, Ord a) => a -> Maybe a
    fact7 n = if n >= 0 then Just (foldr (*) 1 [1..n])
                        else Nothing
    

    -- composición de funciones
    fact8 :: (Num a, Enum a, Ord a) => a -> Maybe a
    fact8 x 
        | x >= 0 = Just (product (enumFromTo 1 x))
        | otherwise = Nothing
