
{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}

module ApartadoB.ApartadoB where

    data Factura = Factura {ventas :: [Venta]}
    --data Venta = VentaUnitaria Articulo | Venta Articulo Integer| Articulo :+ Integer -- == (:+) Articulo Integer
    data Venta =    VentaUnitaria {articulo :: Articulo} | 
                    Venta {articulo :: Articulo, cantidad :: Integer} |
                    Articulo :+ Integer
    data Articulo = Articulo {nid :: Int, nombre :: String, precio :: Float}

    -- getPrecioFromArt :: Articulo -> Float
    -- getPrecioFromArt (_,_,x) = x

    -- getIdFromArt :: Articulo -> Int
    -- getIdFromArt (y,_,_) = y

    -- getArtFromVenta :: Venta -> Articulo
    -- getArtFromVenta venta = fst venta

    -- precio de una venta
    precioVenta :: Venta -> Float
    precioVenta v = precio (articulo v) * (fromIntegral (cantidad v))

    -- -- precio de una factura
    -- -- Funciones locales
    -- -- precioFacturaux :: [Venta] -> Float
    -- -- precioFacturaux [] = 0
    -- -- precioFacturaux (x:xs) = (precioVenta x) + (precioFacturaux xs)

    -- precioFactura :: Factura -> Float
    -- precioFactura fact = precioFacturaux (ventas fact)
    --     where   precioFacturaux [] = 0
    --             precioFacturaux (x:xs) = (precioVenta x) + (precioFacturaux xs)
    
    -- -- fusión de 2 facturas
    -- fusion2Facturasaux :: [Venta] -> [Venta] -> [Venta]
    -- fusion2Facturasaux x y = x ++ y

    -- fusion2Facturas :: Factura -> Factura -> Factura
    -- fusion2Facturas x y = Factura (fusion2Facturasaux (ventas x) (ventas y))

    -- -- precio total de un artículo en una factura
    -- precArtFactaux :: Articulo -> [Venta] -> Float
    -- precArtFactaux art [] = 0
    -- precArtFactaux art (x:xs) = 
    --     if nid art /= (nid (getArtFromVenta x)) then
    --         precArtFactaux art xs
    --     else
    --         (precioVenta x) + (precArtFactaux art xs)
    
    -- precArtFact :: Articulo -> Factura -> Float
    -- precArtFact art x = precArtFactaux art (ventas x)

    -- -- conversión a cadena de un artículo
    -- instance Show Articulo where
    --     show x = show (nombre x)
    
    -- convCadenaArticulo :: Articulo -> [Char]
    -- convCadenaArticulo x = show x
    -- -- conversión a cadena de una venta
    
    -- instance Show Venta where
    --     show (articulo, cantidad) = 
    --         if cantidad == 1 then 
    --             "VentaUnitaria "++show articulo
    --         else
    --             "Venta "++show articulo++show cantidad
    
    -- -- conversión a cadena de una factura
    -- instance Show Factura where
    --   show x = show (ventas x)
    
    -- convCadenaFactura :: Factura -> [Char]
    -- convCadenaFactura x = show x
    -- --convCadenaFactura :: Factura -> [Char]
    -- -- convCadenaFactura [xs] = convCadenaVenta xs
    -- -- convCadenaFactura (x:xs) = convCadenaVenta x ++" | "++convCadenaFactura xs

    -- -- -- búsqueda en una factura de las ventas relativas a un artículo
    -- -- busquedaDeVentas1 :: Factura -> Articulo -> Factura
    -- -- busquedaDeVentas1 [] (id, nombre, precio) = []
    -- -- busquedaDeVentas1 (x:xs) (id, nombre, precio) = 
    -- --     if (getIdFromArt (fst x)) == id then
    -- --         x : (busquedaDeVentas1 xs (id, nombre, precio))
    -- --     else
    -- --         busquedaDeVentas1 xs (id, nombre, precio)

    -- -- -- búsqueda en una factura de las ventas relativas a una lista de artículos
    -- -- busquedaDeVentas2 :: Factura -> [Articulo] -> Factura
    -- -- busquedaDeVentas2 factura [] = []
    -- -- busquedaDeVentas2 factura (x:xs) = fusion2Facturas (busquedaDeVentas1 factura x) (busquedaDeVentas2 factura xs)

    -- -- -- eliminación en una factura de las ventas relativas a un determinado artículo
    -- -- elim1 :: Factura -> Articulo -> Factura
    -- -- elim1 [] _ = []
    -- -- elim1 (x:xs) (id,nombre,precio) | (getIdFromArt (getArtFromVenta x)) == id = elim1 xs (id,nombre,precio)
    -- --                                 | otherwise = x : elim1 xs (id,nombre,precio)

    -- -- -- eliminación en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada
    -- -- elim2 :: Factura -> Int -> Factura
    -- -- elim2 [] _ = []
    -- -- elim2 (x:xs) cantidad   | snd x < cantidad = elim2 xs cantidad
    -- --                         | otherwise = x : elim2 xs cantidad

    mainB :: IO ()
    mainB = do

        let a1 = Articulo 1 "Coco" 1.05
        let v1 = Venta a1 3
        
        -- let a2 = Articulo 2 "Chocolate" 2
        -- let v2 = (a2, 3)
        
        -- let a3 = Articulo 3 "Napolitana" 1.05
        -- let v3 = (a3, 1)
        
        -- let fact1 = Factura [v1,v2]
        -- let fact2 = Factura [v3,v1]

        -- let fact3 = (fusion2Facturas fact1 fact2)

        -- Tests
        print ("Venta1 test precio = " ++ show (precioVenta v1))
    --     print ("Factura1 test precio = " ++ show (precioFactura fact1))
    --     print ("Fusion 2 facturas: " ++ show (fusion2Facturas fact1 fact2))
    --     print("Precio total de un articulo en una factura: " ++ show (precArtFact a1 fact3))

    --     -- -- Tests de conversion a cadenas
    --     print("")
    --     print("TEST DE CONVERSION A CADENAS")
    --     print ("Conversion a cadena de articulo: " ++ convCadenaArticulo a1)
    --     --print ("Conversion a cadena de venta: " ++ convCadenaVenta v1)
    --     print ("Conversion a cadena de factura: " ++ convCadenaFactura fact1)

        -- -- Tests de busquedas
        -- print("")
        -- print("TEST DE BUSQUEDAS")
        -- print ("Busqueda en una factura de las ventas relativas a un articulo: " ++ show (busquedaDeVentas1 fact3 a1))
        -- print ("Busqueda en una factura de las ventas relativas a una lista de articulos: " ++ show (busquedaDeVentas2 fact3 [a2,a3]))

        -- -- Tests de eliminaciones
        -- print("")
        -- print("TEST DE ELIMINACIONES")
        -- print("Eliminacion en una factura de las ventas relativas a un determinado articulo: "++show (elim1 fact3 a1))
        -- print("Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: "++show (elim2 fact3 2))