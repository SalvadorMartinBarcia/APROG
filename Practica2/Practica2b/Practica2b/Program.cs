using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practica2b
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Ejecución ApartadoA:");
            ApartadoA.ApartadoA.MainA();
            Console.WriteLine();
            Console.WriteLine();

            Console.WriteLine("Ejecución ApartadoB Inmutable:");
            ApartadoBInmutable.ApartadoBInmutable.MainB();
            Console.WriteLine();
            Console.WriteLine();

            Console.WriteLine("Ejecución ApartadoB Mutable:");
            ApartadoBMutable.ApartadoBMutable.MainB();
            Console.WriteLine();
            Console.WriteLine();

            Console.WriteLine("Ejecución ApartadoC:");
            ApartadoC.ApartadoC.MainC();
            Console.WriteLine();
            Console.WriteLine();
        }
    }
}
