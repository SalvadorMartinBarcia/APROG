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
            List<Tuple<Provincia, Color>> sol;

            List<Color> colores1 = new List<Color>() { Color.Rojo, Color.Verde, Color.Azul };
            List<Color> colores2 = new List<Color>() { Color.Rojo, Color.Verde };


            // Con solucion
            sol = SolucionColorear(new Tuple<Mapa, List<Color>>(Andalucia, colores1));

            foreach (var obj in sol)
            {
                Console.Write(obj + ", ");
            }

            // Sin solucion
            sol = SolucionColorear(new Tuple<Mapa, List<Color>>(Andalucia, colores2));

            foreach (var obj in sol)
            {
                Console.Write(obj + ", ");
            }
        }

        static Mapa Andalucia = new Mapa(new List<Provincia>(){     Provincia.Al,
                                                                    Provincia.Ca,
                                                                    Provincia.Co,
                                                                    Provincia.Gr,
                                                                    Provincia.Ja,
                                                                    Provincia.Hu,
                                                                    Provincia.Ma,
                                                                    Provincia.Se
        });

        // Colores de provincias vecinas para un coloreado
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

        public static List<Color> DifererenciaDosListas(List<Color> list1, List<Color> list2)
        {
            List<Color> listaCopia = new List<Color>(list1.Count);

            list1.ForEach((item) =>
            {
                listaCopia.Add(item);
            });

            foreach (Color c in list2)
            {
                listaCopia.Remove(c);
            }

            return listaCopia;
        }

        // Posibles coloreados para un mapa y una lista de colores
        public static List<List<Tuple<Provincia, Color>>> Coloreados(Tuple<Mapa, List<Color>> t)
        {
            List<List<Tuple<Provincia, Color>>> Coloreado2;
            List<Color> ListaDeColores = new List<Color>();

            if (t.Item1.provincias.Count == 0)
            {
                return new List<List<Tuple<Provincia, Color>>>();
            }

            if (t.Item1.provincias.Count != 1)
            {
                Coloreado2 = Coloreados(new Tuple<Mapa, List<Color>>(new Mapa(t.Item1.provincias.GetRange(1, t.Item1.provincias.Count-1)), t.Item2));
            }
            else
                Coloreado2 = Coloreados(new Tuple<Mapa, List<Color>>(new Mapa(new List<Provincia>()), t.Item2));

            List<List<Tuple<Provincia, Color>>> res = new List<List<Tuple<Provincia, Color>>>();

            if (Coloreado2.Count > 0)
            {
                foreach (List<Tuple<Provincia, Color>> Coloreado3 in Coloreado2)
                {
                    ListaDeColores = DifererenciaDosListas(t.Item2, ColoresFrontera(t.Item1.provincias[0], Coloreado3));

                    res.AddRange(CreaListasSolucion(ListaDeColores, Coloreado3, t.Item1.provincias[0]));
                }
            }
            else // Coloreado2 = [[]]
            {
                ListaDeColores = t.Item2;

                List<Tuple<Provincia, Color>> listaAux;

                foreach (Color c in ListaDeColores)
                {
                    var tupla = new Tuple<Provincia, Color>(t.Item1.provincias[0], c);
                    listaAux = new List<Tuple<Provincia, Color>>();
                    listaAux.Add(tupla);
                    
                    res.Add(listaAux);
                }

                //[ [ (Co, Rojo):[] ] ,  [ (Co, Azul):[] ], [ (Co, Verde):[] ] ]
            }

            return res;
        }

        public static List<List<Tuple<Provincia, Color>>> CreaListasSolucion(   List<Color> listaDeColores, 
                                                                                List<Tuple<Provincia, Color>> Coloreado3, 
                                                                                Provincia prov)
        {
            List<Tuple<Provincia, Color>> listaAux;
            List<List<Tuple<Provincia, Color>>> res = new List<List<Tuple<Provincia, Color>>>();

            foreach (Color c in listaDeColores)
            {
                var tupla = new Tuple<Provincia, Color>(prov, c);
                listaAux = new List<Tuple<Provincia, Color>>();

                listaAux.Add(tupla);

                listaAux.AddRange(Coloreado3);

                res.Add(listaAux);
            }

            return res;
        }

        // solucionColorear
        public static List<Tuple<Provincia, Color>> SolucionColorear (Tuple<Mapa, List<Color>> lista)
        {
            return Coloreados(lista)[0];
        }

        public static List<Provincia> FrAndalucia(Provincia p)
        {
            switch (p)
            {
                case (Provincia)0: //Al
                    return new List<Provincia>() { Provincia.Gr };
                case (Provincia)1: //Ca
                    return new List<Provincia>() {  Provincia.Hu,
                                                    Provincia.Se,
                                                    Provincia.Ma};
                case (Provincia)2: //Co
                    return new List<Provincia>() {  Provincia.Se,
                                                    Provincia.Ma,
                                                    Provincia.Ja,
                                                    Provincia.Gr};
                case (Provincia)3: //Gr
                    return new List<Provincia>() {  Provincia.Ma,
                                                    Provincia.Co,
                                                    Provincia.Ja,
                                                    Provincia.Al};
                case (Provincia)4: //Ja
                    return new List<Provincia>() {  Provincia.Co,
                                                    Provincia.Gr};
                case (Provincia)5: //Hu
                    return new List<Provincia>() {  Provincia.Ca,
                                                    Provincia.Se};
                case (Provincia)6: //Ma
                    return new List<Provincia>() {  Provincia.Ca,
                                                    Provincia.Se,
                                                    Provincia.Co,
                                                    Provincia.Gr};
                case (Provincia)7: //Se
                    return new List<Provincia>() {  Provincia.Hu,
                                                    Provincia.Ca,
                                                    Provincia.Ma,
                                                    Provincia.Co};
                default:
                    return null;
            }
        }
        public class Mapa
        {
            public List<Provincia> provincias;

            public Mapa(List<Provincia> provincias)
            {
                this.provincias = provincias;
            }
        }
    }
}
