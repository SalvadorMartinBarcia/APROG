using System.Windows.Forms;

namespace ApartadoC
{
    public class InterfazVentanas : Interfaz
    {
        Coloreador form;

        public InterfazVentanas()
        {
            this.form = new Coloreador();
            this.form.ShowDialog();
        }

        public override void RealizarOperacion()
        {
            new InterfazVentanas();
        }
        public override bool ConfirmarContinuacion()
        {
            DialogResult resultado = MessageBox.Show("¿Repetir?", "Confirmar continuación", MessageBoxButtons.YesNo);
            return (resultado == DialogResult.Yes);
        }
    }
}
