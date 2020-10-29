

module ApartadoL.Ejemplos where

    import ApartadoL.Func.Factoriales

    mainL = do  print ("MAIN L")
                print ("Factorial -1 (fact7) = " ++ show (fact7 (-1)))
                print ("Factorial -2 (fact8) = " ++ show (fact7 (-2)))
                print ("Factorial 7 (fact7) = " ++ show (fact7 7))
                print ("Factorial 8 (fact8) = " ++ show (fact8 8))
                
    -- "MAIN L"
    -- "Factorial -1 (fact7) = Nothing"
    -- "Factorial -2 (fact8) = Nothing"
    -- "Factorial 7 (fact7) = Just 5040"
    -- "Factorial 8 (fact8) = Just 40320"
    
