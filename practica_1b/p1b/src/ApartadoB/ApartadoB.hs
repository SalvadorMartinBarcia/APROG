
{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}

module ApartadoB.ApartadoB where

    data Factura = Factura {ventas :: [Venta]}
    data Venta =    VentaUnitaria {articulo :: Articulo} | 
                    Venta {articulo :: Articulo, cantidad :: Int} |
                    (:+) {articulo :: Articulo}
    data Articulo = Articulo {nid :: Int, nombre :: [Char], precio :: Float}



    -- precio de una venta
    precioVenta :: Venta -> Float
    precioVenta (Venta x y) = precio x * (fromIntegral y)
    precioVenta (VentaUnitaria x) = precio x

    -- precio de una factura
    precioFactura :: Factura -> Float
    precioFactura fact = precioFacturaux (ventas fact)
        where   precioFacturaux [] = 0
                precioFacturaux (x:xs) = (precioVenta x) + (precioFacturaux xs)
    
    -- fusión de 2 facturas
    fusion2Facturas :: Factura -> Factura -> Factura
    fusion2Facturas x y = Factura (fusion2Facturasaux (ventas x) (ventas y))
        where fusion2Facturasaux x y = x ++ y

    -- -- precio total de un artículo en una factura
    precArtFact :: Articulo -> Factura -> Float
    precArtFact art x = precArtFactaux art (ventas x)
        where   precArtFactaux _ [] = 0
                precArtFactaux art2 (y:ys) = 
                    if nid art2 /= (nid (articulo y)) then
                        precArtFactaux art2 ys
                    else
                        (precioVenta y) + (precArtFactaux art2 ys)

    -- conversión a cadena de un artículo
    instance Show Articulo where
        show x = show (nombre x)
    
    convCadenaArticulo :: Articulo -> [Char]
    convCadenaArticulo x = show x
    
    -- conversión a cadena de una venta
    instance Show Venta where
        show (VentaUnitaria x) = "VentaUnitaria "++show x
        show (Venta x y) = "Venta "++show x++" "++show y
    
    convCadenaVenta :: Venta -> [Char]
    convCadenaVenta x = show x
    
    -- conversión a cadena de una factura
    instance Show Factura where
        show x = imp (ventas x)
            where   imp [y] = show y++"}"
                    imp (y:ys) = "{"++show y++", "++imp ys
    
    convCadenaFactura :: Factura -> [Char]
    convCadenaFactura x = show x

    -- búsqueda en una factura de las ventas relativas a un artículo
    busquedaDeVentas1 :: Factura -> Articulo -> Factura
    busquedaDeVentas1 x art = Factura (busquedaDeVentas1aux (ventas x) art)
        where   busquedaDeVentas1aux [] _ = []
                busquedaDeVentas1aux (y:ys) art2 = 
                    if (nid (articulo y)) == (nid art2) then
                        y : (busquedaDeVentas1aux ys art2)
                    else
                        busquedaDeVentas1aux ys art2

    -- búsqueda en una factura de las ventas relativas a una lista de artículos
    busquedaDeVentas2 :: Factura -> [Articulo] -> Factura
    busquedaDeVentas2 x art = busquedaDeVentas2aux x art
        where   busquedaDeVentas2aux factura [y] = (busquedaDeVentas1 factura y)
                busquedaDeVentas2aux factura (y:ys) = fusion2Facturas (busquedaDeVentas1 factura y) (busquedaDeVentas2aux factura ys)

    -- eliminación en una factura de las ventas relativas a un determinado artículo
    elim1 :: Factura -> Articulo -> Factura
    elim1 fact art = Factura (elim1aux (ventas fact) art)
        where   elim1aux [] _ = []
                elim1aux (x:xs) art2    | (nid (articulo x)) == (nid art2) = elim1aux xs art2
                                        | otherwise = x : elim1aux xs art2

    cantidadVenta :: Venta -> Int
    cantidadVenta (Venta a c) = c
    cantidadVenta (VentaUnitaria a) = 1
    
    -- eliminación en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada
    elim2 :: Factura -> Int -> Factura
    elim2 fact c = Factura (elim2aux (ventas fact) c)
        where   elim2aux [] _ = []
                elim2aux (x:xs) c1 = (elim2aux2 x c1) ++ (elim2aux xs c1)
                elim2aux2 v c1 = if (cantidadVenta v) >= c1 then
                                                [v]
                                            else []
                                    
    mainB :: IO ()
    mainB = do

        let a1 = Articulo 1 "Coco" 1.05
        let v1 = Venta a1 3
        
        let a2 = Articulo 2 "Chocolate" 2
        let v2 = VentaUnitaria a2
        
        let a3 = Articulo 3 "Napolitana" 1.05
        let v3 = Venta a3 1
        
        let fact1 = Factura [v1,v2]
        let fact2 = Factura [v3,v1]

        let fact3 = (fusion2Facturas fact1 fact2)

        -- Tests
        print ("Venta1 test precio = " ++ show (precioVenta v1))
        print ("Factura1 test precio = " ++ show (precioFactura fact1))
        print ("Fusion 2 facturas: " ++ show (fusion2Facturas fact1 fact2))
        print("Precio total de un articulo en una factura: " ++ show (precArtFact a1 fact3))

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
        print ("Busqueda en una factura de las ventas relativas a una lista de articulos: " ++ show (busquedaDeVentas2 fact3 [a2,a3]))

        -- Tests de eliminaciones
        print("")
        print("TEST DE ELIMINACIONES")
        print("Eliminacion en una factura de las ventas relativas a un determinado articulo: "++show (elim1 fact3 a1))
        print("Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: "++show (elim2 fact3 2))