
module ApartadoB.ApartadoB where
    
    import Data.List
    
    data Provincia = Rect {coordenadaXSup :: Integer, coordenadaYSup :: Integer, 
                            coordenadaXInf :: Integer, coordenadaYInf :: Integer,
                            nombre :: Char}
                            
    data Color = Rojo | Verde | Azul deriving (Show,Enum,Eq)
    
    type Provincias = [Provincia]
    
    type Mosaico = [String]

    type Frontera = [(Provincia, [Provincia])]

    data Mapa = Atlas [Provincia] Frontera


    matches :: Eq a => [a] -> [a] -> Int
    matches xs ys = length (intersect xs ys)

    prov1, prov2, prov3, prov4, prov5, prov6, prov7, prov8 :: Provincia
    prov1 = Rect 1 0 4 2 'H'--------- Huelva
    prov2 = Rect 1 2 4 5 'S'--------- Sevilla
    prov3 = Rect 0 5 4 7 'O'--------- cOrdoba
    prov4 = Rect 1 7 5 11 'J'-------- Jaen
    prov5 = Rect 4 3 7 5 'C'--------- Cadiz
    prov6 = Rect 5 5 7 11 'M'-------- Malaga
    prov7 = Rect 3 11 6 13 'G'------- Granada
    prov8 = Rect 5 13 7 15 'A'------- Almeria

    provs :: Provincias
    provs = [prov1,prov2,prov3,prov4,prov5,prov6,prov7,prov8]
    
    {-
     0123456789012345y
    0......oo........
    1hhhsssoojjjj.... 
    2hhhsssoojjjj...
    3hhhsssoojjjjgg..
    4hhhsssoojjjjgg..
    5...ccc..jjjjggaa
    6...cccmmmmmmggaa
    7...cccmmmmmm..aa
    x
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

    andalucia :: Mapa
    andalucia = Atlas provs (encontrarFronteras provs)

    findKey :: (Eq k) => k -> [(k,v)] -> v  
    findKey key xs = snd . head . filter (\(k,_) -> key == k) $ xs  

    -- Colores de provincias vecinas para un coloreado
    coloresFrontera :: Provincia->[(Provincia,Color)]->Frontera-> [Color]
    coloresFrontera provincia coloreado frontera = [col | (prov,col)<- coloreado, elem prov (findKey provincia frontera)]

    -- coloreados :: Frontera -> Colores -> [[(Provincia,Color)]]
    coloreados :: (Mapa,[Color]) -> [[(Provincia,Color)]]
    coloreados ((Atlas [] _), _) = [[]]
    coloreados ((Atlas (prov:provs2) frontera), colores) = [(prov,color):coloreado' |
                                        coloreado' <- coloreados ((Atlas provs2 frontera), colores)
                                        , color <- colores \\ (coloresFrontera prov coloreado' frontera)]

    solucionColorear:: (Mapa,[Color]) -> [(Provincia,Color)]
    solucionColorear = head . coloreados

    sol3 = solucionColorear (andalucia, [Rojo .. Azul]) -- encuentra una solucion
    
    
    mosaicoInicial :: Mosaico
    mosaicoInicial = replicate 8 (replicate 16 '.')
 
    dibujarMosaico :: Mosaico -> IO ()
    dibujarMosaico = putStr . unlines

    -- incluirProvincias :: Mosaico -> Provincias -> Mosaico
    -- incluirProvincias= foldl incluirProvincia

    -- incluirProvincia :: Mosaico -> Provincia -> Mosaico
    -- incluirProvincia mosaico provincia  = map fila [1..8]
    --     where   fila n = map (letra n) [1..16]
    --             (letra n) m | dentroRectangulo n m provincia = nombre provincia
    --                         | otherwise = mosaico !! (n-1) !! (m-1)

    -- dentroRectangulo :: Int -> Int -> Provincia -> Bool
    -- dentroRectangulo n m cuadrado =
    --     (bordeX cuadrado <= n)  && (n<bordeX cuadrado + ancho cuadrado)
    --     && (bordeY cuadrado <= m) && (m<bordeY cuadrado + ancho cuadrado)

    instance Show Provincia where
        show x = [nombre x]

    instance Eq Provincia where
        (==) x y = (nombre x) == (nombre y)

    mainB = do 
        print (sol3)
        dibujarMosaico mosaicoInicial

    -- Equivalente:         dibujarMosaico mosaico = (putStr . unlines) mosaico
    -- Equivalente:         dibujarMosaico mosaico = putStr . unlines $ mosaico

