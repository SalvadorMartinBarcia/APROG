﻿using System;
using static System.Console;

namespace ApartadoC
{
    public class InterfazConsola : Interfaz
    {
        public override void RealizarOperacion() 
            => ApartadoC.MainCConsola(); 
        public override bool ConfirmarContinuacion() {
            WriteLine("Repetir(s/n)");
            return (ReadLine() == "s");
        }
    }
}
