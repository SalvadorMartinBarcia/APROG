using System;
using System.Windows.Forms;

namespace iu
{
    public partial class Calculadora : Form
    {
        private InterfazVentanas intVen;
        public Calculadora(InterfazVentanas i)
        {
            this.intVen = i;
            InitializeComponent();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            this.Text = "Calculadora[parametro=" + this.textBox1.Text + "]";
            this.intVen.Numero = Convert.ToInt32(this.textBox1.Text);
        }
        private void button2_Click(object sender, EventArgs e)
        {
            if (this.textBox1.Text.Equals(""))
                MessageBox.Show("Falta introducir parametro"); 
            else
            {
                MessageBox.Show("Resultado de operacion: " + this.intVen.Operacion());
                this.Text = "Calculadora";
                this.textBox1.Text = "";
                this.textBox1.Focus();
            }
        }
        private void button3_Click(object sender, EventArgs e)
            => this.DialogResult = DialogResult.No;
    }
}
