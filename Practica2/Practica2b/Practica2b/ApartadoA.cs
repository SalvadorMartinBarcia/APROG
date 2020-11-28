using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ApartadoA
{
    public enum Color { Rojo, Verde, Azul };
    public enum Provincia { Al, Ca, Co, Gr, Ja, Hu, Ma, Se };

    static class ApartadoA
    {
        public static void MainA()
        {
            List<Color> colores1 = new List<Color>() { Color.Rojo, Color.Verde, Color.Azul };
            List<Color> colores2 = new List<Color>() { Color.Rojo, Color.Azul };

            FrAndalucia(Provincia.Co);

            //Ejemplos de tuplas en c#
            var t1 = new Tuple<Double, int>(4.5, 3);
            var t2 = Tuple.Create(4.5, 3);

            Console.WriteLine($"Tuple with elements {t1.Item1} and {t1.Item2}.");

        }

        // Colores de provincias vecinas para un coloreado
        // coloresFrontera
        public static List<Color> ColoresFrontera(Provincia p, List<Tuple<Provincia, Color>> coloreado)
        {
            List<Color> res = new List<Color>();

            foreach (Tuple<Provincia, Color> t in coloreado) {
                if (FrAndalucia(p).Contains(t.Item1))
                {
                    res.Add(t.Item2);
                }
            }
            return res;
        }

        // Posibles coloreados para un mapa y una lista de colores
        public static List<List<Tuple<Provincia, Color>>> Coloreados(Tuple<Mapa, List<Color>> t)
        {
            return null;
        }


        // solucionColorear
        public static List<Tuple<Provincia, Color>> SolucionColorear (List<List<Tuple<Provincia, Color>>> lista)
        {
            if (lista == null)
                return null;
            else
                return lista[0];
        }

        
        public static List<Provincia> FrAndalucia(Provincia p)
        {
            switch (p)
            {
                case (Provincia)0: //Al
                    Console.WriteLine("Gr");
                    return new List<Provincia>() { Provincia.Gr };
                case (Provincia)1: //Ca
                    Console.WriteLine("Hu, Se, Ma");
                    return new List<Provincia>() {  Provincia.Hu,
                                                    Provincia.Se,
                                                    Provincia.Ma};
                case (Provincia)2: //Co
                    Console.WriteLine("Se, Ma, Ja, Gr");
                    return new List<Provincia>() {  Provincia.Se,
                                                    Provincia.Ma,
                                                    Provincia.Ja,
                                                    Provincia.Gr};
                default:
                    return null;
            }
        }
        public class Mapa
        {
            public List<Provincia> provincias = new List<Provincia>(){  Provincia.Al,
                                                                        Provincia.Ca,
                                                                        Provincia.Co,
                                                                        Provincia.Gr,
                                                                        Provincia.Ja,
                                                                        Provincia.Hu,
                                                                        Provincia.Ma,
                                                                        Provincia.Se };

            public Mapa() { } // Atlas

        }
        
    }
}
