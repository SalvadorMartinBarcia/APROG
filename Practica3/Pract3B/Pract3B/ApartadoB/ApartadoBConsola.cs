using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Linq;

namespace ApartadoB
{

    static class ApartadoB
    {
        public static void MainBConsola()
        {
            List<Tuple<Provincia, ColorProvincia>> sol;
            List<Tuple<Provincia, ColorProvincia>> sol1;
            List<ColorProvincia> colores1 = new List<ColorProvincia>() { ColorProvincia.Rojo, ColorProvincia.Verde, ColorProvincia.Azul };
            List<ColorProvincia> colores2 = new List<ColorProvincia>() { ColorProvincia.Rojo, ColorProvincia.Verde };

            sol = SolucionColorear(new Tuple<Mapa, List<ColorProvincia>>(andalucia, colores1));

            List<List<Char>> mosaicoInicial = MosaicoInicial();

            DibujarMosaico(mosaicoInicial);

            MostrarSeparador();

            List<List<Char>> mosaicoSol = IncluirProvincias(mosaicoInicial, sol);

            DibujarMosaico(mosaicoSol);

        }
        /*
            Ejecución ApartadoB:
            CuadradosSolapadosException: Error, cuadrados solapados
            ................
            ................
            ................
            ................
            ................
            ................
            ................
            ................
            ---------------------------
            ................
            ......rr........
            .rraaarraaaa....
            .rraaarraaaa....
            .rraaarraaaavv..
            ....vv..aaaavv..
            ....vvrrrrrrvvrr
            ....vvrrrrrr..rr
         */

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

        //static public Dictionary<Provincia, List<Provincia>> fronteras = EncontrarFronteras(provs);

        public delegate Dictionary<Provincia, List<Provincia>> Fronteras(List<Provincia> provs);

        static public Mapa andalucia = CrearMapa(provs);

        public static Mapa CrearMapa(List<Provincia> provincias)
        {
            Mapa mapa = null;
            mapa = new Mapa(provincias, EncontrarFronteras);
            return mapa;
        }


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
        public static List<ColorProvincia> ColoresFrontera(Provincia p, List<Tuple<Provincia, ColorProvincia>> coloreado, Fronteras fr)
        {
            List<ColorProvincia> res = new List<ColorProvincia>();

            foreach (Tuple<Provincia, ColorProvincia> t in coloreado)
            {
                if (fr(provs)[p].Contains(t.Item1))
                {
                    res.Add(t.Item2);
                }
            }
            return res;
        }

        // Posibles coloreados para un mapa y una lista de colores
        public static List<List<Tuple<Provincia, ColorProvincia>>> Coloreados(Tuple<Mapa, List<ColorProvincia>> t)
        {
            List<List<Tuple<Provincia, ColorProvincia>>> Coloreado2;
            IEnumerable<ColorProvincia> ListaDeColores = new List<ColorProvincia>();

            if (t.Item1.provincias.Count == 0)
            {
                return new List<List<Tuple<Provincia, ColorProvincia>>>();
            }

            if (t.Item1.provincias.Count != 1)
            {
                Coloreado2 = Coloreados(new Tuple<Mapa, List<ColorProvincia>>(new Mapa(t.Item1.provincias.GetRange(1, t.Item1.provincias.Count - 1), t.Item1.frs), t.Item2));
            }
            else
                Coloreado2 = Coloreados(new Tuple<Mapa, List<ColorProvincia>>(new Mapa(new List<Provincia>(), t.Item1.frs), t.Item2));

            List<List<Tuple<Provincia, ColorProvincia>>> res = new List<List<Tuple<Provincia, ColorProvincia>>>();

            if (Coloreado2.Count > 0)
            {
                foreach (List<Tuple<Provincia, ColorProvincia>> Coloreado3 in Coloreado2)
                {
                    ListaDeColores = (t.Item2).Except(ColoresFrontera(t.Item1.provincias[0], Coloreado3, t.Item1.frs));

                    res.AddRange(CreaListasSolucion(ListaDeColores, Coloreado3, t.Item1.provincias[0]));
                }
            }
            else // Coloreado2 = [[]]
            {
                //[ [ (Co, Rojo):[] ] ,  [ (Co, Azul):[] ], [ (Co, Verde):[] ] ]
                ListaDeColores = t.Item2;

                List<Tuple<Provincia, ColorProvincia>> listaAux;

                foreach (ColorProvincia c in ListaDeColores)
                {
                    var tupla = new Tuple<Provincia, ColorProvincia>(t.Item1.provincias[0], c);
                    listaAux = new List<Tuple<Provincia, ColorProvincia>>();
                    listaAux.Add(tupla);

                    res.Add(listaAux);
                }
            }

            return res;
        }

        public static List<List<Tuple<Provincia, ColorProvincia>>> CreaListasSolucion(IEnumerable<ColorProvincia> listaDeColores,
                                                                                List<Tuple<Provincia, ColorProvincia>> Coloreado3,
                                                                                Provincia prov)
        {
            List<Tuple<Provincia, ColorProvincia>> listaAux;
            List<List<Tuple<Provincia, ColorProvincia>>> res = new List<List<Tuple<Provincia, ColorProvincia>>>();

            foreach (ColorProvincia c in listaDeColores)
            {
                var tupla = new Tuple<Provincia, ColorProvincia>(prov, c);
                listaAux = new List<Tuple<Provincia, ColorProvincia>>();

                listaAux.Add(tupla);

                listaAux.AddRange(Coloreado3);

                res.Add(listaAux);
            }

            return res;
        }

        // solucionColorear
        public static List<Tuple<Provincia, ColorProvincia>> SolucionColorear(Tuple<Mapa, List<ColorProvincia>> lista)
        {
            return Coloreados(lista)[0];
        }

        //-----------------------------MOSAICOS-----------------------------//

        public static List<List<Char>> MosaicoInicial()
        {
            int i, j;
            List<List<Char>> res = new List<List<Char>>();
            List<Char> aux;

            for (i = 0; i < MAXIMOY; i++) // Y
            {
                aux = new List<Char>();
                for (j = 0; j < MAXIMOX; j++) // X
                {
                    aux.Add('.');
                }
                res.Add(aux);
            }

            return res;
        }

        public static void DibujarMosaico(List<List<Char>> mosaico)
        {
            foreach (List<Char> aux in mosaico)
            {
                foreach (Char c in aux)
                {
                    Console.Write(c);
                }
                Console.WriteLine();
            }
        }

        public static List<List<Char>> IncluirProvincias(List<List<Char>> mosaico, List<Tuple<Provincia, ColorProvincia>> lista)
        {

            foreach (Tuple<Provincia, ColorProvincia> t in lista)
            {
                mosaico = IncluirProvincia(t.Item1, t.Item2, mosaico);
            }

            return mosaico;
        }

        public static List<List<Char>> IncluirProvincia(Provincia prov, ColorProvincia color, List<List<Char>> mosaico)
        {
            int i, j;
            List<List<Char>> res = new List<List<Char>>();
            List<Char> aux;

            for (i = 0; i < MAXIMOY; i++)
            {
                aux = new List<Char>(MAXIMOX);

                for (j = 0; j < MAXIMOX; j++)
                {
                    if (i >= (prov.CoordenadaYSup + 1) && i <= prov.CoordenadaYInf &&
                        j >= (prov.CoordenadaXSup + 1) && j <= prov.CoordenadaXInf)
                    {
                        switch (color)
                        {
                            case (ColorProvincia)0: // Rojo
                                aux.Add('r');
                                break;
                            case (ColorProvincia)1: // Verde
                                aux.Add('v');
                                break;
                            case (ColorProvincia)2: // Azul
                                aux.Add('a');
                                break;
                        }
                    }
                    else
                    {
                        aux.Add(mosaico[i][j]);
                    }
                }
                res.Add(aux);
            }

            return res;
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
            //public Dictionary<Provincia, List<Provincia>> fronteras;ç
            public Fronteras frs;

            public Mapa(List<Provincia> provincias, Fronteras fronteras)
            {
                this.provincias = provincias;
                this.frs = fronteras;
            }
            public Boolean CuadradosSolapados(List<Provincia> provincias)
            {
                Boolean res = false;
                List<Tuple<int, int>> list1, list2;
                foreach (Provincia p1 in provincias)
                {
                    foreach (Provincia p2 in provincias)
                    {
                        if (p1.Nombre == p2.Nombre) continue;
                        list1 = creaL(p1.CoordenadaXSup + 1, p1.CoordenadaXInf - 1, p1.CoordenadaYSup + 1, p1.CoordenadaYInf - 1);
                        list2 = creaL(p2.CoordenadaXSup, p2.CoordenadaXInf, p2.CoordenadaYSup, p2.CoordenadaYInf);
                        res = res || (MatchesTuple(list1, list2) > 0);
                    }
                }
                return res;
            }

            public List<Tuple<int, int>> creaL(int xSup, int xInf, int ySup, int yInf)
            {
                List<Tuple<int, int>> listRes = new List<Tuple<int, int>>();
                for (int i = xSup; i <= xInf; i++)
                {
                    for (int j = ySup; j <= yInf; j++)
                    {
                        listRes.Add(new Tuple<int, int>(i, j));
                    }
                }
                return listRes;
            }

            public static int MatchesTuple(List<Tuple<int, int>> l1, List<Tuple<int, int>> l2)
            {
                int cont = 0;

                foreach (Tuple<int, int> n1 in l1)
                {
                    foreach (Tuple<int, int> n2 in l2)
                    {
                        if (n1.Equals(n2)) cont++;
                    }
                }

                return cont;
            }
        }
        public class CuadradosSolapadosException : Exception
        {
            public CuadradosSolapadosException(String error) : base(error) { }
        }
    }
}
