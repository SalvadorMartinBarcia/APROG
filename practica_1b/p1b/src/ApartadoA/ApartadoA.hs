


module ApartadoA.ApartadoA where

    type Factura = [Venta]
    type Venta = (Articulo, Int)
    type Articulo = (Int, String, Float)

    get3rd (_,_,x) = x

    precioVenta :: Venta -> Float
    precioVenta (a,b) = (get3rd a) * (fromIntegral b)

    mainA::IO ()
    mainA=do

        let a1 = (1, "Coco", 1.05)
        let v1 = (a1, 3)

        print ("Venta1 test precio = " ++ show (precioVenta v1))
