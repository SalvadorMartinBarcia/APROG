using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ApartadoE
{
    public enum Color { Rojo, Verde, Azul, Morado, Lila };

    static class ApartadoE
    {
        public static void MainE()
        {

            fronteras = EncontrarFronteras(regs);

            //foreach (KeyValuePair<Region, List<Region>> kvp in fronteras)
            //{
            //    Console.WriteLine("Key = {0}", kvp.Key);
            //    kvp.Value.ForEach(i => Console.WriteLine(i));

            //    Console.WriteLine();
            //}

            //Console.WriteLine(CompruebaVecinos(regs));

            List<Tuple<Region, Color>> sol = SolucionColorear(new Tuple<Mapa, List<Color>>(CrearMapa(regs), new List<Color>() { Color.Rojo, Color.Verde, Color.Azul, Color.Morado }));

            foreach (var obj in sol)
            {
                Console.Write(obj + ", ");
            }

            /////////////////////////////////////

            //List<Tuple<Provincia, Color>> sol;
            //String opcion;

            //Console.WriteLine("Quieres introducir una provincia?(s/n)");
            //opcion = Console.ReadLine();

            //if (opcion == "s")
            //{
            //    IntroducirRectangulos();
            //}

            //Console.WriteLine();
            //Console.WriteLine("Lista de provincias: ");
            //provs.ForEach(i => Console.WriteLine(i));

            //IntroducirColores();

            //// Inicializacion de variables globales
            //fronteras = EncontrarFronteras(provs);

            //Console.WriteLine();
            //Console.WriteLine("Creacion de Andalucia: ");
            //andalucia = CrearMapa(provs);

            //Console.WriteLine();
            //Console.WriteLine("Creacion de Andalucia con provincias solapadas: ");
            //andaluciaSolapada = CrearMapa(provsSolpada); // Lanza excepcion controlada

            //// Encontrar solucion
            //sol = SolucionColorear(new Tuple<Mapa, List<Color>>(andalucia, coloresElejidos));

            //// Pintar mosaico con solucion
            //Console.WriteLine();
            //Console.WriteLine("Mosaico de Andalucia: ");
            //Console.WriteLine();

            //List<List<Char>> mosaicoInicial = MosaicoInicial();

            //DibujarMosaico(mosaicoInicial);

            //MostrarSeparador();

            //List<List<Char>> mosaicoSol = IncluirProvincias(mosaicoInicial, sol);

            //DibujarMosaico(mosaicoSol);

        }

        // VARIABLES GLOBALES

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
        static public Provincia provSolapada = new Provincia(1, 1, 5, 4, "Solapada");

        static public List<Provincia> provs = new List<Provincia>() { prov1, prov2, prov3, prov4, prov5, prov6, prov7, prov8 };
        static public List<Provincia> provsSolpada = new List<Provincia>() { prov1, prov2, prov3, prov4, prov5, prov6, prov7, prov8, provSolapada };

        static public Region reg1 = new Region(new List<Provincia>() { prov1, prov2 }, "reg1");
        static public Region reg2 = new Region(new List<Provincia>() { prov3, prov4 }, "reg2");
        static public Region reg3 = new Region(new List<Provincia>() { prov5, prov6, prov7, prov8 }, "reg3");
        static public Region regExtra = new Region(new List<Provincia>() { provSolapada, prov4, prov5 }, "regExtra");

        static public List<Region> regs = new List<Region>() { reg1, reg2, reg3 };
        static public List<Region> regsSolapadas = new List<Region>() { reg1, regExtra };

        static public Dictionary<Region, List<Region>> fronteras;

        static public Mapa andalucia;
        static public Mapa andaluciaSolapada;

        static public List<Color> coloresDisponibles = new List<Color>() { Color.Rojo, Color.Verde, Color.Azul, Color.Morado, Color.Lila };
        static public List<Color> coloresElejidos;


        /////////////////////////////////////////////////////


        public static void IntroducirRegiones()
        {
            String name, opcion;
            Region reg;
            List<Provincia> listaProvincias;

            Console.WriteLine("Introduccion de provincias de la region: ");


            listaProvincias = IntroducirProvincias(); // Introduccion de provincias para la region

            Console.WriteLine("Introduce el nombre de la nueva region: ");
            name = Console.ReadLine();

            reg = new Region(listaProvincias, name); // Creacion de la nueva region

            regs.Add(reg); // Se añade a la variable global con el resto de regiones

            // Comprobaciones para saber si la region introducida cumple las condiciones del problema
            if (CuadradosSolapados(regs))
            {
                regs.RemoveAt(regs.Count - 1);
                Console.WriteLine("ERROR: La region \"{0}\" NO ha sido introducida", reg.Nombre);
            }
            else
            {
                Console.WriteLine("EXITO: La region \"{0}\" ha sido introducida", reg.Nombre);
            }

            Console.WriteLine("Quieres introducir otra region?(s/n)");
            opcion = Console.ReadLine();

            if (opcion == "s")
                IntroducirRegiones();

        }

        public static List<Provincia> IntroducirProvincias()
        {
            int xSup, ySup, xInf, yInf;
            String name, opcion;

            List<Provincia> provincias = new List<Provincia>();
            Provincia p;

            do
            {
                Console.WriteLine("Introduce la coordenada xSup de una provincia:");
                xSup = Convert.ToInt32(Console.ReadLine());

                Console.WriteLine("Introduce la coordenada ySup de una provincia:");
                ySup = Convert.ToInt32(Console.ReadLine());

                Console.WriteLine("Introduce la coordenada xInf de una provincia:");
                xInf = Convert.ToInt32(Console.ReadLine());

                Console.WriteLine("Introduce la coordenada yInf de una provincia:");
                yInf = Convert.ToInt32(Console.ReadLine());

                Console.WriteLine("Introduce el nombre de la provincia:");
                name = Console.ReadLine();

                p = new Provincia(xSup, ySup, xInf, yInf, name);

                provincias.Add(p);

                Console.WriteLine("Quieres introducir otra provincia?(s/n)");
                opcion = Console.ReadLine();

            } while (opcion == "s");

            return provincias;
        }

        public static void IntroducirColores()
        {
            int numeroColores = 0;

            Console.WriteLine();
            Console.WriteLine("<< Eleccion de colores >>");
            Console.WriteLine("Colores disponibles: ");

            foreach (string colorEnum in Enum.GetNames(typeof(Color)))
            {
                Console.Write(colorEnum + " | ");
            }

            Console.WriteLine();
            Console.WriteLine("Elije el numero de colores que quieres: ");

            numeroColores = Convert.ToInt32(Console.ReadLine());

            if (numeroColores > coloresDisponibles.Count || numeroColores <= 1)
            {
                do
                {
                    Console.WriteLine("ERROR: El numero de colores introducido es incorrecto.");
                    Console.WriteLine();
                    Console.WriteLine("Elije el numero de colores que quieres: ");

                    numeroColores = Convert.ToInt32(Console.ReadLine());

                } while (numeroColores > coloresDisponibles.Count || numeroColores <= 1);
            }

            if (numeroColores != coloresDisponibles.Count)
            {
                coloresElejidos = new List<Color>();

                for (int i = 0; i < numeroColores; i++)
                {
                    coloresElejidos.Add(coloresDisponibles[i]);
                }
            }
            else
            {
                coloresElejidos = coloresDisponibles;
            }

            Console.WriteLine();
            Console.WriteLine("Lista de colores elejidos: ");
            coloresElejidos.ForEach(i => Console.WriteLine(i));

        }

        /////////////////////////////////////////////////////

        public static Mapa CrearMapa(List<Region> regiones)
        {
            Mapa mapa = null;
            try
            {
                mapa = new Mapa(regiones, fronteras);
                Console.WriteLine("EXITO: Mapa creado");
            }
            catch (CuadradosSolapadosException e)
            {
                Console.WriteLine("ERROR: CuadradosSolapadosException: " + e.Message);
            }
            catch (ProvinciaSinVecinosException e)
            {
                Console.WriteLine("ERROR: ProvinciaSinVecinosException: " + e.Message);
            }
            return mapa;
        }


        public static Dictionary<Region, List<Region>> EncontrarFronteras(List<Region> regs)
        {
            int i;
            bool flag1 = false;

            Dictionary<Region, List<Region>> res = new Dictionary<Region, List<Region>>();

            List<int> list1;
            List<int> list2;
            List<int> list3;
            List<int> list4;

            foreach (Region reg1 in regs)
            {
                res.Add(reg1, new List<Region>());

                foreach (Region reg2 in regs)
                {
                    if (reg1.Nombre == reg2.Nombre) continue;

                    foreach (Provincia prov1 in reg1.ListaProvincias1)
                    {
                        foreach (Provincia prov2 in reg2.ListaProvincias1)
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
                                res[reg1].Add(reg2);
                                flag1 = true;
                                break;
                            }
                        }
                        if (flag1)
                        {
                            flag1 = false;
                            break;
                        }
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

        public static bool CompruebaVecinos(List<Region> regs)
        {
            int i;
            bool res = true, aux = false;

            List<int> list1;
            List<int> list2;
            List<int> list3;
            List<int> list4;

            foreach (Region reg in regs)
            {
                foreach(Provincia p1 in reg.ListaProvincias1)
                {
                    aux = false;
                    foreach (Provincia p2 in reg.ListaProvincias1)
                    {
                        if (p1.Nombre == p2.Nombre)
                            continue;

                        list1 = new List<int>();
                        for (i = p1.CoordenadaYSup; i <= p1.CoordenadaYInf; i++)
                            list1.Add(i);

                        list2 = new List<int>();
                        for (i = p2.CoordenadaYSup; i <= p2.CoordenadaYInf; i++)
                            list2.Add(i);

                        list3 = new List<int>();
                        for (i = p1.CoordenadaXSup; i <= p1.CoordenadaXInf; i++)
                            list3.Add(i);

                        list4 = new List<int>();
                        for (i = p2.CoordenadaXSup; i <= p2.CoordenadaXInf; i++)
                            list4.Add(i);

                        if (Matches(list1, list2) > 0 && Matches(list3, list4) > 0)
                        {
                            aux = aux || true;
                        }
                    }
                    res = res && aux;
                }
            }

            return res;
        }

        // Colores de provincias vecinas para un coloreado
        public static List<Color> ColoresFrontera(Region p, List<Tuple<Region, Color>> coloreado)
        {
            List<Color> res = new List<Color>();

            foreach (Tuple<Region, Color> t in coloreado)
            {
                if (fronteras[p].Contains(t.Item1))
                {
                    res.Add(t.Item2);
                }
            }
            return res;
        }

        // Posibles coloreados para un mapa y una lista de colores
        public static List<List<Tuple<Region, Color>>> Coloreados(Tuple<Mapa, List<Color>> t)
        {
            List<List<Tuple<Region, Color>>> Coloreado2;
            List<Color> ListaDeColores = new List<Color>();

            if (t.Item1.regiones.Count == 0)
            {
                return new List<List<Tuple<Region, Color>>>();
            }

            if (t.Item1.regiones.Count != 1)
            {
                // Llamada recursiva
                Coloreado2 = Coloreados(new Tuple<Mapa, List<Color>>(new Mapa(t.Item1.regiones.GetRange(1, t.Item1.regiones.Count - 1), fronteras), t.Item2));
            }
            else
            {
                // Llamada recursiva
                Coloreado2 = Coloreados(new Tuple<Mapa, List<Color>>(new Mapa(new List<Region>(), fronteras), t.Item2));
            }

            List<List<Tuple<Region, Color>>> res = new List<List<Tuple<Region, Color>>>();

            if (Coloreado2.Count > 0)
            {
                foreach (List<Tuple<Region, Color>> Coloreado3 in Coloreado2)
                {
                    ListaDeColores = DifererenciaDosListas(t.Item2, ColoresFrontera(t.Item1.regiones[0], Coloreado3));

                    res.AddRange(CreaListasSolucion(ListaDeColores, Coloreado3, t.Item1.regiones[0]));
                }
            }
            else // Coloreado2 = [[]]
            {
                //[ [ (Co, Rojo):[] ] ,  [ (Co, Azul):[] ], [ (Co, Verde):[] ] ]
                ListaDeColores = t.Item2;

                List<Tuple<Region, Color>> listaAux;

                foreach (Color c in ListaDeColores)
                {
                    var tupla = new Tuple<Region, Color>(t.Item1.regiones[0], c);
                    listaAux = new List<Tuple<Region, Color>>();
                    listaAux.Add(tupla);

                    res.Add(listaAux);
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

        public static List<List<Tuple<Region, Color>>> CreaListasSolucion(List<Color> listaDeColores,
                                                                                List<Tuple<Region, Color>> Coloreado3,
                                                                                Region reg)
        {
            List<Tuple<Region, Color>> listaAux;
            List<List<Tuple<Region, Color>>> res = new List<List<Tuple<Region, Color>>>();

            foreach (Color c in listaDeColores)
            {
                var tupla = new Tuple<Region, Color>(reg, c);
                listaAux = new List<Tuple<Region, Color>>();

                listaAux.Add(tupla);

                listaAux.AddRange(Coloreado3);

                res.Add(listaAux);
            }

            return res;
        }

        // solucionColorear
        public static List<Tuple<Region, Color>> SolucionColorear(Tuple<Mapa, List<Color>> tupla)
        {
            return Coloreados(tupla)[0];
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

        public static List<List<Char>> IncluirRegiones(List<List<Char>> mosaico, List<Tuple<Region, Color>> lista)
        {

            foreach (Tuple<Region, Color> t in lista)
            {
                mosaico = IncluirRegion(t.Item1, t.Item2, mosaico);
            }

            return mosaico;
        }

        public static List<List<Char>> IncluirRegion(Region reg, Color color, List<List<Char>> mosaico)
        {
            foreach (Provincia prov in reg.ListaProvincias1)
            {
                mosaico = IncluirRegion(prov, color, mosaico);
            }

            return mosaico;
        }
        public static List<List<Char>> IncluirRegion(Provincia prov, Color color, List<List<Char>> mosaico)
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
                            case (Color)0: // Rojo
                                aux.Add('r');
                                break;
                            case (Color)1: // Verde
                                aux.Add('v');
                                break;
                            case (Color)2: // Azul
                                aux.Add('a');
                                break;
                            case (Color)3: // Morado
                                aux.Add('m');
                                break;
                            case (Color)4: // Lila
                                aux.Add('l');
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

        /////////////////////////////////////////////////////

        public static Boolean CuadradosSolapados(List<Region> regs)
        {
            Boolean res = false;
            List<Tuple<int, int>> list1, list2;

            foreach (Region reg in regs)
            {
                foreach (Provincia p1 in reg.ListaProvincias1)
                {
                    foreach (Provincia p2 in reg.ListaProvincias1)
                    {
                        if (p1.Nombre == p2.Nombre) continue;
                        list1 = creaL(p1.CoordenadaXSup + 1, p1.CoordenadaXInf - 1, p1.CoordenadaYSup + 1, p1.CoordenadaYInf - 1);
                        list2 = creaL(p2.CoordenadaXSup, p2.CoordenadaXInf, p2.CoordenadaYSup, p2.CoordenadaYInf);
                        res = res || (MatchesTuple(list1, list2) > 0);
                    }
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

        public class Region
        {
            private List<Provincia> ListaProvincias;
            private String nombre;

            public Region(List<Provincia> listaProvincias, string nombre)
            {
                ListaProvincias1 = listaProvincias;
                this.Nombre = nombre;
            }

            public string Nombre { get => nombre; set => nombre = value; }
            internal List<Provincia> ListaProvincias1 { get => ListaProvincias; set => ListaProvincias = value; }

            public override string ToString()
            {
                return this.Nombre.ToString();
            }

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
            public List<Region> regiones;
            public Dictionary<Region, List<Region>> fronteras;

            public Mapa(List<Region> regiones, Dictionary<Region, List<Region>> fronteras)
            {
                if (CuadradosSolapados(regiones))
                {
                    throw (new CuadradosSolapadosException("Error, cuadrados solapados."));
                }
                else if (!CompruebaVecinos(regiones))
                {
                    throw (new ProvinciaSinVecinosException("Error, alguna provincia de alguna region, no tiene vecinos."));
                }
                else
                {
                    this.regiones = regiones;
                    this.fronteras = fronteras;
                }
            }
        }
        public class CuadradosSolapadosException : Exception
        {
            public CuadradosSolapadosException(String error) : base(error) { }
        }
        public class ProvinciaSinVecinosException : Exception
        {
            public ProvinciaSinVecinosException(String error) : base(error) { }
        }
    }
}
