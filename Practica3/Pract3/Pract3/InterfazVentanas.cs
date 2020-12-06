using System.Windows.Forms;

namespace Pract3
{
    public class InterfazVentanas : Interfaz
    {
        Coloreador form;
        public InterfazVentanas() => this.form = new Coloreador();

        public override void IntroducirNumero() => this.form.ShowDialog();

        //public override void IntroducirNumero() { }

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
