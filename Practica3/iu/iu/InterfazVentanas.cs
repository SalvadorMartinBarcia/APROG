using System.Windows.Forms;

namespace iu
{
    public class InterfazVentanas : Interfaz
    {
        Calculadora form;
        public InterfazVentanas() => this.form = new Calculadora(this);
        public override void IntroducirNumero() => this.form.ShowDialog();
        public override void RealizarOperacion() 
        {
            // sin código pues la operación se realiza al pulsar el botón "Operar"
        }
        public override bool ConfirmarContinuacion()
        {
            DialogResult resultado = MessageBox.Show("¿Repetir?", "Confirmar continuación", MessageBoxButtons.YesNo);
            return (resultado == DialogResult.Yes);
        }
    }
}
