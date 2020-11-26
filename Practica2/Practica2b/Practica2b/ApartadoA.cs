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
            
        }

        public static List<Dictionary<Provincia, Color>> Coloreados(List<Provincia> provincias, List<Color> colores)
        {
            List<Dictionary<Provincia, Color>> res = null;
            int i, j;

            for(i = 0 ; i < provincias.Count ; i++)
            {
                for(j = 0 ; j < colores.Count ; j++)
                {

                }
            }

            return res;
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
            public List<Provincia> provincias;

            public Mapa()
            {

            }
        }
        
    }
}
