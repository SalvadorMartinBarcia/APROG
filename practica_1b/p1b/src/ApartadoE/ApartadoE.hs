
{-# LANGUAGE FlexibleInstances, TypeSynonymInstances, KindSignatures, GADTs #-}

module ApartadoE.ApartadoE where

    data Factura a b c = Factura {ventas :: [Venta a b c]}
    data Venta a b c where      VentaUnitaria :: {articulo :: Articulo a b} -> Venta a b c
                                Venta, (:+) :: (Integral c) => {articulo :: Articulo a b, cantidad :: c} -> Venta a b c
    data Articulo a c where Articulo :: (Integral a, Fractional c) => {nid :: a, nombre :: [Char], precio :: c} -> Articulo a c

    -- getter de cantidad independientemente del tipo de venta que sea
    cantidadVenta :: (Integral c) => Venta a b c -> c
    cantidadVenta (Venta _ c) = c
    cantidadVenta (VentaUnitaria _) = 1
    cantidadVenta ((:+) _ c) = c

    -- precio de una venta
    precioVenta :: (Fractional b) => Venta a b c -> b
    precioVenta (VentaUnitaria x) = precio x
    precioVenta ((:+) a c) = (precio a) * (fromIntegral c)
    precioVenta (Venta a c) = (precio a) * (fromIntegral c)

    -- función auxiliar que se puede pasar como parametro a precioFactura
    precioFacturaux :: (Fractional b) => [Venta a b c] -> b
    precioFacturaux [] = 0
    precioFacturaux (x:xs) = (precioVenta x) + (precioFacturaux xs)

    -- precio de una factura
    precioFactura :: ([Venta a b c] -> Float) -> Factura a b c-> Float
    precioFactura func fact = func (ventas fact)
    
    -- fusión de 2 facturas
    fusion2Facturas :: Factura a b c -> Factura a b c -> Factura a b c
    fusion2Facturas x y = Factura ((ventas x) ++ (ventas y))

    -- función auxiliar que se puede pasar como parametro a precArtFact
    precArtFactaux :: (Fractional b, Integral a) => Articulo a b -> [Venta a b c] -> b
    precArtFactaux _ [] = 0
    precArtFactaux art2 (y:ys) = 
        if (nid art2) /= (nid (articulo y)) then
            precArtFactaux art2 ys
        else
            (precioVenta y) + (precArtFactaux art2 ys)

    -- precio total de un artículo en una factura
    precArtFact :: (Articulo a b -> [Venta a b c] -> Float) -> Articulo a b -> Factura a b c -> Float
    precArtFact func art x = func art (ventas x)

    -- conversión a cadena de un artículo
    instance Show (Articulo a c) where
        show x = show (nombre x)
    
    convCadenaArticulo :: Articulo a b-> [Char]
    convCadenaArticulo x = show x
    
    -- conversión a cadena de una venta
    instance Show (Venta a b c) where
        show (VentaUnitaria x) = "VentaUnitaria " ++ show x
        show (Venta x y) = "Venta " ++ show x++" " ++ show (toInteger y)
        show ((:+) x y) = "Venta " ++ show x ++ " " ++ show (toInteger y)
    
    convCadenaVenta :: Venta a b c -> [Char]
    convCadenaVenta x = show x
    
    -- conversión a cadena de una factura
    instance Show (Factura a b c) where
        show x = "{" ++ imp (ventas x)
            where   imp [y] = show y ++ "}"
                    imp (y:ys) = show y ++ ", " ++ imp ys
    
    convCadenaFactura :: Factura a b c -> [Char]
    convCadenaFactura x = show x

    -- búsqueda en una factura de las ventas relativas a un artículo
    busquedaDeVentas1 :: (Integral a) => Factura a b c -> Articulo a b -> Factura a b c
    busquedaDeVentas1 x art = Factura [a | a <- ventas x, (nid (articulo a)) == (nid art)]

    -- función auxiliar que se puede pasar como parametro a busquedaDeVentas2
    busquedaDeVentas2aux :: (Integral a) => Factura a b c -> [Articulo a b] -> Factura a b c
    busquedaDeVentas2aux factura [y] = (busquedaDeVentas1 factura y)
    busquedaDeVentas2aux factura (y:ys) = fusion2Facturas (busquedaDeVentas1 factura y) (busquedaDeVentas2aux factura ys)
    
    -- búsqueda en una factura de las ventas relativas a una lista de artículos
    busquedaDeVentas2 :: (Factura a b c -> [Articulo a b] -> Factura a b c) -> Factura a b c -> [Articulo a b] -> Factura a b c
    busquedaDeVentas2 func x art = func x art

    -- eliminación en una factura de las ventas relativas a un determinado artículo
    elim1 :: (Integral a) => Factura a b c -> Articulo a b -> Factura a b c
    elim1 fact art = Factura [ a | a <- ventas fact, (nid (articulo a)) /= (nid art)]
    
    -- eliminación en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada
    elim2 :: (Integral a, Integral c) => Factura a b c -> c -> Factura a b c
    elim2 fact cantidad = Factura [ a1 | a1 <- ventas fact, (cantidadVenta a1) >= cantidad]
    

    instance (Integral a, Integral c) => Eq (Venta a b c) where
        x == y = (nid (articulo x)) == (nid (articulo y))
        x /= y = not (x == y)
    
    -- eliminar repeticiones de artículos en una factura
    elim3 :: (Integral a, Integral c) => Factura a b c -> Factura a b c
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

        let a1 = Articulo (1:: (Integral a) => a) "Coco" (1.05::(Fractional b) => b)
        let a2 = Articulo (2:: (Integral a) => a) "Chocolate" (2::(Fractional b) => b)
        let a3 = Articulo (3:: (Integral a) => a) "Platano" (2::(Fractional b) => b)      
        
        let v1 = VentaUnitaria a1
        let v2 = a1 :+ 2
        let v3 = Venta a2 3
        let v4 = Venta a3 3

        let fact1 = Factura [v1,v2,v3,v4]
        let fact2 = Factura [v3,v1]

        print ("-------------------------------APARTADO E----------------------------")
        -- Tests
        print ("precioVenta 1 test precio = " ++ show (precioVenta v1))
        print ("precioVenta 2 test precio = " ++ show (precioVenta v2))
        print ("precioVenta 3 test precio = " ++ show (precioVenta v3))
        print ("Factura1 test precio = " ++ show (precioFactura precioFacturaux fact1))
        print ("Fusion 2 facturas: " ++ show (fusion2Facturas fact1 fact2))
        print("Precio total de un articulo en una factura: " ++ show (precArtFact precArtFactaux a1 fact1))

        -- Tests de conversion a cadenas
        print("")
        print("TEST DE CONVERSION A CADENAS")
        print ("Conversion a cadena de articulo: " ++ convCadenaArticulo a1)
        print ("Conversion a cadena de venta: " ++ convCadenaVenta v1)
        print ("Conversion a cadena de factura: " ++ convCadenaFactura fact1)

        -- Tests de busquedas
        print("")
        print("TEST DE BUSQUEDAS")
        print ("Busqueda en una factura de las ventas relativas a un articulo: " ++ show (busquedaDeVentas1 fact1 a1))
        print ("Busqueda en una factura de las ventas relativas a una lista de articulos: " ++ show (busquedaDeVentas2 busquedaDeVentas2aux fact1 [a2,a1]))

        -- Tests de eliminaciones
        print("")
        print("TEST DE ELIMINACIONES")
        print("Eliminacion en una factura de las ventas relativas a un determinado articulo: "++show (elim1 fact1 a1))
        print("Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: "++show (elim2 fact1 2))
        print("Simplificacion de facturas: "++show (elim3 fact1))
        
        -- "-------------------------------APARTADO E----------------------------"
        -- "precioVenta 1 test precio = 1.05"
        -- "precioVenta 2 test precio = 2.1"
        -- "precioVenta 3 test precio = 6.0"
        -- "Factura1 test precio = 15.150001"
        -- "Fusion 2 facturas: {VentaUnitaria \"Coco\", Venta \"Coco\" 2, Venta \"Chocolate\" 3, Venta \"Platano\" 3, Venta \"Chocolate\" 3, VentaUnitaria \"Coco\"}"
        -- "Precio total de un articulo en una factura: 3.1499999"
        -- ""
        -- "TEST DE CONVERSION A CADENAS"
        -- "Conversion a cadena de articulo: \"Coco\""
        -- "Conversion a cadena de venta: VentaUnitaria \"Coco\""
        -- "Conversion a cadena de factura: {VentaUnitaria \"Coco\", Venta \"Coco\" 2, Venta \"Chocolate\" 3, Venta \"Platano\" 3}"
        -- ""
        -- "TEST DE BUSQUEDAS"
        -- "Busqueda en una factura de las ventas relativas a un articulo: {VentaUnitaria \"Coco\", Venta \"Coco\" 2}"
        -- "Busqueda en una factura de las ventas relativas a una lista de articulos: {Venta \"Chocolate\" 3, VentaUnitaria \"Coco\", Venta \"Coco\" 2}"
        -- ""
        -- "TEST DE ELIMINACIONES"
        -- "Eliminacion en una factura de las ventas relativas a un determinado articulo: {Venta \"Chocolate\" 3, Venta \"Platano\" 3}"
        -- "Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: {Venta \"Coco\" 2, Venta \"Chocolate\" 3, Venta \"Platano\" 3}"
        -- "Simplificacion de facturas: {Venta \"Coco\" 3, Venta \"Chocolate\" 3, Venta \"Platano\" 3}"