using System;
using static System.Console;

namespace Pract3
{
    public class InterfazConsola : Interfaz
    {
        public override void RealizarOperacion() 
            => ApartadoDConsola.MainDConsola(); 
        public override bool ConfirmarContinuacion() {
            WriteLine("Repetir(s/n)");
            return (ReadLine() == "s");
        }
    }
}
