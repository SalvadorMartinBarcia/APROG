using System;
using static System.Console;
using System.Windows.Forms;

namespace Pract3
{
    static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //do
            //{
                //WriteLine("Introduce modo interaccion");
                //WriteLine("     1. Consola");
                //WriteLine("     2. Ventanas");
                //string modo = Console.ReadLine();
                Interfaz i;
                //if (modo == "1")
                //    i = new InterfazConsola();
                //else i = new InterfazVentanas();

                i = new InterfazVentanas();
                // i = new InterfazConsola();

                i.Interaccionar();
            //    WriteLine("Repetir consola-ventanas (s/n)");
            //} while (ReadLine()== "s");

            WriteLine("Final");
        }
    }
}
