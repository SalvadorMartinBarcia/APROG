
module ApartadoC.ApartadoC where
    
    import Data.List
    import Data.Either
    
    data Provincia = Rect {coordenadaXSup :: Int, coordenadaYSup :: Int, 
                            coordenadaXInf :: Int, coordenadaYInf :: Int,
                            nombre :: String}
                            
    data Color = Rojo | Verde | Azul deriving (Show,Enum,Eq)
    
    type Provincias = [Provincia]
    
    type Mosaico = [[Char]]

    type Frontera = [(Provincia, [Provincia])]

    data Mapa = Atlas [Provincia] Frontera

    showColor :: Color -> Char
    showColor Rojo = 'r'
    showColor Azul = 'a'
    showColor Verde = 'v'
    
    matches :: Eq a => [a] -> [a] -> Int
    matches xs ys = length (intersect xs ys)

    prov1, prov2, prov3, prov4, prov5, prov6, prov7, prov8, provExtra :: Provincia
    prov1 = Rect 0 1 2 4 "Huelva"
    prov2 = Rect 2 1 5 4 "Sevilla"
    prov3 = Rect 5 0 7 4 "Cordoba"
    prov4 = Rect 7 1 11 5 "Jaen"
    prov5 = Rect 3 4 5 7 "Cadiz"
    prov6 = Rect 5 5 11 7 "Malaga"
    prov7 = Rect 11 3 13 6 "Granada"
    prov8 = Rect 13 5 15 7 "Almeria"
    provExtra = Rect 1 1 5 4 "Sevilla"

    provs :: Provincias
    provs = [prov1,prov2,prov3,prov4,prov5,prov6,prov7,prov8]

    provsSolapadas :: Provincias
    provsSolapadas = [prov1, provExtra]
    
    {-
     0123456789012345x
    0................
    1......oo........ 
    2.hhsssoojjjj....
    3.hhsssoojjjj....
    4.hhsssoojjjjgg..
    5...ccc..jjjjgg..
    6...cccmmmmmmggaa
    7...cccmmmmmm..aa
    y
    -}

    {-  
    ................
    ......rr........
    .rraaarraaaa....
    .rraaarraaaa....
    .rraaarraaaavv..
    ....vv..aaaavv..
    ....vvrrrrrrvvrr
    ....vvrrrrrr..rr
    -}

    encontrarFronteras :: [Provincia] -> [(Provincia, [Provincia])]
    encontrarFronteras [] = []
    encontrarFronteras provs0 = encontrarFronterasAux1 provs0 provs0
        where
            encontrarFronterasAux1 [] _ = []
            encontrarFronterasAux1 (x:xs) provs1 = encontrarFronterasAux2 x provs1 : encontrarFronterasAux1 xs provs1
            encontrarFronterasAux2 x1 provs2 = (x1, encontrarFronterasAux3 x1 provs2)
            encontrarFronterasAux3 _ [] = []
            encontrarFronterasAux3 a (b:bs) = do 
                                            let l1 = [(coordenadaYSup a) .. (coordenadaYInf a)]
                                            let l1' = [(coordenadaYSup b) .. (coordenadaYInf b)]
                                            let l2 = [(coordenadaXSup a) .. (coordenadaXInf a)]
                                            let l2' = [(coordenadaXSup b) .. (coordenadaXInf b)]
                                            if ((matches l1 l1') > 0) && ((matches l2 l2') > 0) && (nombre a) /= (nombre b) then
                                                b :encontrarFronterasAux3 a bs
                                            else
                                                encontrarFronterasAux3 a bs
    
    andalucia :: Provincias -> Either String Mosaico
    andalucia provincias = if (cuadradosSolapados provincias) then
                    Left "ERROR - Provincias solapadas"
                else
                    Right(do
                            let sol = solucionColorear (Atlas provincias (encontrarFronteras provincias), [Rojo .. Azul])
                            incluirProvincias mosaicoInicial sol
                        )

    cuadradosSolapados :: Provincias -> Bool
    cuadradosSolapados provsx = cuadradosSolapadosAux provsx provs
        where   cuadradosSolapadosAux [x] provs1 = funAux x provs1
                cuadradosSolapadosAux (x:xs) provs1 = funAux x provs1 || cuadradosSolapadosAux xs provs1
                funAux x [y] = comp x y
                funAux x (y:ys) = comp x y || funAux x ys
                comp x y = 
                    if x == y then
                        False
                    else 
                        do
                            let lx = creaL (coordenadaXSup x + 1) (coordenadaXInf x - 1) (coordenadaYSup x + 1) (coordenadaYInf x - 1)
                            let ly = creaL (coordenadaXSup y) (coordenadaXInf y) (coordenadaYSup y) (coordenadaYInf y)
                            matches lx ly > 0
                creaL xSup xInf ySup yInf = [(x,y) | x <- [xSup..xInf], y <- [ySup..yInf]]
    
    
    findKey :: (Eq k) => k -> [(k,v)] -> v  
    findKey key xs = snd . head . filter (\(k,_) -> key == k) $ xs  

    coloresFrontera :: Provincia->[(Provincia,Color)]->Frontera-> [Color]
    coloresFrontera provincia coloreado frontera = [col | (prov,col)<- coloreado, elem prov (findKey provincia frontera)]

    coloreados :: (Mapa,[Color]) -> [[(Provincia,Color)]]
    coloreados ((Atlas [] _), _) = [[]]
    coloreados ((Atlas (prov:provs2) frontera), colores) = [(prov,color):coloreado' |
                                        coloreado' <- coloreados ((Atlas provs2 frontera), colores)
                                        , color <- colores \\ (coloresFrontera prov coloreado' frontera)]

    solucionColorear:: (Mapa,[Color]) -> [(Provincia,Color)]
    solucionColorear = head . coloreados    
    
    mosaicoInicial :: Mosaico
    mosaicoInicial = replicate 8 (replicate 16 '.')
 
    dibujarMosaico :: (Either String Mosaico) -> IO ()
    dibujarMosaico (Right x) = putStr (unlines x)
    dibujarMosaico (Left x) = print x -- Imprimir el error

    incluirProvincias :: Mosaico -> [(Provincia,Color)] -> Mosaico
    incluirProvincias = foldl incluirProvincia

    incluirProvincia :: Mosaico -> (Provincia,Color) -> Mosaico
    incluirProvincia mosaico (p,c)  = map fila [0..7]
        where   fila n = map (letra n) [0..15]
                (letra n) m | dentroRectangulo n m p = showColor c
                            | otherwise = mosaico !! n !! m

    dentroRectangulo :: Int -> Int -> Provincia -> Bool
    dentroRectangulo n m cuadrado =
        (n >= (coordenadaYSup cuadrado + 1)) && (n <= (coordenadaYInf cuadrado)) &&
        (m >= (coordenadaXSup cuadrado + 1)) && (m <= (coordenadaXInf cuadrado))

    mostrarSeparador :: IO ()
    mostrarSeparador = putStrLn $ replicate 20 '-'

    instance Show Provincia where
        show x = nombre x

    instance Eq Provincia where
        (==) x y = (nombre x) == (nombre y)

    mainC :: IO()
    mainC = do

        print ("----------------------Ejecucion ApartadoC------------------------------------------")
        print ("Ejemplo con provincias no solapadas")
        dibujarMosaico (andalucia provs)
        mostrarSeparador
        print ("Ejemplo con provincias solapadas")
        dibujarMosaico (andalucia provsSolapadas)

    ----------------------Ejecucion ApartadoC------------------------------------------
    -- "Ejemplo con provincias no solapadas"
    -- ................
    -- ......rr........
    -- .rraaarraaaa....
    -- .rraaarraaaa....
    -- .rraaarraaaavv..
    -- ....vv..aaaavv..
    -- ....vvrrrrrrvvrr
    -- ....vvrrrrrr..rr
    -- --------------------
    -- "Ejemplo con provincias solapadas"
    -- "ERROR - Provincias solapadas"
