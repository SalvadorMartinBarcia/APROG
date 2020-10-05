
module ApartadoL.Func.Factoriales where

    -- función de pliegue
    fact7 :: Integer -> Maybe Integer
    fact7 n = if n >= 0 then Just (foldr (*) 1 [1..n])
                        else Nothing
    

    -- composición de funciones
    fact8 :: Integer -> Maybe Integer
    fact8 x 
        | x >= 0 = Just (product (enumFromTo 1 x))
        | otherwise = Nothing