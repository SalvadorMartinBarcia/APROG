
module ApartadoA.ApartadoA where
    
    import Data.List ((\\))
    
    data Color = Rojo | Verde | Azul deriving (Show,Enum,Eq)
    data Provincia = Al | Ca | Co | Gr | Ja | Hu | Ma | Se deriving (Show,Enum,Eq)
    
    type Frontera = Provincia -> [Provincia]
    
    frAndalucia :: Frontera
    frAndalucia Al = [Gr]
    frAndalucia Ca = [Hu,Se,Ma]
    frAndalucia Co = [Se,Ma,Ja,Gr]
    frAndalucia Gr = [Ma,Co,Ja,Al]
    frAndalucia Ja = [Co,Gr]
    frAndalucia Hu = [Ca,Se]
    frAndalucia Ma = [Ca,Se,Co,Gr]
    frAndalucia Se = [Hu,Ca,Ma,Co]
    
    data Mapa = Atlas [Provincia] Frontera

    andalucia :: Mapa
    andalucia = Atlas [Al .. Se] frAndalucia

    -- Colores de provincias vecinas para un coloreado
    coloresFrontera :: Provincia->[(Provincia,Color)]->Frontera-> [Color]
    coloresFrontera provincia coloreado frontera = [col | (prov,col)<- coloreado, elem prov (frontera provincia)]
    
    -- Posibles coloreados para un mapa y una lista de colores
    coloreados :: (Mapa,[Color]) -> [[(Provincia,Color)]]
    coloreados ((Atlas [] _), _) = [[]]
    coloreados ((Atlas (prov:provs) frontera), colores) = [(prov,color):coloreado' |
                                        coloreado' <- coloreados ((Atlas provs frontera), colores)
                                        , color <- colores \\ (coloresFrontera prov coloreado' frontera)]
    
    solucionColorear:: (Mapa,[Color]) -> [(Provincia,Color)]
    solucionColorear = head . coloreados

    sol1 = solucionColorear (andalucia, [Rojo .. Azul]) -- encuentra una solucion
    sol2 = solucionColorear (andalucia, [Rojo,Verde]) -- sin solución

    mainA :: IO()
    mainA = do
        print ("----------------------Ejecucion ApartadoA------------------------------------------")
        print (sol1)
        --print (sol2)

    ----------------------Ejecucion ApartadoA------------------------------------------
    -- [(Al,Verde),(Ca,Azul),(Co,Azul),(Gr,Rojo),(Ja,Verde),(Hu,Verde),(Ma,Verde),(Se,Rojo)]
    -- p2a-exe.EXE: Prelude.head: empty list