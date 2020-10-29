
{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}

module ApartadoD.ApartadoD where

    data Factura = Factura {ventas :: [Venta]}
    data Venta =    VentaUnitaria {articulo :: Articulo} | 
                    Venta {articulo :: Articulo, cantidad :: Int} |
                    (:+) {articulo :: Articulo, cantidad :: Int}
    data Articulo = Articulo {nid :: Int, nombre :: [Char], precio :: Float}

    -- función que comprueba si hay artículos mal definidos en una factura
    compruebaFactura :: Factura -> Bool
    compruebaFactura fact = compruebaFacturaux (ventas fact) (ventas fact)
        where       compruebaFacturaux [] _ = True
                    compruebaFacturaux (x:xs) v = compruebaFacturaux2 x v && compruebaFacturaux xs v
                    compruebaFacturaux2 _ [] = True
                    compruebaFacturaux2 x1 (y1:ys1) = if (nid (articulo x1) == nid (articulo y1)) &&  (nombre (articulo x1) /= nombre (articulo y1) || precio (articulo x1) /= precio (articulo y1)) then
                                                        False
                                                    else
                                                        compruebaFacturaux2 x1 ys1

    -- getter de cantidad independientemente del tipo de venta que sea
    cantidadVenta :: Venta -> Int
    cantidadVenta (Venta _ c) = if c < 0 then error "Cantidad negativa en venta" else c
    cantidadVenta (VentaUnitaria _) = 1
    cantidadVenta ((:+) _ c) = if c < 0 then error "Cantidad negativa en venta" else c

    -- precio de una venta
    precioVenta :: Venta -> Float
    precioVenta (Venta x y) = if (precio x) < 0 || y < 0 then error "Cantidad negativa en precioVenta" else precio x * (fromIntegral y)
    precioVenta ((:+) x y) = if (precio x) < 0 || y < 0 then error "Cantidad negativa en precioVenta" else precio x * (fromIntegral y)
    precioVenta (VentaUnitaria x) = if (precio x) < 0 then error "Cantidad negativa en precioVenta" else precio x

    -- función auxiliar que se puede pasar como parametro a precioFactura
    precioFacturaux :: [Venta] -> Float
    precioFacturaux [] = 0
    precioFacturaux (x:xs) = (precioVenta x) + (precioFacturaux xs)

    -- precio de una factura
    precioFactura :: ([Venta] -> Float) -> Factura -> Float
    precioFactura func fact =   if compruebaFactura fact then
                                    func (ventas fact)
                                else
                                    error "Articulos con mismo id y diferentes precio/nombre"
    
    -- fusión de 2 facturas
    fusion2Facturas :: Factura -> Factura -> Factura
    fusion2Facturas x y =   if compruebaFactura x && compruebaFactura y then
                                Factura ((ventas x) ++ (ventas y))
                            else
                                error "Articulos con mismo id y diferentes precio/nombre"
        

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
    precArtFact func art x =    if compruebaFactura x then
                                    func art (ventas x)
                                else
                                    error "Articulos con mismo id y diferentes precio/nombre"
        
        

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
        show x = "{" ++ imp (ventas x)
            where   imp [y] = show y ++ "}"
                    imp (y:ys) = show y ++ ", " ++ imp ys
    
    convCadenaFactura :: Factura -> [Char]
    convCadenaFactura x = show x

    -- búsqueda en una factura de las ventas relativas a un artículo
    busquedaDeVentas1 :: Factura -> Articulo -> Factura
    busquedaDeVentas1 x art =   if compruebaFactura x then
                                    Factura [a | a <- ventas x, (nid (articulo a)) == (nid art)]
                                else
                                    error "Articulos con mismo id y diferentes precio/nombre"

    -- función auxiliar que se puede pasar como parametro a busquedaDeVentas2
    busquedaDeVentas2aux :: Factura -> [Articulo] -> Factura
    busquedaDeVentas2aux factura [y] = (busquedaDeVentas1 factura y)
    busquedaDeVentas2aux factura (y:ys) = fusion2Facturas (busquedaDeVentas1 factura y) (busquedaDeVentas2aux factura ys)
    
    -- búsqueda en una factura de las ventas relativas a una lista de artículos
    busquedaDeVentas2 :: (Factura -> [Articulo] -> Factura) -> Factura -> [Articulo] -> Factura
    busquedaDeVentas2 func x art =  if compruebaFactura x then
                                        func x art
                                    else
                                        error "Articulos con mismo id y diferentes precio/nombre"

    -- eliminación en una factura de las ventas relativas a un determinado artículo
    elim1 :: Factura -> Articulo -> Factura
    elim1 fact art =    if compruebaFactura fact then
                            Factura [ a | a <- ventas fact, (nid (articulo a)) /= (nid art)]
                        else
                            error "Articulos con mismo id y diferentes precio/nombre"
    
    -- eliminación en una factura de las ventas de aquellas relativas a una cantidad menor que una determinada
    elim2 :: Factura -> Int -> Factura
    elim2 fact c =  if compruebaFactura fact then
                        Factura [ a | a <- ventas fact, cantidadVenta a >= c]
                    else
                        error "Articulos con mismo id y diferentes precio/nombre"
    
    instance Eq Venta where
        x == y = (nid (articulo x)) == (nid (articulo y))
        x /= y = not (x == y)
        
    -- eliminar repeticiones de artículos en una factura
    elim3 :: Factura -> Factura
    elim3 fact =    if compruebaFactura fact then
                        Factura (elim3aux [] (ventas fact))
                    else
                        error "Articulos con mismo id y diferentes precio/nombre"
        where   elim3aux seen [] = seen
                elim3aux seen (x:xs)    | elem x seen = elim3aux (unirAux seen seen x) xs
                                        | otherwise = elim3aux (seen ++ [x]) xs
                unirAux (y:ys) seen x = if (x /= y) then
                                            unirAux ys seen x
                                        else
                                            (ventas (elim1 (Factura seen) (articulo x))) ++ [(Venta (articulo x) ((cantidadVenta x)+(cantidadVenta y)))]
                                            

    mainD :: IO ()
    mainD = do

        let a1 = Articulo 1 "Coco" 1.05
        let v1 = Venta a1 3

        let a1Error = Articulo 1 "CocoError" (-2)
        let v1Error = Venta a1Error (-1)
        
        let a2 = Articulo 2 "Chocolate" 2
        let v2 = VentaUnitaria a2
        
        let a3 = Articulo 3 "Napolitana" 1.05
        let v3 = VentaUnitaria a3

        let a4 = Articulo 4 "Platano" 1.5
        let v4 = a4 :+ 2

        let fact1 = Factura [v1,v2,v4]
        let fact2 = Factura [v3,v1]

        let fact3 = (fusion2Facturas fact1 fact2)
        let factError = Factura [v1,v1Error,v2,v4]
        
        print ("-------------------------------APARTADO D----------------------------")
        --Print errores
        -- print ("cantidadVenta test error = " ++ show(cantidadVenta v1Error))
        -- print ("precioVenta test error = " ++ show(precioVenta v1Error))

        -- print ("precioFactura test no error = " ++ show(precioFactura precioFacturaux fact1))
        -- print ("precioFactura test error = " ++ show(precioFactura precioFacturaux factError))

        -- print ("fusion2Facturas test no error = " ++ show(fusion2Facturas fact1 fact2))
        -- print ("fusion2Facturas test error = " ++ show(fusion2Facturas fact1 factError))

        -- print ("precArtFact test no error = " ++ show(precArtFact precArtFactaux a1 fact1))
        -- print ("precArtFact test error = " ++ show(precArtFact precArtFactaux a1 factError))

        -- print ("busquedaDeVentas1 test no error = " ++ show(busquedaDeVentas1 fact1 a1))
        -- print ("busquedaDeVentas1 test error = " ++ show(busquedaDeVentas1 factError a1))

        -- print ("busquedaDeVentas2 test no error = " ++ show(busquedaDeVentas2 busquedaDeVentas2aux fact1 [a1, a2]))
        -- print ("busquedaDeVentas2 test error = " ++ show(busquedaDeVentas2 busquedaDeVentas2aux factError [a1, a2]))

        -- print ("elim1 test no error = " ++ show(elim1 fact1 a1))
        -- print ("elim1 test error = " ++ show(elim1 factError a1))
        
        -- print ("elim2 test no error = " ++ show(elim2 fact1 2))
        -- print ("elim2 test error = " ++ show(elim2 factError 2))

        -- print("Simplificacion de facturas no error: "++show (elim3 fact3))
        -- print("Simplificacion de facturas no error: "++show (elim3 factError))
        
        

        -- Resultado de la ejecución (ejecutamos uno a uno ya que la ejecución se para por la ejecución de la función error)
        -- p1b-exe.EXE: Cantidad negativa en venta
        -- p1b-exe.EXE: Cantidad negativa en precioVenta

        -- "precioFactura test error = 8.15"
        -- p1b-exe.EXE: Articulos con mismo id y diferentes precio/nombre

        -- "fusion2Facturas test no error = {Venta \"Coco\" 3, {VentaUnitaria \"Chocolate\", {Venta \"Platano\" 2, {VentaUnitaria \"Napolitana\", Venta \"Coco\" 3}"
        -- p1b-exe.EXE: Articulos con mismo id y diferentes precio/nombre

        -- "precArtFact test no error = 3.1499999"
        -- p1b-exe.EXE: Articulos con mismo id y diferentes precio/nombre

        -- "busquedaDeVentas1 test no error = Venta \"Coco\" 3}"
        -- p1b-exe.EXE: Articulos con mismo id y diferentes precio/nombre

        -- "busquedaDeVentas2 test no error = {Venta \"Coco\" 3, VentaUnitaria \"Chocolate\"}"
        -- p1b-exe.EXE: Articulos con mismo id y diferentes precio/nombre

        -- "elim1 test no error = {VentaUnitaria \"Chocolate\", Venta \"Platano\" 2}"
        -- p1b-exe.EXE: Articulos con mismo id y diferentes precio/nombre

        -- "elim2 test no error = {Venta \"Coco\" 3, Venta \"Platano\" 2}"
        -- p1b-exe.EXE: Articulos con mismo id y diferentes precio/nombre

        -- "Simplificacion de facturas no error: {VentaUnitaria \"Chocolate\", {Venta \"Platano\" 2, {VentaUnitaria \"Napolitana\", Venta \"Coco\" 6}"
        -- p1b-exe.EXE: Articulos con mismo id y diferentes precio/nombre