using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ApartadoB
{
    public partial class Coloreador : Form
    {
        List<Tuple<ApartadoBVentana.Provincia, ColorProvincia>> sol;

        int cont = 0;

        //-------------------------------------------------------//

        public Coloreador()
        {
            InitializeComponent();
            pintarMapa();
        }

        private void pintarMapa()
        {
            List<ColorProvincia> colores1 = new List<ColorProvincia>() {    ColorProvincia.Rojo,
                                                                            ColorProvincia.Verde,
                                                                            ColorProvincia.Azul };

            sol = ApartadoBVentana.SolucionColorear(
                new Tuple<ApartadoBVentana.Mapa, List<ColorProvincia>>(ApartadoBVentana.andalucia,
                                                                        colores1));
            // Pintar la nueva provincia en mapa
            FuncionIntroducirProvincias(sol);
                
        }

        private void FuncionIntroducirProvincias(List<Tuple<ApartadoBVentana.Provincia, ColorProvincia>> sol)
        {
            foreach (Tuple<ApartadoBVentana.Provincia, ColorProvincia> t in sol)
            {
                for (int i = t.Item1.CoordenadaXSup; i < t.Item1.CoordenadaXInf; i++)
                {
                    for (int j = t.Item1.CoordenadaYSup; j < t.Item1.CoordenadaYInf; j++)
                    {
                        switch (t.Item2)
                        {
                            case ColorProvincia.Rojo: // Rojo
                                this.tableLayoutPanel1.GetControlFromPosition(i, j).BackColor = Color.Red;
                                break;
                            case ColorProvincia.Verde: // Verde
                                this.tableLayoutPanel1.GetControlFromPosition(i, j).BackColor = Color.Green;
                                break;
                            case ColorProvincia.Azul: // Azul
                                this.tableLayoutPanel1.GetControlFromPosition(i, j).BackColor = Color.Blue;
                                break;
                            case ColorProvincia.Morado: // Morado
                                this.tableLayoutPanel1.GetControlFromPosition(i, j).BackColor = Color.Purple;
                                break;
                            case ColorProvincia.Lila: // Lila
                                this.tableLayoutPanel1.GetControlFromPosition(i, j).BackColor = Color.LightPink;
                                break;
                        }
                        this.tableLayoutPanel1.GetControlFromPosition(i, j).Enabled = false;
                    }
                }
            }
        }
    }
}
