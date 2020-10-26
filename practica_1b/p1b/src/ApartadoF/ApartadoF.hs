
-- {-# LANGUAGE FlexibleInstances, TypeSynonymInstances, KindSignatures, GADTs, TypeFamilies #-}

module ApartadoF.ApartadoF where

--     data Factura a b c = Factura {ventas :: [Venta a b c]}
--     data Venta a b c where      VentaUnitaria :: {articulo :: Articulo a b} -> Venta a b c
--                                 Venta, (:+) :: (Integral c) => {articulo :: Articulo a b, cantidad :: c} -> Venta a b c
--     data Articulo a c where Articulo :: (Integral a, Fractional c) => {nid :: a, nombre :: [Char], precio :: c} -> Articulo a c
    
--     class Precio d where
--         type Out d :: *
--         precio' :: d -> Out d

--     -- class Precio2 (a :: *->*) where
--     --     precio2 :: a b -> b

--     -- instance Precio2 (Venta a) where ....
    


--     instance (Integral a, Integral c, Fractional b) => Precio (Venta a b c) where
--         type Out (Venta a b c) = b
--         precio' = precioVenta

--     instance (Integral a, Integral c, Fractional b) => Precio (Factura a b c) where
--         type Out (Factura a b c) = b
--         precio' = precioFactura
        
--     -- precio de una venta
--     precioVenta :: (Fractional b) => Venta a b c -> b
--     precioVenta (VentaUnitaria x) = precio x
--     precioVenta ((:+) a c) = (precio a) * (fromIntegral c)
--     precioVenta (Venta a c) = (precio a) * (fromIntegral c)

--     -- precio de una factura
--     precioFactura :: (Fractional b) => Factura a b c-> b
--     precioFactura fact = precioFacturaux (ventas fact)
--         where   precioFacturaux [] = 0
--                 precioFacturaux (x:xs) = (precioVenta x) + (precioFacturaux xs)
       

--     mainF :: IO ()
--     mainF = do

--         let a1 = Articulo (1:: (Integral a) => a) "Coco" (1.05::(Fractional b) => b)
--         let a2 = Articulo (2:: (Integral a) => a) "Chocolate" (2::(Fractional b) => b)   
        
--         let v1 = VentaUnitaria a1
--         let v2 = a1 :+ 2
--         let v3 = Venta a2 3

--         let fact1 = Factura [v1,v2,v3]

--         print ("-------------------------------APARTADO F----------------------------")
--         -- Tests
--         print ("precio' v1 test precio = " ++ show (precio' v1))
--         print ("precio' v2 test precio = " ++ show (precio' v2))
--         print ("precio' v3 test precio = " ++ show (precio' v3))
--         print ("precio' fact1 test precio = " ++ show (precio' fact1))

--         -- "-------------------------------APARTADO F----------------------------"
--         -- "precio' v1 test precio = 1.05"
--         -- "precio' v2 test precio = 2.1"
--         -- "precio' v3 test precio = 6.0"
--         -- "precio' fact1 test precio = 9.15"
        
        