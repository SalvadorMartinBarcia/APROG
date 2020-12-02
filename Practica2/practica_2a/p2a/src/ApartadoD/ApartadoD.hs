
module ApartadoD.ApartadoD where
    
    import Data.List
    import Data.Either
    
    data Provincia = Rect Int Int Int Int String deriving (Show, Read)

    coordenadaXSup, coordenadaYSup, coordenadaXInf, coordenadaYInf :: Provincia -> Int
    coordenadaXSup (Rect x _ _ _ _) = x
    coordenadaYSup (Rect _ x _ _ _) = x
    coordenadaXInf (Rect _ _ x _ _) = x
    coordenadaYInf (Rect _ _ _ x _) = x
    
    nombre :: Provincia -> String
    nombre (Rect _ _ _ _ x) = x
    

    data Color = Rojo | Verde | Amarillo | Morado | Lila | Azul deriving (Show,Enum,Eq)
    
    type Provincias = [Provincia]
    
    type Mosaico = [[Char]]

    type Frontera = [(Provincia, [Provincia])]

    data Mapa = Atlas [Provincia] Frontera

    colores :: [Color]
    colores = [Rojo .. Azul]

    showColor :: Color -> Char
    showColor Rojo = 'r'
    showColor Verde = 'v'
    showColor Amarillo = 'a'
    showColor Morado = 'm'
    showColor Lila = 'l'
    showColor Azul = 'v'

    matches :: Eq a => [a] -> [a] -> Int
    matches xs ys = length (intersect xs ys)

    prov1, prov2, prov3, prov4, prov5, prov6, prov7, prov8 :: Provincia
    prov1 = Rect 0 1 2 4 "Huelva"
    prov2 = Rect 2 1 5 4 "Sevilla"
    prov3 = Rect 5 0 7 4 "Cordoba"
    prov4 = Rect 7 1 11 5 "Jaen"
    prov5 = Rect 3 4 5 7 "Cadiz"
    prov6 = Rect 5 5 11 7 "Malaga"
    prov7 = Rect 11 3 13 6 "Granada"
    prov8 = Rect 13 5 15 7 "Almeria"

    provs :: Provincias
    provs = [prov1,prov2,prov3,prov4,prov5,prov6,prov7,prov8]
    
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


    andalucia :: Provincias -> [Color] -> Either String Mosaico
    andalucia provincias colors = if (cuadradosSolapados provincias) then
                    Left "ERROR - Provincias solapadas"
                else
                    Right(do
                            let sol = solucionColorear (Atlas provincias (encontrarFronteras provincias), colors)
                            incluirProvincias mosaicoInicial sol
                        )

    cuadradosSolapados :: Provincias -> Bool
    cuadradosSolapados provsx = cuadradosSolapadosAux provsx provs
        where   cuadradosSolapadosAux [x] provs1 = funAux x provs1
                cuadradosSolapadosAux (x:xs) provs1 = funAux x provs1 || cuadradosSolapadosAux xs provs1
                funAux x [y] = comp x y
                funAux x (y:ys) = comp x y || funAux x ys
                comp x y = 
                    if nombre x == nombre y then
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
    coloreados ((Atlas (prov:provs2) frontera), colores') = [(prov,color):coloreado' |
                                        coloreado' <- coloreados ((Atlas provs2 frontera), colores')
                                        , color <- colores' \\ (coloresFrontera prov coloreado' frontera)]

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

    instance Eq Provincia where
        (==) x y = (nombre x) == (nombre y)
    

    introducirRectangulos :: [Provincia] -> IO ()
    introducirRectangulos p2 = do 
                                    putStrLn "Introduce una provincia:"
                                    provincia <- getLine
                                    let provinciaNueva = [(read provincia)]
                                    let aux = (andalucia (p2 ++ provinciaNueva) [Rojo .. Azul])
                                    
                                    if isLeft (aux) then
                                        --Error
                                        do
                                            dibujarMosaico aux
                                            introducirRectangulos p2
                                    else 
                                        do
                                            putStrLn "¿Quieres introducir mas provincias?(s/n):"
                                            opcionSN <- getLine
                                            if opcionSN == "s" then
                                                introducirRectangulos (p2 ++ provinciaNueva)
                                            else
                                                introducirColores (p2 ++ provinciaNueva)
    introducirColores :: [Provincia] -> IO ()
    introducirColores provs' = do 
                                    putStr "Colores disponibles: "
                                    print (stringColores colores)
                                    putStrLn "Elige la cantidad de colores:"
                                    cant <- getLine
                                    let cantidad = read cant
                                    if cantidad > (length colores) || cantidad <= 0 then
                                        do
                                            print ("Numero de colores no disponible")
                                            introducirColores provs'
                                    else 
                                        do
                                            let colores' = take cantidad colores
                                            dibujarMosaico (andalucia provs' colores')

    printColor :: Color -> String
    printColor Rojo = "Rojo"
    printColor Verde = "Verde"
    printColor Azul = "Azul"
    printColor Amarillo = "Amarillo"
    printColor Lila = "Lila"
    printColor Morado = "Morado"

    stringColores :: [Color] -> String
    stringColores [x] = printColor x
    stringColores (x:xs) = (printColor x) ++ ", " ++ stringColores xs

    mainD :: IO()
    mainD = do
        
        print ("----------------------Ejecucion ApartadoD------------------------------------------")
        print ("Mapa inicial")
        dibujarMosaico (andalucia provs colores)

        putStrLn "\nQuieres introducir una o más provincias? (s/n)"
        opcion <- getLine

        if opcion == "s" then do
            introducirRectangulos provs
        else
            introducirColores provs

    -- "Mapa inicial"
    -- ................
    -- ......rr........
    -- .rraaarraaaa....
    -- .rraaarraaaa....
    -- .rraaarraaaavv..
    -- ....vv..aaaavv..
    -- ....vvrrrrrrvvrr
    -- ....vvrrrrrr..rr

    -- Quieres introducir una o más provincias? (s/n)
    -- s
    -- Introduce una provincia:
    -- Rect 0 0 5 2 "Madrid"        
    -- "ERROR - Provincias solapadas"
    -- Introduce una provincia:
    -- Rect 0 0 5 1 "Madrid"        
    -- ¿Quieres introducir mas provincias?(s/n):
    -- n
    -- Colores disponibles: "Rojo, Verde, Amarillo, Morado, Lila, Azul"
    -- Elige la cantidad de colores:
    -- 3
    -- ................
    -- .rrrrrvv........
    -- .vvaaavvrrrr....
    -- .vvaaavvrrrr....
    -- .vvaaavvrrrrvv..
    -- ....rr..rrrrvv..
    -- ....rraaaaaavvrr
    -- ....rraaaaaa..rr

    -- Otro ejemplo de ejecucion
    
    -- "Mapa inicial"
    -- ................
    -- ......rr........
    -- .rraaarraaaa....
    -- .rraaarraaaa....
    -- .rraaarraaaavv..
    -- ....vv..aaaavv..
    -- ....vvrrrrrrvvrr
    -- ....vvrrrrrr..rr

    -- Quieres introducir una o más provincias? (s/n)
    -- s
    -- Introduce una provincia:
    -- Rect 0 0 5 1 "Madrid"
    -- ¿Quieres introducir mas provincias?(s/n):

    -- Colores disponibles: "Rojo, Verde, Amarillo, Morado, Lila, Azul"
    -- Elige la cantidad de colores:
    -- 2
    -- p2a-exe.EXE: Prelude.head: empty list