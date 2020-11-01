
module ApartadoB.ApartadoB where
    
    import Data.List ((\\))
    
    data Provincia = Rect {coordenadaXSup :: Integer, coordenadaYSup :: Integer, 
                            coordenadaXInf :: Integer, coordenadaYInf :: Integer,
                            nombre :: String}
                            
    
    data Color = Rojo | Verde | Azul deriving (Show,Enum,Eq)
    
    
    type Provincias = [Provincia]
    type Mosaico = [String]

    prov1, prov2, prov3, prov4, prov5, prov6, prov7, prov8 :: Provincia
    prov1 = Rect 1 0 4 2 "Hu" 
    prov2 = Rect 1 3 4 5 "Se"
    prov3 = Rect 0 6 4 7 "Co"
    prov4 = Rect 1 8 5 11 "Ja"
    prov5 = Rect 5 3 7 5 "Ca"
    prov6 = Rect 6 6 7 11 "Ma"
    prov7 = Rect 3 12 6 13 "Gr"
    prov8 = Rect 5 14 7 15 "Al"

    {-
     0123456789012345
    0......cc........
    1hhhsssccjjjj....
    2hhhsssccjjjj....
    3hhhsssccjjjjgg..
    4hhhsssccjjjjgg..
    5...ccc..jjjjggaa
    6...cccmmmmmmggaa
    7...cccmmmmmm..aa
    -}

    provs :: Provincias
    provs = [prov1,prov2,prov3,prov4,prov5,prov6,prov7,prov8]

    maximoX :: Int
    maximoX=8
    maximoY :: Int
    maximoY=16

    mosaicoInicial :: Mosaico
    mosaicoInicial = replicate maximoX (replicate maximoY '.')
 
    dibujarMosaico :: Mosaico -> IO ()
    dibujarMosaico = putStr . unlines

    incluirProvincias :: Mosaico -> Provincias -> Mosaico
    incluirProvincias= foldl incluirProvincia

    incluirProvincia :: Mosaico -> Provincia -> Mosaico
    incluirProvincia mosaico provincia  = map fila [1..maximoX]
        where   fila n = map (letra n) [1..maximoY]
                (letra n) m | dentroRectangulo n m provincia = color provincia
                            | otherwise = mosaico !! (n-1) !! (m-1)

    dentroRectangulo :: Int -> Int -> Provincia -> Bool
    dentroRectangulo n m cuadrado =
        (bordeX cuadrado <= n)  && (n<bordeX cuadrado + ancho cuadrado)
        && (bordeY cuadrado <= m) && (m<bordeY cuadrado + ancho cuadrado)


    mainB = do 
        print ()
        print()

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