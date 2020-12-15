using System.Windows.Forms;

namespace ApartadoD
{
    public class InterfazVentanas : Interfaz
    {
        Coloreador form;
        int dimension;

        public InterfazVentanas(int dimension)
        {
            this.dimension = dimension;
            this.form = new Coloreador(dimension);
            this.form.ShowDialog();
        }

        public override void RealizarOperacion()
        {
            new InterfazVentanas(this.dimension);
        }
        public override bool ConfirmarContinuacion()
        {
            DialogResult resultado = MessageBox.Show("¿Repetir?", "Confirmar continuación", MessageBoxButtons.YesNo);
            return (resultado == DialogResult.Yes);
        }
    }
}
