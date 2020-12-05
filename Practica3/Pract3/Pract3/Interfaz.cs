
namespace Practica3
{
    public abstract class Interfaz
    {
        public int Numero {get;set;} 
        public void Interaccionar() 
        {
            do {
                IntroducirNumero();
                RealizarOperacion();
            } while (ConfirmarContinuacion());
        }
        public int Operacion() => Numero * Numero;
        public abstract void IntroducirNumero();
        public abstract void RealizarOperacion();
        public abstract bool ConfirmarContinuacion();
    }
}
