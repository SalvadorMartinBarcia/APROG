

module ApartadoA.Ejemplos where

    import ApartadoA.Func.Factoriales

    a :: Integer
    a = fact7 5
    b :: Integer
    b = fact8 6

    mainA = do  print ("MAIN A")
                print ("Factorial 5 (fact7) = " ++ show a)
                print ("Factorial 6 (fact8) = " ++ show b)
                print ("Factorial 7 (fact7) = " ++ show (fact7 7))
                print ("Factorial 8 (fact8) = " ++ show (fact8 8))
    -- "MAIN A"
    -- "Factorial 5 (fact7) = 120"
    -- "Factorial 6 (fact8) = 720"
    -- "Factorial 7 (fact7) = 5040"
    -- "Factorial 8 (fact8) = 40320"
    
