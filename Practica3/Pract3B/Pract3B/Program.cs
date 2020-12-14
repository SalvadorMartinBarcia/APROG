using System;
using System.Windows.Forms;

namespace Pract3B
{
    static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            Console.WriteLine("Elige una ejecucion de un apartado:");
            Console.WriteLine("1. ApartadoB");
            Console.WriteLine("2. ApartadoC");
            Console.WriteLine("3. ApartadoD");

            string opcion = Console.ReadLine();

            if (opcion == "1")
            {
                ApartadoB.MainB.MainBB();
            }
            else if (opcion == "2")
            {
                ApartadoC.MainC.MainCC();
            }
            else
            {
                ApartadoD.MainD.MainDD();
            }
        }
    }
}
