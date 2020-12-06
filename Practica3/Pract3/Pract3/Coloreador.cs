using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Pract3
{
    public partial class Coloreador : Form
    {
        TableLayoutPanelCellPosition pos1, pos2;

        bool primerClick = false;

        public Coloreador()
        {
            InitializeComponent();
        }

        private void button_Click(object sender, EventArgs e)
        {
            Control ctrl = ((Control)sender);

            //MessageBox.Show("Cell chosen: " + this.tableLayoutPanel1.GetCellPosition((Control)sender));

            if (primerClick == false) // Primera coordenada seleccionada
            {
                primerClick = true;
                ctrl.BackColor = Color.Aqua;
                pos1 = this.tableLayoutPanel1.GetCellPosition((Control)sender);
            }
            else // Segunda coordenada seleccionada
            {
                primerClick = false;
                ctrl.BackColor = Color.Aqua;

                pos2 = this.tableLayoutPanel1.GetCellPosition((Control)sender);

            }
        }
    }
}
