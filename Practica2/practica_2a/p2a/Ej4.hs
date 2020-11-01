module Ej4 where

data Cuadrado = Cuad {bordeX::Int, bordeY::Int, ancho::Int, color::Char}
    deriving (Read, Show)
type Cuadrados=[Cuadrado]
type Mosaico = [String]

-- Suponemos todas las cadenas de la misma longitud (maximo)
maximo :: Int
maximo=10

mosaicoInicial :: Mosaico
mosaicoInicial = replicate maximo (replicate maximo '.')

cuad1, cuad2, cuad3 :: Cuadrado
cuad1=Cuad 2 3 2 'a'
cuad2=Cuad 1 5 2 'b'
cuad3=Cuad {bordeX=4, bordeY=2, ancho=3, color='c'} -- "record syntax"

cuads :: [Cuadrado]
cuads=[cuad1,cuad2,cuad3]

incluirCuadrados :: Mosaico -> [Cuadrado] -> Mosaico
incluirCuadrados= foldl incluirCuadrado  -- incluirCuadrado es la funcion de pliegue
-- Equivalente (aunque menos compacto, sin usar "pointfree style"):
--     incluirCuadrados mosaico cuadrados = foldl incluirCuadrado mosaico cuadrados

-- Superpone el cuadrado en las posiciones del mosaico
incluirCuadrado :: Mosaico -> Cuadrado -> Mosaico
incluirCuadrado mosaico cuadrado  = map fila [1..maximo]
        where fila n = map (letra n) [1..maximo]
              (letra n) m | dentroCuadrado n m cuadrado = color cuadrado
                          | otherwise = mosaico !! (n-1) !! (m-1)

dentroCuadrado :: Int -> Int -> Cuadrado -> Bool
dentroCuadrado n m cuadrado =
        (bordeX cuadrado <= n)  && (n<bordeX cuadrado + ancho cuadrado)
        && (bordeY cuadrado <= m) && (m<bordeY cuadrado + ancho cuadrado)

-- Equivalente a dentroCuadrado. Es más expresiva, aunque más ineficiente.
dentroCuadrado' :: Int -> Int -> Cuadrado -> Bool
dentroCuadrado' n m cuadrado = n `elem` [borX .. borX+an-1] && m `elem` [borY .. borY+an-1]
        where borX = bordeX cuadrado
              borY = bordeY cuadrado
              an = ancho cuadrado

-- Equivalente a incluirCuadrado, pero utilizando dentroCuadrado como "closure", en lugar de llamar a función
-- externa "dentroCuadrado". Un closure es una función que utiliza parámetros externos a la funcion.
-- Es un concepto recurrente en PF. En este caso utiliza a "cuadrado".
incluirCuadrado' :: Mosaico -> Cuadrado -> Mosaico
incluirCuadrado' mosaico cuadrado  = map fila [1..maximo]
        where fila n = map (letra n) [1..maximo]
              (letra n) m | dentroCuadrado n m = color cuadrado
                          | otherwise = (mosaico !! (n-1)) !! (m-1)
                  where dentroCuadrado n m = (bordeX cuadrado <= n)  && (n<bordeX cuadrado + ancho cuadrado)
                                          && (bordeY cuadrado <= m) && (m<bordeY cuadrado + ancho cuadrado)

-- Equivalente también a incluirCuadrado, pero utilizando dentroCuadrado como otro "closure". Los parámetros
-- externos son "n,m,cuadrado"
incluirCuadrado'' :: Mosaico -> Cuadrado -> Mosaico
incluirCuadrado'' mosaico cuadrado  = map fila [1..maximo]
        where fila n = map (letra n) [1..maximo]
              (letra n) m | dentroCuadrado = color cuadrado
                          | otherwise = (mosaico !! (n-1)) !! (m-1)
                        where dentroCuadrado = (bordeX cuadrado <= n)  && (n<bordeX cuadrado + ancho cuadrado)
                                               && (bordeY cuadrado <= m) && (m<bordeY cuadrado + ancho cuadrado)

-- Equivalente usando listas por comprensión y closures
incluirCuadrado''' :: Mosaico -> Cuadrado -> Mosaico
incluirCuadrado''' mosaico cuadrado = [fila n | n<-[1..maximo]]
        where fila n = [letra n m | m<-[1..maximo]]
                where letra n m | dentroCuadrado n m = color cuadrado
                                | otherwise = (mosaico !! (n-1)) !! (m-1)
                      dentroCuadrado n m = (bordeX cuadrado <= n)  && (n<bordeX cuadrado + ancho cuadrado)
                                           && (bordeY cuadrado <= m) && (m<bordeY cuadrado + ancho cuadrado)

-- También equivalente usando listas por comprensión y "let" en lugar de "where".
-- ¡¡¡Los ámbitos de las variables son diferentes!!!
incluirCuadrado'''' :: Mosaico -> Cuadrado -> Mosaico
incluirCuadrado'''' mosaico cuadrado = [fila n | n<-[1..maximo]]
        where fila n = [letra | m<-[1..maximo],
                        let letra | dentroCuadrado = color cuadrado
                                  | otherwise = (mosaico !! (n-1)) !! (m-1)
                            dentroCuadrado = (bordeX cuadrado <= n)  && (n<bordeX cuadrado + ancho cuadrado)
                                             && (bordeY cuadrado <= m) && (m<bordeY cuadrado + ancho cuadrado)]

-- Equivalente usando una lista de comprensión con 2 generadores (todo es MÁS CLARO Y CONCISO)
incluirCuadrado''''' :: Mosaico -> Cuadrado -> Mosaico
incluirCuadrado''''' mosaico cuadrado  =
        lines [letraResultado |
                        (fila,nFila)<-zip mosaico [1..],
                        (letra, nColumna)<- zip (fila ++ "\n") [1..],   -- Recogemos un salto de línea en cada línea
                        let letraResultado | dentroCuadrado nFila nColumna cuadrado = color cuadrado
                                           | otherwise                              = letra]

girarHorizontal :: Mosaico->Mosaico
girarHorizontal = map reverse -- pointfree
-- Equivalente:       girarHorizontal mosaico = map reverse mosaico

girarVertical :: Mosaico->Mosaico
girarVertical = reverse -- pointfree
-- Equivalente:       girarVertical mosaico = reverse mosaico

dibujarMosaico :: Mosaico -> IO ()
dibujarMosaico = putStr . unlines -- pointfree
-- Equivalente:         dibujarMosaico mosaico = (putStr . unlines) mosaico
-- Equivalente:         dibujarMosaico mosaico = putStr . unlines $ mosaico

mostrarSeparador :: IO ()
mostrarSeparador = putStrLn $ replicate 20 '-'

main4 :: IO ()
main4 = do dibujarMosaico mosaicoInicial
           let mosaico1=incluirCuadrado mosaicoInicial cuad1
           mostrarSeparador
           dibujarMosaico mosaico1
           mostrarSeparador
           dibujarMosaico $ incluirCuadrados mosaicoInicial cuads
           mostrarSeparador
           dibujarMosaico $ girarHorizontal mosaico1
           mostrarSeparador
           dibujarMosaico $ girarVertical mosaico1

{-- RESULTADO DEL PROGRAMA:
*Ej4> main4
..........
..........
..........
..........
..........
..........
..........
..........
..........
..........
--------------------
..........
..aa......
..aa......
..........
..........
..........
..........
..........
..........
..........
--------------------
....bb....
..aabb....
..aa......
.ccc......
.ccc......
.ccc......
..........
..........
..........
..........
--------------------
..........
......aa..
......aa..
..........
..........
..........
..........
..........
..........
..........
--------------------
..........
..........
..........
..........
..........
..........
..........
..aa......
..aa......
..........
*Ej4>
--}
