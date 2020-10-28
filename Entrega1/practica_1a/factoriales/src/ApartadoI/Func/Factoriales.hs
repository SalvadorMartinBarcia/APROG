
module ApartadoI.Func.Factoriales where

    -- función de pliegue
    fact7 :: Integer -> Integer
    fact7 = fact7'

    fact7' :: Integer -> Integer
    fact7' n = foldr (*) 1 [1..n]

    -- composición de funciones
    fact8 :: Integer -> Integer
    fact8 = product . enumFromTo 1

