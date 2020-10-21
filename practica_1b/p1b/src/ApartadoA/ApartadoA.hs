


module ApartadoA.ApartadoA where

    type Factura = [Venta]
    type Venta = (Articulo, Int)
    type Articulo = (Int, String, Float)

    getPrecioFromArt :: Articulo -> Float
    getPrecioFromArt (_,_,x) = x

    getIdFromArt :: Articulo -> Int
    getIdFromArt (y,_,_) = y

    getArtFromVenta :: Venta -> Articulo
    getArtFromVenta venta = fst venta

    -- precio de una venta
    precioVenta :: Venta -> Float
    precioVenta (a,b) = (getPrecioFromArt a) * (fromIntegral b)

    -- precio de una factura
    precioFactura :: Factura -> Float
    precioFactura [] = 0
    precioFactura (x:xs) = (precioVenta x) + (precioFactura xs)

    --(*) fusión de 2 facturas
    fusion2Facturas :: Factura -> Factura -> Factura
    fusion2Facturas x y = x ++ y
    
    --(*) precio total de un artículo en una factura
    precArtFact :: Articulo -> Factura -> Float
    precArtFact (id, nombre, precio) [] = 0
    precArtFact (id, nombre, precio) (x:xs) = 
        if id /= (getIdFromArt (getArtFromVenta x)) then
            precArtFact (id, nombre, precio) xs
        else
            (precioVenta x) + (precArtFact (id, nombre, precio) xs)

    -- conversión a cadena de un artículo
    convCadenaArticulo :: Articulo -> [Char]
    convCadenaArticulo (id,nombre,precio) = "Articulo: "++show nombre++" Id: "++show id++" Precio: "++show precio

    -- conversión a cadena de una venta
    convCadenaVenta :: Venta -> [Char]
    convCadenaVenta (articulo, cantidad) = "Articulo: "++convCadenaArticulo articulo++" Cantidad: "++show cantidad

    -- conversión a cadena de una factura
    convCadenaFactura :: Factura -> [Char]
    convCadenaFactura [xs] = convCadenaVenta xs
    convCadenaFactura (x:xs) = convCadenaVenta x ++" | "++convCadenaFactura xs

    --(*) búsqueda en una factura de las ventas relativas a un artículo
    busquedaDeVentas1 :: Factura -> Articulo -> Factura
    busquedaDeVentas1 [] (id, nombre, precio) = []
    busquedaDeVentas1 (x:xs) (id, nombre, precio) = 
        if (getIdFromArt (fst x)) == id then
            x : (busquedaDeVentas1 xs (id, nombre, precio))
        else
            busquedaDeVentas1 xs (id, nombre, precio)
    
    --(*) búsqueda en una factura de las ventas relativas a una lista de artículos
    busquedaDeVentas2 :: Factura -> [Articulo] -> Factura
    busquedaDeVentas2 factura [] = []
    busquedaDeVentas2 factura (x:xs) = fusion2Facturas (busquedaDeVentas1 factura x) (busquedaDeVentas2 factura xs)

    --(*) eliminación en una factura de las ventas relativas a un determinado artículo
    elim1 :: Factura -> Articulo -> Factura
    elim1 [] _ = []
    elim1 (x:xs) (id,nombre,precio) | (getIdFromArt (getArtFromVenta x)) == id = elim1 xs (id,nombre,precio)
                                    | otherwise = x : elim1 xs (id,nombre,precio)
    
    --(*) eliminación en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada
    elim2 :: Factura -> Int -> Factura
    elim2 [] _ = []
    elim2 (x:xs) cantidad   | snd x < cantidad = elim2 xs cantidad
                            | otherwise = x : elim2 xs cantidad

    mainA :: IO ()
    mainA = do

        let a1 = (1, "Coco", 1.05)
        let v1 = (a1, 3)

        let a2 = (2, "Chocolate", 2)
        let v2 = (a2, 3)
        
        let a3 = (3, "Napolitana", 1.05)
        let v3 = (a3, 1)
        
        let fact1 = [v1,v2]
        let fact2 = [v3,v1]

        let fact3 = (fusion2Facturas fact1 fact2)

        -- Tests
        print ("Venta1 test precio = " ++ show (precioVenta v1))
        print ("Factura1 test precio = " ++ show (precioFactura fact1))
        print ("Fusion 2 facturas: " ++ show (fact1 `fusion2Facturas` fact2))
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

        -- Muestra de la ejecucion esperada

        -- "Venta1 test precio = 3.1499999"
        -- "Factura1 test precio = 9.15"
        -- "Fusion 2 facturas: [((1,\"Coco\",1.05),3),((2,\"Chocolate\",2.0),3),((3,\"Napolitana\",1.05),1),((1,\"Coco\",1.05),3)]" 
        -- "Precio total de un articulo en una factura: 6.2999997"
        -- ""
        -- "TEST DE CONVERSION A CADENAS"
        -- "Conversion a cadena de articulo: Articulo: \"Coco\" Id: 1 Precio: 1.05"
        -- "Conversion a cadena de venta: Articulo: Articulo: \"Coco\" Id: 1 Precio: 1.05 Cantidad: 3"
        -- "Conversion a cadena de factura: Articulo: Articulo: \"Coco\" Id: 1 Precio: 1.05 Cantidad: 3 | Articulo: Articulo: \"Chocolate\" Id: 2 Precio: 2.0 Cantidad: 3"
        -- ""
        -- "TEST DE BUSQUEDAS"
        -- "Busqueda en una factura de las ventas relativas a un articulo: [((1,\"Coco\",1.05),3),((1,\"Coco\",1.05),3)]"
        -- "Busqueda en una factura de las ventas relativas a una lista de articulos: [((2,\"Chocolate\",2.0),3),((3,\"Napolitana\",1.05),1)]"
        -- ""
        -- "TEST DE ELIMINACIONES"
        -- "Eliminacion en una factura de las ventas relativas a un determinado articulo: [((2,\"Chocolate\",2.0),3),((3,\"Napolitana\",1.05),1)]"
        -- "Eliminacion en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada: [((1,\"Coco\",1.05),3),((2,\"Chocolate\",2.0),3),((1,\"Coco\",1.05),3)]"