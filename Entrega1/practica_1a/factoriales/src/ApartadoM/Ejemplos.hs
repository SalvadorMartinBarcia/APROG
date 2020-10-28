

module ApartadoM.Ejemplos where

    import ApartadoM.Func.Factoriales

    mainM = do  print ("MAIN M")
                print ("Factorial 5 (fact7) = " ++ show (fact7 5))
                print ("Factorial 6 (fact8) = " ++ show (fact8 6))
                print ("Factorial 7 (fact7) = " ++ show (fact7 7))
                print ("Factorial 8 (fact8) = " ++ show (fact8 8))

    -- "MAIN M"
    -- "Factorial 5 (fact7) = Just 120"
    -- "Factorial 6 (fact8) = Just 720"
    -- "Factorial 7 (fact7) = Just 5040"
    -- "Factorial 8 (fact8) = Just 40320"
    
