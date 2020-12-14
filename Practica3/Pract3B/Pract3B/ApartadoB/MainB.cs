using System;
using static System.Console;
using System.Windows.Forms;

namespace ApartadoB
{
    static class MainB
    {
        public static void MainBB()
        {
            Console.WriteLine("Ejecucion Apartado B");
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
