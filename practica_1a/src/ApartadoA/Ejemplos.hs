

module ApartadoA.Ejemplos where

    import ApartadoA.Func.Factoriales

    a :: Integer
    a = fact7 5
    b :: Integer
    b = fact8 6

    main = do   print ("Factorial 5 (fact7) = " ++ show a)
                print ("Factorial 6 (fact8) = " ++ show b)
                print ("Factorial 7 (fact7) = " ++ show (fact7 7))
                print ("Factorial 8 (fact8) = " ++ show (fact8 8))
    
