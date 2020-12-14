using System;
using static System.Console;
using System.Windows.Forms;

namespace ApartadoC
{
    static class MainC
    {
        public static void MainCC()
        {
            Console.WriteLine("Ejecucion Apartado C");
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
                    i = new InterfazVentanas();
                }

                i.Interaccionar();
                WriteLine("Repetir consola-ventanas (s/n)");
            } while (ReadLine() == "s");

            WriteLine("Final");
        }
    }
}
