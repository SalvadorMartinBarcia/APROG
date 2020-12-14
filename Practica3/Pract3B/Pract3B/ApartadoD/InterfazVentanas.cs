using System.Windows.Forms;

namespace ApartadoD
{
    public class InterfazVentanas : Interfaz
    {
        Coloreador form;

        public InterfazVentanas(int dimension)
        {
            this.form = new Coloreador(dimension);
            this.form.ShowDialog();
        }

        public override void RealizarOperacion()
        {
            // sin código pues la operación se realiza al pulsar el botón "Operar"
        }
        public override bool ConfirmarContinuacion()
        {
            //DialogResult resultado = MessageBox.Show("¿Repetir?", "Confirmar continuación", MessageBoxButtons.YesNo);
            //return (resultado == DialogResult.Yes);
            return false;
        }
    }
}
