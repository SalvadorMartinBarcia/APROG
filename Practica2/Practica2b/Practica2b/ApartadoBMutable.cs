using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ApartadoBMutable
{
    public enum Color { Rojo, Verde, Azul };

    static class ApartadoBMutable
    {
        public static void MainB()
        {
            List<Tuple<Provincia, Color>> sol;
            List<Color> colores1 = new List<Color>() { Color.Rojo, Color.Verde, Color.Azul };
            List<Color> colores2 = new List<Color>() { Color.Rojo, Color.Verde };

            sol = SolucionColorear(new Tuple<Mapa, List<Color>>(andalucia, colores1));

            char[][] mosaicoInicial = MosaicoInicial();

            DibujarMosaico(mosaicoInicial);

            MostrarSeparador();

            char[][] mosaicoSol = IncluirProvincias(mosaicoInicial, sol);

            DibujarMosaico(mosaicoSol);

        }

        public static readonly int MAXIMOX = 16;
        public static readonly int MAXIMOY = 8;

        static public Provincia prov1 = new Provincia(0, 1, 2, 4, "Huelva");
        static public Provincia prov2 = new Provincia(2, 1, 5, 4, "Sevilla");
        static public Provincia prov3 = new Provincia(5, 0, 7, 4, "Cordoba");
        static public Provincia prov4 = new Provincia(7, 1, 11, 5, "Jaen");
        static public Provincia prov5 = new Provincia(3, 4, 5, 7, "Cadiz");
        static public Provincia prov6 = new Provincia(5, 5, 11, 7, "Malaga");
        static public Provincia prov7 = new Provincia(11, 3, 13, 6, "Granada");
        static public Provincia prov8 = new Provincia(13, 5, 15, 7, "Almeria");

        static public List<Provincia> provs = new List<Provincia>() { prov1, prov2, prov3, prov4, prov5, prov6, prov7, prov8 };

        static public Dictionary<Provincia, List<Provincia>> fronteras = EncontrarFronteras(provs);

        static public Mapa andalucia = new Mapa(provs, fronteras);


        public static Dictionary<Provincia, List<Provincia>> EncontrarFronteras(List<Provincia> provs)
        {
            int i;

            Dictionary<Provincia, List<Provincia>> res = new Dictionary<Provincia, List<Provincia>>();

            List<int> list1;
            List<int> list2;
            List<int> list3;
            List<int> list4;

            foreach (Provincia prov1 in provs)
            {
                res.Add(prov1, new List<Provincia>());

                foreach (Provincia prov2 in provs)
                {
                    if (prov1.Nombre == prov2.Nombre)
                        continue;

                    list1 = new List<int>();
                    for (i = prov1.CoordenadaYSup; i <= prov1.CoordenadaYInf; i++)
                        list1.Add(i);

                    list2 = new List<int>();
                    for (i = prov2.CoordenadaYSup; i <= prov2.CoordenadaYInf; i++)
                        list2.Add(i);

                    list3 = new List<int>();
                    for (i = prov1.CoordenadaXSup; i <= prov1.CoordenadaXInf; i++)
                        list3.Add(i);

                    list4 = new List<int>();
                    for (i = prov2.CoordenadaXSup; i <= prov2.CoordenadaXInf; i++)
                        list4.Add(i);

                    if (Matches(list1, list2) > 0 && Matches(list3, list4) > 0)
                    {
                        res[prov1].Add(prov2);
                    }
                }
            }

            return res;
        }

        public static int Matches(List<int> l1, List<int> l2)
        {
            int cont = 0;

            foreach (int n1 in l1)
            {
                foreach (int n2 in l2)
                {
                    if (n1 == n2) cont++;
                }
            }

            return cont;
        }

        // Colores de provincias vecinas para un coloreado
        public static List<Color> ColoresFrontera(Provincia p, List<Tuple<Provincia, Color>> coloreado)
        {
            List<Color> res = new List<Color>();

            foreach (Tuple<Provincia, Color> t in coloreado)
            {
                if (fronteras[p].Contains(t.Item1))
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
                Coloreado2 = Coloreados(new Tuple<Mapa, List<Color>>(new Mapa(t.Item1.provincias.GetRange(1, t.Item1.provincias.Count - 1), fronteras), t.Item2));
            }
            else
                Coloreado2 = Coloreados(new Tuple<Mapa, List<Color>>(new Mapa(new List<Provincia>(), fronteras), t.Item2));

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
                //[ [ (Co, Rojo):[] ] ,  [ (Co, Azul):[] ], [ (Co, Verde):[] ] ]
                ListaDeColores = t.Item2;

                List<Tuple<Provincia, Color>> listaAux;

                foreach (Color c in ListaDeColores)
                {
                    var tupla = new Tuple<Provincia, Color>(t.Item1.provincias[0], c);
                    listaAux = new List<Tuple<Provincia, Color>>();
                    listaAux.Add(tupla);

                    res.Add(listaAux);
                }
            }

            return res;
        }

        public static List<List<Tuple<Provincia, Color>>> CreaListasSolucion(List<Color> listaDeColores,
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
        public static List<Tuple<Provincia, Color>> SolucionColorear(Tuple<Mapa, List<Color>> lista)
        {
            return Coloreados(lista)[0];
        }

        //-----------------------------MOSAICOS-----------------------------//

        static public char[][] mosaico;

        public static char[][] MosaicoInicial()
        {
            int i, j;
            mosaico = new char[MAXIMOY][];

            for (i = 0; i < MAXIMOY; i++) // Y
            {
                mosaico[i] = new char[MAXIMOX];
                for (j = 0; j < MAXIMOX; j++) // X
                {
                    mosaico[i][j] = '.';
                }
            }

            return mosaico;
        }

        public static void DibujarMosaico(char[][] mosaico)
        {
            foreach (char[] aux in mosaico)
            {
                foreach (char c in aux)
                {
                    Console.Write(c);
                }
                Console.WriteLine();
            }
        }

        public static char[][] IncluirProvincias(char[][] mosaico, List<Tuple<Provincia, Color>> lista)
        {

            foreach (Tuple<Provincia, Color> t in lista)
            {
                mosaico = IncluirProvincia(t.Item1, t.Item2, mosaico);
            }

            return mosaico;
        }

        public static char[][] IncluirProvincia(Provincia prov, Color color, char[][] mosaico)
        {
            int i, j;

            for (i = 0; i < MAXIMOY; i++)
            {
                for (j = 0; j < MAXIMOX; j++)
                {
                    if (i >= (prov.CoordenadaYSup + 1) && i <= prov.CoordenadaYInf &&
                        j >= (prov.CoordenadaXSup + 1) && j <= prov.CoordenadaXInf)
                    {
                        switch (color)
                        {
                            case (Color)0: // Rojo
                                mosaico[i][j] = 'r';
                                break;
                            case (Color)1: // Verde
                                mosaico[i][j] = 'v';
                                break;
                            case (Color)2: // Azul
                                mosaico[i][j] = 'a';
                                break;
                        }
                    }
                }
            }

            return mosaico;
        }

        public static void MostrarSeparador()
        {
            Console.WriteLine("---------------------------");
        }

        public class Provincia
        {
            private int coordenadaYSup;
            private int coordenadaYInf;
            private string nombre;
            private int coordenadaXSup;
            private int coordenadaXInf;

            public Provincia(int coordenadaXSup, int coordenadaYSup, int coordenadaXInf, int coordenadaYInf, string nombre)
            {
                this.CoordenadaXSup = coordenadaXSup;
                this.CoordenadaYSup = coordenadaYSup;
                this.CoordenadaXInf = coordenadaXInf;
                this.CoordenadaYInf = coordenadaYInf;
                this.Nombre = nombre;
            }

            public int CoordenadaXSup { get => coordenadaXSup; set => coordenadaXSup = value; }
            public int CoordenadaYSup { get => coordenadaYSup; set => coordenadaYSup = value; }
            public int CoordenadaXInf { get => coordenadaXInf; set => coordenadaXInf = value; }
            public int CoordenadaYInf { get => coordenadaYInf; set => coordenadaYInf = value; }
            public string Nombre { get => nombre; set => nombre = value; }

            public override string ToString()
            {
                return this.Nombre.ToString();
            }

        }

        public class Mapa
        {
            public List<Provincia> provincias;
            public Dictionary<Provincia, List<Provincia>> fronteras;

            public Mapa(List<Provincia> provincias, Dictionary<Provincia, List<Provincia>> fronteras)
            {
                this.provincias = provincias;
                this.fronteras = fronteras;
            }
        }
    }
}
