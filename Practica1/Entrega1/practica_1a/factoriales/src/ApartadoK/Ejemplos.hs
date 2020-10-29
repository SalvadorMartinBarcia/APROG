

module ApartadoK.Ejemplos where

    import ApartadoK.Func.Factoriales

    b :: Integer
    b = fact8 6

    mainK = do  print ("MAIN K")
                print ("Factorial 6 (fact8) = " ++ show b)
                print ("Factorial 8 (fact8) = " ++ show (fact8 8))

    -- "MAIN K"
    -- "Factorial 6 (fact8) = 720"
    -- "Factorial 8 (fact8) = 40320"
    
