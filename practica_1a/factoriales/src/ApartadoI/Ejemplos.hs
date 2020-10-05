

module ApartadoI.Ejemplos where

    import ApartadoI.Func.Factoriales

    a :: Integer
    a = fact7 5

    mainI = do  print ("MAIN I")
                print ("Factorial 5 (fact7) = " ++ show a)
                print ("Factorial 7 (fact7) = " ++ show (fact7 7))
    
