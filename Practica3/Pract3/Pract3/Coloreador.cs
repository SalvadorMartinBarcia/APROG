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
        List<Tuple<ApartadoDVentana.Provincia, ColorProvincia>> sol;
        TableLayoutPanelCellPosition pos1, pos2;

        int cont = 0;
        bool primerClick = false;

        //-------------------------------------------------------//

        public Coloreador()
        {
            InitializeComponent();
        }

        private void button_Click(object sender, EventArgs e)
        {
            Control ctrl = ((Control)sender);

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

                cont++;

                ApartadoDVentana.Provincia prov = new ApartadoDVentana.Provincia(   pos1.Column, 
                                                                                    pos1.Row, 
                                                                                    pos2.Column+1, 
                                                                                    pos2.Row+1,
                                                                                    cont.ToString());
                // Meter provincia en la lista
                ApartadoDVentana.provs.Add(prov);

                // Comprobar solapados

                // Encontrar fronteras
                ApartadoDVentana.fronteras = ApartadoDVentana.EncontrarFronteras(ApartadoDVentana.provs);

                // Creamos Mapa
                ApartadoDVentana.andalucia = ApartadoDVentana.CrearMapa(ApartadoDVentana.provs);
                
                // Encontrar solucion
                sol = ApartadoDVentana.SolucionColorear(
                    new Tuple<ApartadoDVentana.Mapa, List<ColorProvincia>>( ApartadoDVentana.andalucia, 
                                                                            ApartadoDVentana.coloresDisponibles));
                // Pintar la nueva provincia en mapa
                FuncionIntroducirProvincias(sol);

                // Mostrar Nuevo mapa

            }
        }

        private void FuncionIntroducirProvincias(List<Tuple<ApartadoDVentana.Provincia, ColorProvincia>> sol)
        {

            foreach (Tuple<ApartadoDVentana.Provincia, ColorProvincia> t in sol)
            {
                for(int i = t.Item1.CoordenadaXSup; i < t.Item1.CoordenadaXInf; i++)
                {
                    for (int j = t.Item1.CoordenadaYSup; j < t.Item1.CoordenadaYInf; j++)
                    {
                        if (t.Item2 == ColorProvincia.Rojo)
                        {

                        }
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
                    }
                }
                
            }

        }
    }
}
