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

            if (Coloreado2.Count > 0)
            {
                foreach (List<Tuple<Provincia, Color>> Coloreado3 in Coloreado2)
                {
                    ListaDeColores = DifererenciaDosListas(t.Item2, ColoresFrontera(t.Item1.provincias[0], Coloreado3));
                }
            }
            else // Coloreado2 = [[]]
            {
                ListaDeColores = t.Item2;

                //[ [ (Co, Rojo):[] ] ,  [ (Co, Azul):[] ], [ (Co, Verde):[] ] ]
            }

            List<List<Tuple<Provincia, Color>>> res = new List<List<Tuple<Provincia, Color>>>();

            List<Tuple<Provincia, Color>> listaAux;

            List<Tuple<Provincia, Color>> listaAux2;

            foreach (Color c in ListaDeColores)
            {
                var tupla = new Tuple<Provincia, Color>(t.Item1.provincias[0], c);
                listaAux = new List<Tuple<Provincia, Color>>();
                listaAux.Add(tupla);
                if (Coloreado2.Count == 0)
                {
                    res.Add(listaAux);
                    //listaAux.Clear();
                }
                else
                {
                    foreach (List<Tuple<Provincia, Color>> listoftuples in Coloreado2)
                    {
                        listaAux2 = new List<Tuple<Provincia, Color>>();
                        listaAux2.AddRange(listaAux);
                        listaAux2.AddRange(listoftuples);

                        res.Add(listaAux2);

                        //listaAux2.Clear();
                    }
                }
            }

            return res;
        }