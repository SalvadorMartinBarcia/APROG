
{-# LANGUAGE FlexibleInstances, TypeSynonymInstances, KindSignatures, GADTs #-}

module ApartadoF.ApartadoF where

    data Factura a b = Factura {ventas :: [Venta a b]}
    data Venta a b where    VentaUnitaria :: {articulo :: Articulo a b} -> Venta a b
                            Venta, (:+) :: (Integral a) => {articulo :: Articulo a b, cantidad :: a} -> Venta a b
    data Articulo a b where Articulo :: (Integral a, Fractional b) => {nid :: a, nombre :: [Char], precio :: b} -> Articulo a b
    

    class Precio2 a where
        precio2 :: a b -> b

    instance Precio2 (Venta a) where
        precio2 v = precioVenta v
    


    -- instance (Integral a, Integral c, Fractional b) => Precio (Venta a b c) where
    --     type Out (Venta a b c) = b
    --     precio' = precioVenta

    -- instance (Integral a, Integral c, Fractional b) => Precio (Factura a b c) where
    --     type Out (Factura a b c) = b
    --     precio' = precioFactura
        
    -- precio de una venta
    precioVenta :: (Fractional b) => Venta a b -> b
    precioVenta (VentaUnitaria x) = precio x
    precioVenta ((:+) a b) = (precio a) * (fromIntegral b)
    precioVenta (Venta a b) = (precio a) * (fromIntegral b)

    -- precio de una factura
    precioFactura :: (Fractional b) => Factura a b-> b
    precioFactura fact = precioFacturaux (ventas fact)
        where   precioFacturaux [] = 0
                precioFacturaux (x:xs) = (precioVenta x) + (precioFacturaux xs)
       

    mainF :: IO ()
    mainF = do

        let a1 = Articulo (1 :: Integer) "Coco" (1.05 :: Double)
        let a2 = Articulo (2 :: Integer) "Chocolate" (2 :: Double)  
        
        let v1 = VentaUnitaria a1
        let v2 = a1 :+ 2
        let v3 = Venta a2 3

        let fact1 = Factura [v1,v2,v3]

        print ("-------------------------------APARTADO F----------------------------")
        -- Tests
        print ("precio' v1 test precio = " ++ show (precio2 v1))
        print ("precio' v2 test precio = " ++ show (precio2 v2))
        print ("precio' v3 test precio = " ++ show (precio2 v3))
        -- print ("precio' fact1 test precio = " ++ show (precio2 fact1))

        -- "-------------------------------APARTADO F----------------------------"
        -- "precio' v1 test precio = 1.05"
        -- "precio' v2 test precio = 2.1"
        -- "precio' v3 test precio = 6.0"
        -- "precio' fact1 test precio = 9.15"
        
        