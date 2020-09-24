

module ApartadoA.Ejemplos where

    import ApartadoA.Func.Factoriales

    a = fact7 5
    b = fact8 6

    main = do   print ("Factorial 5 (fact7) = " ++ show a)
                print ("Factorial 6 (fact8) = " ++ show b)
    
