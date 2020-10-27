
{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}

module ApartadoH.ApartadoH where

    data Factura = Factura {ventas :: [Venta]}
    data Venta =    VentaADomicilio {articulo :: Articulo, cantidad :: Int} |
                    Venta {articulo :: Articulo, cantidad :: Int} |
                    VentaPrecioMayor {articulo :: Articulo, cantidad :: Int}

    data Articulo =     Alimento {   
                                    nid :: Int, 
                                    nombre :: [Char], 
                                    precio :: Float,
                                    promo :: Promocion,
                                    impuesto :: Float} | 
                        Electrodomestico {  
                                    nid :: Int, 
                                    nombre :: [Char], 
                                    precio :: Float,
                                    promo :: Promocion,
                                    impuesto :: Float}

    data Promocion =    Promocion32 | Promocion21 | NoPromocion

    getpromocion :: Venta -> Float
    getpromocion v = getpromocionaux (promo (articulo v)) (cantidad v)
        where   getpromocionaux Promocion32 c =    if (mod c 3) == 0 then
                                                    2/3
                                                else
                                                    1
                getpromocionaux Promocion21 c = if (mod c 2) == 0 then
                                                    1/2
                                                else
                                                    1
                getpromocionaux NoPromocion _ = 1

    -- precio de una venta
    precioVenta :: Venta -> Float
    precioVenta (Venta x y) = (((precio x * (fromIntegral y)) +
                    ((precio x * (fromIntegral y)) *
                    (impuesto x))) *
                    getpromocion (Venta x y))

    precioVenta (VentaPrecioMayor x y) = (((precio x * (fromIntegral y)) +
                    ((precio x * (fromIntegral y)) *
                    (impuesto x))) *
                    getpromocion (VentaPrecioMayor x y)) + 2

    precioVenta (VentaADomicilio x y) = (((precio x * (fromIntegral y)) +
                    ((precio x * (fromIntegral y)) *
                    (impuesto x))) *
                    getpromocion (VentaADomicilio x y)) + 5
    

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
        show x = show (nombre x) ++ " con impuesto de " ++ show (impuesto x)
    
    convCadenaArticulo :: Articulo -> [Char]
    convCadenaArticulo x = show x
    
    -- conversión a cadena de una venta
    instance Show Venta where
        show (Venta x y) = "Venta " ++ show x ++", " ++ show y++" unidades"
        show (VentaADomicilio x y) = "Venta a domicilio " ++ show x++", " ++ show y++" unidades"
        show (VentaPrecioMayor x y) = "Venta con un precio mayor " ++ show x ++ ", " ++ show y++" unidades"
    
    convCadenaVenta :: Venta -> [Char]
    convCadenaVenta x = show x
    
    -- conversión a cadena de una factura
    instance Show Factura where
        show x = "{" ++ imp (ventas x)
            where   imp [y] = show y ++ "}"
                    imp (y:ys) = show y ++ ", " ++ imp ys
    
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
    elim2 fact c = Factura [ a | a <- ventas fact, (cantidad a) >= c]
    

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
                                            (ventas (elim1 (Factura seen) (articulo x))) ++ [(Venta (articulo x) ((cantidad x)+(cantidad y)))]
                                            

    mainH :: IO ()
    mainH = do

        let a1 = Alimento 1 "Coco" 1.05 Promocion32 0.21
        let v1 = Venta a1 3
        
        let a2 = Alimento 2 "Chocolate" 2 NoPromocion 0.21
        let v2 = VentaADomicilio a2 2
        
        let a3 = Electrodomestico 3 "Lavadora" 100 Promocion21 0.21
        let v3 = VentaPrecioMayor a3 1

        let fact1 = Factura [v1,v2,v3]
        let fact2 = Factura [v3,v1]

        let fact3 = (fusion2Facturas fact1 fact2)


        print ("-------------------------------APARTADO H----------------------------")
        -- Tests
        print ("Venta1 test precio = " ++ show (precioVenta v1))
        print ("Venta2 test precio = " ++ show (precioVenta v2))
        print ("Venta3 test precio = " ++ show (precioVenta v3))
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
        print ("Busqueda en una factura de las ventas relativas a una lista de articulos: " ++ show (busquedaDeVentas2 busquedaDeVentas2aux fact3 [a2,a3]))

        -- Tests de eliminaciones
        print("")
        print("TEST DE ELIMINACIONES")
        print("Eliminacion en una factura de las ventas relativas a un determinado articulo: "++show (elim1 fact3 a1))
        print("Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: "++show (elim2 fact3 2))
        print("Simplificacion de facturas: "++show (elim3 fact3))
        
        -- Resultado de la ejecución
        -- "-------------------------------APARTADO H----------------------------"
        -- "Venta1 test precio = 2.541"    
        -- "Venta2 test precio = 9.84"     
        -- "Venta3 test precio = 123.0"    
        -- "Factura1 test precio = 135.381"
        -- "Fusion 2 facturas: {Venta \"Coco\" con impuesto de 0.21, 3 unidades, Venta a domicilio \"Chocolate\" con impuesto de 0.21, 2 unidades, Venta con un precio mayor \"Lavadora\" con 
        -- impuesto de 0.21, 1 unidades, Venta con un precio mayor \"Lavadora\" con impuesto de 0.21, 1 unidades, Venta \"Coco\" con impuesto de 0.21, 3 unidades}"
        -- "Precio total de un articulo en una factura: 2.541"
        -- ""
        -- "TEST DE CONVERSION A CADENAS"
        -- "Conversion a cadena de articulo: \"Coco\" con impuesto de 0.21"
        -- "Conversion a cadena de venta: Venta \"Coco\" con impuesto de 0.21, 3 unidades"
        -- "Conversion a cadena de factura: {Venta \"Coco\" con impuesto de 0.21, 3 unidades, Venta a domicilio \"Chocolate\" con impuesto de 0.21, 2 unidades, Venta con un precio mayor \"Lavadora\" con impuesto de 0.21, 1 unidades}"
        -- ""
        -- "TEST DE BUSQUEDAS"
        -- "Busqueda en una factura de las ventas relativas a un articulo: {Venta \"Coco\" con impuesto de 0.21, 3 unidades}"
        -- "Busqueda en una factura de las ventas relativas a una lista de articulos: {Venta a domicilio \"Chocolate\" con impuesto de 0.21, 2 unidades, Venta con un precio mayor \"Lavadora\" con impuesto de 0.21, 1 unidades, Venta con un precio mayor \"Lavadora\" con impuesto de 0.21, 1 unidades}"
        -- ""
        -- "TEST DE ELIMINACIONES"
        -- "Eliminacion en una factura de las ventas relativas a un determinado articulo: {Venta a domicilio \"Chocolate\" con impuesto de 0.21, 2 unidades, Venta con un precio mayor \"Lavadora\" con impuesto de 0.21, 1 unidades, Venta con un precio mayor \"Lavadora\" con impuesto de 0.21, 1 unidades}"
        -- "Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: {Venta \"Coco\" con impuesto de 0.21, 3 unidades, Venta a domicilio \"Chocolate\" con impuesto de 0.21, 2 unidades, Venta \"Coco\" con impuesto de 0.21, 3 unidades}"
        -- "Simplificacion de facturas: {Venta a domicilio \"Chocolate\" con impuesto de 0.21, 2 unidades, Venta \"Lavadora\" con impuesto de 0.21, 2 unidades, Venta \"Coco\" con impuesto de 0.21, 6 unidades}"
