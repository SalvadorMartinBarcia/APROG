
module ApartadoB.ApartadoB where
    
    import Data.List
    
    data Provincia = Rect {coordenadaXSup :: Integer, coordenadaYSup :: Integer, 
                            coordenadaXInf :: Integer, coordenadaYInf :: Integer,
                            nombre :: String}
                            
    
    data Color = Rojo | Verde | Azul deriving (Show,Enum,Eq)
    
    
    type Provincias = [Provincia]
    type Mosaico = [String]

    matches :: Eq a => [a] -> [a] -> Int
    matches xs ys = length (intersect xs ys)

    prov1, prov2, prov3, prov4, prov5, prov6, prov7, prov8 :: Provincia
    prov1 = Rect 1 0 4 2 "H"---------
    prov2 = Rect 1 2 4 5 "S"---------
    prov3 = Rect 0 5 4 7 "O"---------
    prov4 = Rect 1 7 5 11 "J"--------
    prov5 = Rect 4 3 7 5 "C"---------
    prov6 = Rect 5 5 7 11 "M"--------
    prov7 = Rect 3 11 6 13 "G"-------
    prov8 = Rect 5 13 7 15 "A"-------

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

    -- maximoX :: Int
    -- maximoX=8
    -- maximoY :: Int
    -- maximoY=16


    encontrarFronteras :: [Provincia] -> [(Provincia, [Provincia])]
    encontrarFronteras [] = []
    encontrarFronteras provs = encontrarFronterasAux1 provs provs
        where
            encontrarFronterasAux1 [] _ = []
            encontrarFronterasAux1 (x:xs) provs1 = encontrarFronterasAux2 x provs1 : encontrarFronterasAux1 xs provs1
            encontrarFronterasAux2 x1 provs2 = (x1, encontrarFronterasAux3 x1 provs2)
            encontrarFronterasAux3 a [] = []
            encontrarFronterasAux3 a (b:bs) = do 
                                            let l1 = [(coordenadaYSup a) .. (coordenadaYInf a)]
                                            let l1' = [(coordenadaYSup b) .. (coordenadaYInf b)]
                                            let l2 = [(coordenadaXSup a) .. (coordenadaXInf a)]
                                            let l2' = [(coordenadaXSup b) .. (coordenadaXInf b)]
                                            if ((matches l1 l1') > 0) && ((matches l2 l2') > 0) && (nombre a) /= (nombre b) then
                                                b :encontrarFronterasAux3 a bs
                                            else
                                                encontrarFronterasAux3 a bs

    provs :: Provincias
    provs = [prov1,prov2,prov3,prov4,prov5,prov6,prov7,prov8]

    -- mosaicoInicial :: Mosaico
    -- mosaicoInicial = replicate maximoX (replicate maximoY '.')
 
    -- dibujarMosaico :: Mosaico -> IO ()
    -- dibujarMosaico = putStr . unlines

    -- incluirProvincias :: Mosaico -> Provincias -> Mosaico
    -- incluirProvincias= foldl incluirProvincia

    -- incluirProvincia :: Mosaico -> Provincia -> Mosaico
    -- incluirProvincia mosaico provincia  = map fila [1..maximoX]
    --     where   fila n = map (letra n) [1..maximoY]
    --             (letra n) m | dentroRectangulo n m provincia = nombre provincia
    --                         | otherwise = mosaico !! (n-1) !! (m-1)

    -- dentroRectangulo :: Int -> Int -> Provincia -> Bool
    -- dentroRectangulo n m cuadrado =
    --     (bordeX cuadrado <= n)  && (n<bordeX cuadrado + ancho cuadrado)
    --     && (bordeY cuadrado <= m) && (m<bordeY cuadrado + ancho cuadrado)

    instance Show Provincia where
        show x = nombre x

    mainB = do 
        print(encontrarFronteras provs)

    -- Equivalente:         dibujarMosaico mosaico = (putStr . unlines) mosaico
    -- Equivalente:         dibujarMosaico mosaico = putStr . unlines $ mosaico

    -- -- Colores de provincias vecinas para un coloreado
    -- coloresFrontera :: Provincia->[(Provincia,Color)]->Frontera-> [Color]
    -- coloresFrontera provincia coloreado frontera = [col | (prov,col)<- coloreado, elem prov (frontera provincia)]
    
    -- -- Posibles coloreados para un mapa y una lista de colores
    -- coloreados :: (Mapa,[Color]) -> [[(Provincia,Color)]]
    -- coloreados ((Atlas [] _), _) = [[]]
    -- coloreados ((Atlas (prov:provs) frontera), colores) = [(prov,color):coloreado' |
    --                                     coloreado' <- coloreados ((Atlas provs frontera), colores)
    --                                     , color <- colores \\ (coloresFrontera prov coloreado' frontera)]
    
    -- solucionColorear:: (Mapa,[Color]) -> [(Provincia,Color)]
    -- solucionColorear = head . coloreados
    -- sol1 = solucionColorear (andalucia, [Rojo .. Azul]) -- encuentra una solucion
    -- sol2 = solucionColorear (andalucia, [Rojo,Verde]) -- sin solución

    {-
    Dudas:
        - b) sacar las fronteras desde la lista provs
        de provincias(mapa)
        - apartado c: suponemos que no se pueden predefinir las fronteras
        
    -}