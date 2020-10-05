
module ApartadoN.Quickcheck where

    import ApartadoN.Funciones
    import Test.QuickCheck
    
    comprobarPrueba :: Integer -> Bool
    comprobarPrueba n = fact7 n == fact8 n &&
                        fact7' n == fact8' n &&
                        fact8 n == fact7' n

    comprobar = quickCheck comprobarPrueba

    mainQC = do     print("QuickCheck:")
                    comprobar