
{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}

module ApartadoG.ApartadoG where
                                        
    data Arbol a = Arb a [Arbol a]
    data Factura = Factura {ventas :: Arbol Venta}
    data Venta =    VentaUnitaria {articulo :: Articulo} | 
                    Venta {articulo :: Articulo, cantidad :: Int} |
                    (:+) {articulo :: Articulo, cantidad :: Int}
    data Articulo = Articulo {nid :: Int, nombre :: [Char], precio :: Float}

    -- getter de cantidad independientemente del tipo de venta que sea
    cantidadVenta :: Venta -> Int
    cantidadVenta (Venta _ c) = c
    cantidadVenta (VentaUnitaria _) = 1
    cantidadVenta ((:+) _ c) = c

    -- precio de una venta
    precioVenta :: Venta -> Float
    precioVenta (Venta x y) = precio x * (fromIntegral y)
    precioVenta ((:+) x y) = precio x * (fromIntegral y)
    precioVenta (VentaUnitaria x) = precio x
    
    getVenta :: Arbol a -> a
    getVenta (Arb a _) = a

    getArbol :: Arbol c -> [Arbol c]
    getArbol (Arb _ b) = b

    precioFactura :: Factura -> Float
    precioFactura x = precioFacturaux (getVenta (ventas x)) (getArbol (ventas x))
        where   precioFacturaux v [] = precioVenta v
                precioFacturaux v [x1] = precioVenta v + precioFacturaux (getVenta x1) (getArbol x1)
    

    -- fusión de 2 facturas
    fusion2Facturas :: Factura -> Factura -> Factura
    fusion2Facturas x y = Factura (fusion2Facturasaux (getVenta (ventas x)) (getArbol (ventas x)) (ventas y))
        where   fusion2Facturasaux vx [] y1 = Arb vx [y1]
                fusion2Facturasaux vx [ax] y1 = Arb vx [(fusion2Facturasaux (getVenta ax) (getArbol ax) y1)]

    -- precio total de un artículo en una factura
    precArtFact :: Articulo -> Factura -> Float
    precArtFact art x = precArtFactaux art (getVenta (ventas x)) (getArbol (ventas x))
        where   precArtFactaux  art1 v [] =     if nid art1 == (nid (articulo v)) then
                                                    precioVenta v 
                                                else 0
                precArtFactaux  art1 v [ay] =   if nid art1 == (nid (articulo v)) then
                                                    precioVenta v + (precArtFactaux art1 (getVenta ay) (getArbol ay))
                                                else 
                                                    precArtFactaux art1 (getVenta ay) (getArbol ay)

    -- conversión a cadena de un artículo
    instance Show Articulo where
        show x = show (nombre x)
    
    convCadenaArticulo :: Articulo -> [Char]
    convCadenaArticulo x = show x
    
    -- conversión a cadena de una venta
    instance Show Venta where
        show (VentaUnitaria x) = "VentaUnitaria " ++ show x
        show (Venta x y) = "Venta " ++ show x++" " ++ show y
        show ((:+) x y) = "Venta " ++ show x ++ " " ++ show y
    
    convCadenaVenta :: Venta -> [Char]
    convCadenaVenta x = show x

    instance Show Factura where
        show x = "{" ++ imp (getVenta (ventas x)) (getArbol (ventas x))
            where   imp v [] = show v ++ "}"
                    imp v [a] = show v ++ ", " ++ imp (getVenta a) (getArbol a)
    
    convCadenaFactura :: Factura -> [Char]
    convCadenaFactura x = show x

    creaArbol :: [Venta] -> Arbol Venta
    creaArbol [v] = Arb v []
    creaArbol (v:vs) = Arb v [creaArbol vs]

    -- -- búsqueda en una factura de las ventas relativas a un artículo
    busquedaDeVentas1 :: Factura -> Articulo -> Factura
    busquedaDeVentas1 x art = Factura (creaArbol (busquedaDeVentas1aux art (getVenta (ventas x)) (getArbol (ventas x))))
        where   busquedaDeVentas1aux art1 v [] =     if (nid (articulo v)) == (nid art1) then
                                                        [v]
                                                    else
                                                        []
                busquedaDeVentas1aux art1 v [a2] =   if (nid (articulo v)) == (nid art1) then
                                                        v : busquedaDeVentas1aux art1 (getVenta a2) (getArbol a2)
                                                    else
                                                        busquedaDeVentas1aux art1 (getVenta a2) (getArbol a2)
    
    -- búsqueda en una factura de las ventas relativas a una lista de artículos
    busquedaDeVentas2 :: Factura -> [Articulo] -> Factura
    busquedaDeVentas2 fact art = busquedaDeVentas2aux fact art
        where   busquedaDeVentas2aux f1 [a] = busquedaDeVentas1 f1 a
                busquedaDeVentas2aux f1 (a:as) = fusion2Facturas (busquedaDeVentas1 f1 a) (busquedaDeVentas2aux f1 as)

    -- eliminación en una factura de las ventas relativas a un determinado artículo
    elim1 :: Factura -> Articulo -> Factura
    elim1 fact art = Factura (creaArbol (elim1Aux (getVenta (ventas fact)) (getArbol (ventas fact)) art))
        where   elim1Aux v [] art2 =     if (nid (articulo v)) == (nid art2) then
                                            []
                                        else
                                            [v]
                elim1Aux v [v2] art2 =   if (nid (articulo v)) == (nid art2) then
                                            elim1Aux (getVenta v2) (getArbol v2) art2
                                        else
                                            v : elim1Aux (getVenta v2) (getArbol v2) art2
    
    -- eliminación en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada
    elim2 :: Factura -> Int -> Factura
    elim2 x cantidad2 = Factura (creaArbol (elim2aux (getVenta (ventas x)) (getArbol (ventas x)) cantidad2))
        where   elim2aux v [] cant =    if (cantidadVenta v) >= cant then
                                            [v]
                                        else
                                            []
                elim2aux v [a] cant =   if (cantidadVenta v) >= cant then
                                            v : elim2aux (getVenta a) (getArbol a) cant
                                        else
                                            elim2aux (getVenta a) (getArbol a) cant    

    instance Eq Venta where
        x == y = (nid (articulo x)) == (nid (articulo y))
        x /= y = not (x == y)
        
    -- eliminar repeticiones de artículos en una factura
    elim3 :: Factura -> Factura
    elim3 fact = Factura (creaArbol (elim3aux [] (getVenta (ventas fact)) (getArbol (ventas fact))))
        where   elim3aux seen v []      | elem v seen = unirAux seen seen v
                                        | otherwise = seen ++ [v]
                elim3aux seen v [a]     | elem v seen = elim3aux (unirAux seen seen v) (getVenta a) (getArbol a)
                                        | otherwise = elim3aux (seen ++ [v]) (getVenta a) (getArbol a)
                unirAux (y:ys) seen v1 = if (v1 /= y) then
                                            unirAux ys seen v1
                                        else
                                            (elimSeen seen (articulo v1)) ++ [(Venta (articulo v1) ((cantidadVenta v1)+(cantidadVenta y)))]
                elimSeen [] _ = []
                elimSeen (x:xs) art | (nid (articulo x)) == (nid art) = elimSeen xs art
                                    | otherwise = x : elimSeen xs art

    mainG :: IO ()
    mainG = do

        let a1 = Articulo 1 "Coco" 1.05
        let v1 = Venta a1 3
        
        let a2 = Articulo 2 "Chocolate" 2
        let v2 = VentaUnitaria a2
        
        let a3 = Articulo 3 "Napolitana" 1.05
        let v3 = VentaUnitaria a3

        let a4 = Articulo 4 "Platano" 1.5
        let v4 = a4 :+ 2

        let arb2 = Arb v3 []
        let arb1 = Arb v2 [arb2]
        let arb0 = Arb v1 [arb1]
        let fact1 = Factura arb0
        
        let arb5 = Arb v3 []
        let arb4 = Arb v2 [arb5]
        let arb3 = Arb v1 [arb4]
        let fact2 = Factura arb3

        let fact3 = (fusion2Facturas fact1 fact2)


        print ("-------------------------------APARTADO G----------------------------")
        -- Tests
        print ("Venta1 test precio = " ++ show (precioVenta v1))
        print ("Factura1 test precio = " ++ show (precioFactura fact1))
        print ("Fusion 2 facturas: " ++ show (fusion2Facturas fact1 fact2))
        print("Precio total de un articulo en una factura: " ++ show (precArtFact  a1 fact1))

        -- Tests de conversion a cadenas
        print("")
        print("TEST DE CONVERSION A CADENAS")
        print ("Conversion a cadena de articulo: " ++ convCadenaArticulo a1)
        print ("Conversion a cadena de venta: " ++ convCadenaVenta v1)
        print ("Conversion a cadena de factura: " ++ convCadenaFactura fact1)

        -- Tests de busquedas
        print("")
        print("TEST DE BUSQUEDAS")
        print ("Busqueda en una factura de las ventas relativas a un articulo: " ++ show (busquedaDeVentas1 fact3 a1))
        print ("Busqueda en una factura de las ventas relativas a una lista de articulos: " ++ show (busquedaDeVentas2 fact3 [a1,a2]))

        -- Tests de eliminaciones
        print("")
        print("TEST DE ELIMINACIONES")
        print("Eliminacion en una factura de las ventas relativas a un determinado articulo: "++show (elim1 fact3 a1))
        print("Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: "++show (elim2 fact3 2))
        print("Fact " ++ show (fact3))
        print("Simplificacion de facturas: "++show (elim3 fact3))
        
        -- Resultado de la ejecución
        -- "-------------------------------APARTADO G----------------------------"
        -- "Venta1 test precio = 3.1499999"
        -- "Factura1 test precio = 6.2"
        -- "Fusion 2 facturas: {Venta \"Coco\" 3, VentaUnitaria \"Chocolate\", VentaUnitaria \"Napolitana\", Venta \"Coco\" 3, VentaUnitaria \"Chocolate\", VentaUnitaria \"Napolitana\"}"
        -- "Precio total de un articulo en una factura: 3.1499999"
        -- ""
        -- "TEST DE CONVERSION A CADENAS"
        -- "Conversion a cadena de articulo: \"Coco\""
        -- "Conversion a cadena de venta: Venta \"Coco\" 3"
        -- "Conversion a cadena de factura: {Venta \"Coco\" 3, VentaUnitaria \"Chocolate\", VentaUnitaria \"Napolitana\"}"
        -- ""
        -- "TEST DE BUSQUEDAS"
        -- "Busqueda en una factura de las ventas relativas a un articulo: {Venta \"Coco\" 3, Venta \"Coco\" 3}"
        -- "Busqueda en una factura de las ventas relativas a una lista de articulos: {Venta \"Coco\" 3, Venta \"Coco\" 3, VentaUnitaria \"Chocolate\", VentaUnitaria \"Chocolate\"}"
        -- ""
        -- "TEST DE ELIMINACIONES"
        -- "Eliminacion en una factura de las ventas relativas a un determinado articulo: {VentaUnitaria \"Chocolate\", VentaUnitaria \"Napolitana\", VentaUnitaria \"Chocolate\", VentaUnitaria \"Napolitana\"}"   
        -- "Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: {Venta \"Coco\" 3, Venta \"Coco\" 3}"
        -- "Fact {Venta \"Coco\" 3, VentaUnitaria \"Chocolate\", VentaUnitaria \"Napolitana\", Venta \"Coco\" 3, VentaUnitaria \"Chocolate\", VentaUnitaria \"Napolitana\"}"
        -- "Simplificacion de facturas: {Venta \"Coco\" 6, Venta \"Chocolate\" 2, Venta \"Napolitana\" 2}"
