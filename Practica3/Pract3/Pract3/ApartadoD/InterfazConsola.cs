using System;
using static System.Console;

namespace ApartadoD
{
    public class InterfazConsola : Interfaz
    {
        public InterfazConsola() => ApartadoDConsola.MainDConsola();
        public override void RealizarOperacion() 
            => ApartadoDConsola.MainDConsola(); 
        public override bool ConfirmarContinuacion() {
            WriteLine("Repetir(s/n)");
            return (ReadLine() == "s");
        }
    }
}
