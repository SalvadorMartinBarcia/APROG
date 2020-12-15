
namespace ApartadoC
{
    public abstract class Interfaz
    {
        public void Interaccionar()
        {
            while (ConfirmarContinuacion())
            {
                RealizarOperacion();
            }
        }
        public abstract void RealizarOperacion();
        public abstract bool ConfirmarContinuacion();
    }
}
