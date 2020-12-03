using System;
using static System.Console;

namespace iu
{
    public class InterfazConsola : Interfaz
    {
        public override void IntroducirNumero() {
            WriteLine("Calculadora");
            WriteLine("Introduce un numero");
            int n = Convert.ToInt16(ReadLine());
            WriteLine("Calculadora: " + n);
            this.Numero = n;
        }
        public override void RealizarOperacion() 
            => WriteLine("Al realizar la operacion se convierte en: " + Operacion()); 
        public override bool ConfirmarContinuacion() {
            WriteLine("Repetir(s/n)");
            return (ReadLine() == "s");
        }
    }
}
