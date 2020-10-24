
{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}

module ApartadoE.ApartadoE where

    data Factura = Factura {ventas :: [Venta]}
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

    -- función auxiliar que se puede pasar como parametro a precioFactura
    precioFacturaux :: [Venta] -> Float
    precioFacturaux [] = 0
    precioFacturaux (x:xs) = (precioVenta x) + (precioFacturaux xs)

    -- precio de una factura
    precioFactura :: ([Venta] -> Float) -> Factura -> Float
    precioFactura func fact = func (ventas fact)
    
    -- fusión de 2 facturas
    fusion2Facturas :: Factura -> Factura -> Factura
    fusion2Facturas x y = Factura ((ventas x) ++ (ventas y))

    -- función auxiliar que se puede pasar como parametro a precArtFact
    precArtFactaux :: Articulo -> [Venta] -> Float
    precArtFactaux _ [] = 0
    precArtFactaux art2 (y:ys) = 
        if nid art2 /= (nid (articulo y)) then
            precArtFactaux art2 ys
        else
            (precioVenta y) + (precArtFactaux art2 ys)

    -- precio total de un artículo en una factura
    precArtFact :: (Articulo -> [Venta] -> Float) -> Articulo -> Factura -> Float
    precArtFact func art x = func art (ventas x)

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
    
    -- conversión a cadena de una factura
    instance Show Factura where
        show x = imp (ventas x)
            where   imp [y] = show y ++ "}"
                    imp (y:ys) = "{" ++ show y ++ ", " ++ imp ys
    
    convCadenaFactura :: Factura -> [Char]
    convCadenaFactura x = show x

    -- búsqueda en una factura de las ventas relativas a un artículo
    busquedaDeVentas1 :: Factura -> Articulo -> Factura
    busquedaDeVentas1 x art = Factura [a | a <- ventas x, (nid (articulo a)) == (nid art)]

    -- función auxiliar que se puede pasar como parametro a busquedaDeVentas2
    busquedaDeVentas2aux :: Factura -> [Articulo] -> Factura
    busquedaDeVentas2aux factura [y] = (busquedaDeVentas1 factura y)
    busquedaDeVentas2aux factura (y:ys) = fusion2Facturas (busquedaDeVentas1 factura y) (busquedaDeVentas2aux factura ys)
    
    -- búsqueda en una factura de las ventas relativas a una lista de artículos
    busquedaDeVentas2 :: (Factura -> [Articulo] -> Factura) -> Factura -> [Articulo] -> Factura
    busquedaDeVentas2 func x art = func x art

    -- eliminación en una factura de las ventas relativas a un determinado artículo
    elim1 :: Factura -> Articulo -> Factura
    elim1 fact art = Factura [ a | a <- ventas fact, (nid (articulo a)) /= (nid art)]
    
    -- eliminación en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada
    elim2 :: Factura -> Int -> Factura
    elim2 fact c = Factura [ a | a <- ventas fact, cantidadVenta a >= c]
    

    instance Eq Venta where
        x == y = (nid (articulo x)) == (nid (articulo y))
        x /= y = not (x == y)
        
    -- eliminar repeticiones de artículos en una factura
    elim3 :: Factura -> Factura
    elim3 fact = Factura (elim3aux [] (ventas fact))
        where   elim3aux seen [] = seen
                elim3aux seen (x:xs)    | elem x seen = elim3aux (unirAux seen seen x) xs
                                        | otherwise = elim3aux (seen ++ [x]) xs
                unirAux (y:ys) seen x = if (x /= y) then
                                            unirAux ys seen x
                                        else
                                            (ventas (elim1 (Factura seen) (articulo x))) ++ [(Venta (articulo x) ((cantidadVenta x)+(cantidadVenta y)))]
                                            

    mainE :: IO ()
    mainE = do

        let a1 = Articulo 1 "Coco" 1.05
        let v1 = Venta a1 3
        
        let a2 = Articulo 2 "Chocolate" 2
        let v2 = VentaUnitaria a2
        
        let a3 = Articulo 3 "Napolitana" 1.05
        let v3 = VentaUnitaria a3

        let a4 = Articulo 4 "Platano" 1.5
        let v4 = a4 :+ 2

        let fact1 = Factura [v1,v2,v4]
        let fact2 = Factura [v3,v1]

        let fact3 = (fusion2Facturas fact1 fact2)


        print ("-------------------------------APARTADO C----------------------------")
        -- Tests
        print ("Venta1 test precio = " ++ show (precioVenta v1))
        print ("Factura1 test precio = " ++ show (precioFactura precioFacturaux fact1))
        print ("Fusion 2 facturas: " ++ show (fusion2Facturas fact1 fact2))
        print("Precio total de un articulo en una factura: " ++ show (precArtFact precArtFactaux a1 fact3))

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
        print ("Busqueda en una factura de las ventas relativas a una lista de articulos: " ++ show (busquedaDeVentas2 busquedaDeVentas2aux fact3 [a2,a3]))

        -- Tests de eliminaciones
        print("")
        print("TEST DE ELIMINACIONES")
        print("Eliminacion en una factura de las ventas relativas a un determinado articulo: "++show (elim1 fact3 a1))
        print("Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: "++show (elim2 fact3 2))
        print("Simplificacion de facturas: "++show (elim3 fact3))
        
        -- Resultado de la ejecución
        -- "Venta1 test precio = 3.1499999"
        -- "Factura1 test precio = 8.15"
        -- "Fusion 2 facturas: {Venta \"Coco\" 3, {VentaUnitaria \"Chocolate\", {Venta \"Platano\" 2, {VentaUnitaria \"Napolitana\", Venta \"Coco\" 3}"
        -- "Precio total de un articulo en una factura: 6.2999997"
        -- ""
        -- "TEST DE CONVERSION A CADENAS"
        -- "Conversion a cadena de articulo: \"Coco\""
        -- "Conversion a cadena de venta: Venta \"Coco\" 3"
        -- "Conversion a cadena de factura: {Venta \"Coco\" 3, {VentaUnitaria \"Chocolate\", Venta \"Platano\" 2}"
        -- ""
        -- "TEST DE BUSQUEDAS"
        -- "Busqueda en una factura de las ventas relativas a un articulo: {Venta \"Coco\" 3, Venta \"Coco\" 3}"
        -- "Busqueda en una factura de las ventas relativas a una lista de articulos: {VentaUnitaria \"Chocolate\", VentaUnitaria \"Napolitana\"}"
        -- ""
        -- "TEST DE ELIMINACIONES"
        -- "Eliminacion en una factura de las ventas relativas a un determinado articulo: {VentaUnitaria \"Chocolate\", {Venta \"Platano\" 2, VentaUnitaria \"Napolitana\"}"
        -- "Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: {Venta \"Coco\" 3, {Venta \"Platano\" 2, Venta \"Coco\" 3}"
        -- "Simplificacion de facturas: {VentaUnitaria \"Chocolate\", {Venta \"Platano\" 2, {VentaUnitaria \"Napolitana\", Venta \"Coco\" 6}"
