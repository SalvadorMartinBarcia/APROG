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
            Console.WriteLine("ApartadoB");
            
            ApartadoB.MainB.MainBB();
        }
    }
}
