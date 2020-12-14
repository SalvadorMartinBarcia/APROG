using System;
using static System.Console;
using System.Windows.Forms;

namespace ApartadoD
{
    static class MainD
    {
        public static void MainDD()
        {
            Console.WriteLine("Ejecucion Apartado D");
            do
            {
                WriteLine("Introduce modo interaccion");
                WriteLine("     1. Consola");
                WriteLine("     2. Ventanas");
                string modo = Console.ReadLine();
                Interfaz i;
                if (modo == "1")
                    i = new InterfazConsola();
                else
                {
                    WriteLine("Introduce la dimension del mapa (Recomendable menor que 20)");
                    
                    int dimension = Convert.ToInt32(Console.ReadLine());

                    i = new InterfazVentanas(dimension);
                }

                i.Interaccionar();
                WriteLine("Repetir consola-ventanas (s/n)");
            } while (ReadLine() == "s");

            WriteLine("Final");
        }
    }
}
