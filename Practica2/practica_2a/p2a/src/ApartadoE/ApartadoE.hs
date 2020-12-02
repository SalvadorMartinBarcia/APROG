
module ApartadoE.ApartadoE where
    
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
    
    data Region = Reg [Provincia] String deriving (Show, Read)

    listaReg :: Region -> [Provincia]
    listaReg (Reg x _) = x

    nombreReg :: Region -> String
    nombreReg (Reg _ x) = x
    
    type Regiones = [Region]

    type Mosaico = [[Char]]

    type Frontera = [(Region, [Region])]

    data Mapa = Atlas Regiones Frontera

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

    reg1 :: Region
    reg1 = Reg [prov1,prov2] "reg1"

    reg2 :: Region
    reg2 = Reg [prov3,prov4] "reg2"

    reg3 :: Region
    reg3 = Reg [prov5,prov6,prov7,prov8] "reg3"

    regExtra :: Region
    regExtra = Reg [provExtra, prov4, prov5] "regExtra"

    regs :: Regiones
    regs = [reg1, reg2, reg3]

    regsExtra :: Regiones
    regsExtra = [reg1, regExtra]
    
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

    encontrarFronteras :: Regiones -> [(Region, [Region])]
    encontrarFronteras [] = []
    encontrarFronteras regs0 = encontrarFronterasAux1 regs0 regs0
        where
            encontrarFronterasAux1 [] _ = []
            encontrarFronterasAux1 (x:xs) regs1 = encontrarFronterasAux2 x regs1 : encontrarFronterasAux1 xs regs1
            encontrarFronterasAux2 x1 regs2 = (x1, encontrarFronterasAux3 x1 regs2) -- tupla (Region, [Region]) 
            encontrarFronterasAux3 _ [] = []
            encontrarFronterasAux3 reg (r1:rs) =    if nombreReg reg /= nombreReg r1 && encontrarFronterasAux4 (listaReg reg) (listaReg r1) then
                                                        r1 : encontrarFronterasAux3 reg rs
                                                    else
                                                        encontrarFronterasAux3 reg rs
            encontrarFronterasAux4 [a] b = encontrarFronterasAux5 a b
            encontrarFronterasAux4 (a:as) b = encontrarFronterasAux5 a b || encontrarFronterasAux4 as b
            encontrarFronterasAux5 _ [] = False
            encontrarFronterasAux5 a' (b':bs') = do 
                                            let l1 = [(coordenadaYSup a') .. (coordenadaYInf a')] -- vertical a
                                            let l1' = [(coordenadaYSup b') .. (coordenadaYInf b')] -- vertical b
                                            let l2 = [(coordenadaXSup a') .. (coordenadaXInf a')] -- horizontal a
                                            let l2' = [(coordenadaXSup b') .. (coordenadaXInf b')] -- horizontal b
                                            if ((matches l1 l1') > 0) && ((matches l2 l2') > 0) && (nombre a') /= (nombre b') then
                                                True || encontrarFronterasAux5 a' bs' -- lista de provincias
                                            else
                                                encontrarFronterasAux5 a' bs' -- lista de provincias

    compruebaVecinosRegs :: Regiones -> Bool
    compruebaVecinosRegs [reg] = compruebaVecinos reg
    compruebaVecinosRegs (reg:regs') = compruebaVecinos reg && compruebaVecinosRegs regs'

    compruebaVecinos :: Region -> Bool
    compruebaVecinos reg = aux1 (listaReg reg) (listaReg reg) 
        where
            aux1 [a] b = aux2 a b
            aux1 (a:as) b = aux2 a b && aux1 as b
            aux2 _ [] = False
            aux2 a' (b':bs') = do 
                                    let l1 = [(coordenadaYSup a') .. (coordenadaYInf a')] -- vertical a
                                    let l1' = [(coordenadaYSup b') .. (coordenadaYInf b')] -- vertical b
                                    let l2 = [(coordenadaXSup a') .. (coordenadaXInf a')] -- horizontal a
                                    let l2' = [(coordenadaXSup b') .. (coordenadaXInf b')] -- horizontal b
                                    if ((matches l1 l1') > 0) && ((matches l2 l2') > 0) && (nombre a') /= (nombre b') then
                                        True || aux2 a' bs'
                                    else
                                        aux2 a' bs'
    
    territorio :: Regiones -> [Color] -> Either String Mosaico
    territorio re col = 
        if cuadradosSolapados re || not (compruebaVecinosRegs re) then
            Left ("Error Regiones solapadas")
        else
            Right(
                do
                    let fronteras = encontrarFronteras re
                    let sol = solucionColorear (Atlas re fronteras,col)
                    incluirRegiones mosaicoInicial sol
                )

    cuadradosSolapados :: Regiones -> Bool
    cuadradosSolapados [] = False
    cuadradosSolapados x = cuadradosSolapadosAux1 (provinciasDeRegiones x)
        where
            provinciasDeRegiones [] = []
            provinciasDeRegiones (x':xs) = (listaReg x') ++ (provinciasDeRegiones xs)
            cuadradosSolapadosAux1 provsx = cuadradosSolapadosAux2 provsx provsx
            cuadradosSolapadosAux2 [x'] provs1 = funAux x' provs1
            cuadradosSolapadosAux2 (x':xs) provs1 = funAux x' provs1 || cuadradosSolapadosAux2 xs provs1
            funAux x' [y] = comp x' y
            funAux x' (y:ys) = comp x' y || funAux x' ys
            comp x' y = 
                if nombre x' == nombre y then
                    False
                else 
                    do
                        let lx = creaL (coordenadaXSup x' + 1) (coordenadaXInf x' - 1) (coordenadaYSup x' + 1) (coordenadaYInf x' - 1)
                        let ly = creaL (coordenadaXSup y) (coordenadaXInf y) (coordenadaYSup y) (coordenadaYInf y)
                        matches lx ly > 0
            creaL xSup xInf ySup yInf = [(x'',y) | x'' <- [xSup..xInf], y <- [ySup..yInf]]
    
    
    findKey :: (Eq k) => k -> [(k,v)] -> v  
    findKey key xs = snd . head . filter (\(k,_) -> key == k) $ xs  

    coloresFrontera :: Region->[(Region,Color)]->Frontera-> [Color]
    coloresFrontera provincia coloreado frontera = [col | (prov,col)<- coloreado, elem prov (findKey provincia frontera)]

    coloreados :: (Mapa,[Color]) -> [[(Region,Color)]]
    coloreados ((Atlas [] _), _) = [[]]
    coloreados ((Atlas (reg':regs') frontera), colores') = [(reg',color):coloreado' |
                                        coloreado' <- coloreados ((Atlas regs' frontera), colores')
                                        , color <- colores' \\ (coloresFrontera reg' coloreado' frontera)]

    solucionColorear:: (Mapa,[Color]) -> [(Region,Color)]
    solucionColorear = head . coloreados    
    --------------------------------------------------------------------
    mosaicoInicial :: Mosaico
    mosaicoInicial = replicate 8 (replicate 16 '.')

    dibujarMosaico :: Either String Mosaico -> IO ()
    dibujarMosaico (Right x) = putStr (unlines x)
    dibujarMosaico (Left x) = print x -- Imprimir el error

    incluirRegiones :: Mosaico -> [(Region,Color)] -> Mosaico
    incluirRegiones = foldl incluirRegion

    incluirRegion :: Mosaico -> (Region,Color) -> Mosaico
    incluirRegion m (r, color) = incluirProvincias m [(p, color) | p<-(listaReg r)]

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

    introducirRegiones :: Regiones -> IO ()
    introducirRegiones p2 = do 
                                    putStrLn "Introduce una region:"
                                    region <- getLine
                                    let regionNueva = [(read region)]
                                    let aux = (territorio (p2 ++ regionNueva) colores)
                                    
                                    if isLeft (aux) || not (compruebaVecinosRegs (p2 ++ regionNueva)) then
                                        --Error
                                        do
                                            dibujarMosaico aux
                                            introducirRegiones p2
                                    else 
                                        do
                                            putStrLn "¿Quieres introducir mas regiones?(s/n):"
                                            opcionSN <- getLine
                                            if opcionSN == "s" then
                                                introducirRegiones (p2 ++ regionNueva)
                                            else
                                                introducirColores (p2 ++ regionNueva)

    introducirColores :: Regiones -> IO ()
    introducirColores regs' = do 
                                    putStr "Colores disponibles: "
                                    print (stringColores colores)
                                    putStrLn "Elige la cantidad de colores:"
                                    cant <- getLine
                                    let cantidad = read cant
                                    if cantidad > (length colores) || cantidad <= 0 then
                                        do
                                            print ("Numero de colores no disponible")
                                            introducirColores regs'
                                    else 
                                        do
                                            let colores' = take cantidad colores
                                            dibujarMosaico (territorio regs' colores')

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

    instance Eq Region where
        (==) x y = (nombreReg x) == (nombreReg y)

    mainE :: IO()
    mainE = do
        
        print ("----------------------Ejecucion ApartadoE------------------------------------------")
        print ("Ejemplo con Regiones no solapadas")
        dibujarMosaico (territorio regs colores)

        mostrarSeparador

        print ("Ejemplo con Regiones solapadas")
        dibujarMosaico (territorio regsExtra colores)

        putStrLn "\nQuieres introducir una o más regiones? (s/n)"
        opcion <- getLine

        if opcion == "s" then do
            introducirRegiones regs
        else
            introducirColores regs

    ----------------------Ejecucion ApartadoE------------------------------------------
    -- "Ejemplo con Regiones no solapadas"
    -- ................
    -- ......vv........
    -- .aaaaavvvvvv....
    -- .aaaaavvvvvv....
    -- .aaaaavvvvvvrr..
    -- ....rr..vvvvrr..
    -- ....rrrrrrrrrrrr
    -- ....rrrrrrrr..rr
    -- --------------------
    -- "Ejemplo con Regiones solapadas"
    -- "Error Regiones solapadas"

    -- Quieres introducir una o más regiones? (s/n)
    -- s
    -- Introduce una region:
    -- Reg [Rect 0 0 2 1 "p1", Rect 2 0 5 1 "p2"] "r1" 
    -- ¿Quieres introducir mas regiones?(s/n):
    -- s
    -- Introduce una region:
    -- Reg [Rect 0 0 2 2 "p1", Rect 2 0 5 1 "p2"] "r1"  
    -- "Error Regiones solapadas"
    -- Introduce una region:
    -- Reg [Rect 7 0 9 1 "p3", Rect 9 0 11 1 "p4"] "r2"  
    -- ¿Quieres introducir mas regiones?(s/n):
    -- n
    -- Colores disponibles: "Rojo, Verde, Amarillo, Morado, Lila, Azul"
    -- Elige la cantidad de colores:
    -- 3
    -- ................
    -- .rrrrrvvrrrr....
    -- .aaaaavvvvvv....
    -- .aaaaavvvvvv....
    -- .aaaaavvvvvvrr..
    -- ....rr..vvvvrr..
    -- ....rrrrrrrrrrrr
    -- ....rrrrrrrr..rr
