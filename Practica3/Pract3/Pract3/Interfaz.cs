
namespace Pract3
{
    public abstract class Interfaz
    {
        public int Numero {get;set;} 
        public void Interaccionar() 
        {
            do {
                RealizarOperacion();
            } while (ConfirmarContinuacion());
        }
        public int Operacion() => Numero * Numero;
        public abstract void RealizarOperacion();
        public abstract bool ConfirmarContinuacion();
    }
}
