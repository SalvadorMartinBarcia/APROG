using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ApartadoD
{
    public enum ColorProvincia { Rojo, Verde, Azul, Morado, Lila };

    public static class ApartadoDVentana
    {
        // VARIABLES GLOBALES

        static public List<Provincia> provs = new List<Provincia>();

        static public Dictionary<Provincia, List<Provincia>> fronteras;

        static public Mapa andalucia;

        static public List<ColorProvincia> coloresDisponibles = 
            new List<ColorProvincia>() {    ColorProvincia.Rojo,
                                            ColorProvincia.Verde,
                                            ColorProvincia.Azul,
                                            ColorProvincia.Morado,
                                            ColorProvincia.Lila };

        /////////////////////////////////////////////////////

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

            foreach(int n1 in l1)
            {
                foreach (int n2 in l2)
                {
                    if (n1 == n2) cont++;
                }
            }

            return cont;
        }

        // Colores de provincias vecinas para un coloreado
        public static List<ColorProvincia> ColoresFrontera(Provincia p, List<Tuple<Provincia, ColorProvincia>> coloreado)
        {
            List<ColorProvincia> res = new List<ColorProvincia>();

            foreach (Tuple<Provincia, ColorProvincia> t in coloreado)
            {
                if (fronteras[p].Contains(t.Item1))
                {
                    res.Add(t.Item2);
                }
            }
            return res;
        }

        public static List<ColorProvincia> DifererenciaDosListas(List<ColorProvincia> list1, List<ColorProvincia> list2)
        {
            List<ColorProvincia> listaCopia = new List<ColorProvincia>(list1.Count);

            list1.ForEach((item) =>
            {
                listaCopia.Add(item);
            });

            foreach (ColorProvincia c in list2)
            {
                listaCopia.Remove(c);
            }

            return listaCopia;
        }

        // Posibles coloreados para un mapa y una lista de colores
        public static List<List<Tuple<Provincia, ColorProvincia>>> Coloreados(Tuple<Mapa, List<ColorProvincia>> t)
        {
            List<List<Tuple<Provincia, ColorProvincia>>> Coloreado2;
            List<ColorProvincia> ListaDeColores = new List<ColorProvincia>();

            if (t.Item1.provincias.Count == 0)
            {
                return new List<List<Tuple<Provincia, ColorProvincia>>>();
            }

            if (t.Item1.provincias.Count != 1)
            {
                // Llamada recursiva
                Coloreado2 = Coloreados(new Tuple<Mapa, List<ColorProvincia>>(new Mapa(t.Item1.provincias.GetRange(1, t.Item1.provincias.Count-1), fronteras), t.Item2));
            }
            else
            {
                // Llamada recursiva
                Coloreado2 = Coloreados(new Tuple<Mapa, List<ColorProvincia>>(new Mapa(new List<Provincia>(), fronteras), t.Item2));
            }

            List<List<Tuple<Provincia, ColorProvincia>>> res = new List<List<Tuple<Provincia, ColorProvincia>>>();

            if (Coloreado2.Count > 0)
            {
                foreach (List<Tuple<Provincia, ColorProvincia>> Coloreado3 in Coloreado2)
                {
                    ListaDeColores = DifererenciaDosListas(t.Item2, ColoresFrontera(t.Item1.provincias[0], Coloreado3));

                    res.AddRange(CreaListasSolucion(ListaDeColores, Coloreado3, t.Item1.provincias[0]));
                }
            }
            else
            {
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

        public static List<List<Tuple<Provincia, ColorProvincia>>> CreaListasSolucion(   List<ColorProvincia> listaDeColores, 
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

        public static List<Tuple<Provincia, ColorProvincia>> SolucionColorear (Tuple<Mapa, List<ColorProvincia>> tupla)
        {
            List<List<Tuple<Provincia, ColorProvincia>>> sol = Coloreados(tupla);
            if (sol.Count == 0)
                return null;
            else
                return sol[0];
        }

        /////////////////////////////////////////////////////

        public static Boolean CuadradosSolapados(List<Provincia> provincias)
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

        public static List<Tuple<int, int>> creaL(int xSup, int xInf, int ySup, int yInf)
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

        /////////////////////////////////////////////////////

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
                if (CuadradosSolapados(provincias))
                {
                    throw (new CuadradosSolapadosException("Error, cuadrados solapados"));
                }
                else
                {
                    this.provincias = provincias;
                    this.fronteras = fronteras;
                }
            }
        }
        public class CuadradosSolapadosException : Exception
        {
            public CuadradosSolapadosException(String error) : base(error) {}
        }
    }
}
