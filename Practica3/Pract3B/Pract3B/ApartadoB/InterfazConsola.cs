using System;
using static System.Console;

namespace ApartadoB
{
    public class InterfazConsola : Interfaz
    {
        public InterfazConsola() => ApartadoB.MainBConsola();
        public override void RealizarOperacion() 
            => ApartadoB.MainBConsola(); 
        public override bool ConfirmarContinuacion() {
            WriteLine("Repetir(s/n)");
            return (ReadLine() == "s");
        }
    }
}
