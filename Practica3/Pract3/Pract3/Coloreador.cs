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
        int dimension;
        bool primerClick = false;

        //-------------------------------------------------------//

        public Coloreador(int dimension)
        {
            this.dimension = dimension;
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
                pos2 = this.tableLayoutPanel1.GetCellPosition((Control)sender);

                if (pos2.Row < pos1.Row || pos2.Column < pos1.Column)
                {
                    this.tableLayoutPanel1.GetControlFromPosition(pos1.Column, pos1.Row).BackColor = Control.DefaultBackColor;
                }
                else
                {
                    ctrl.BackColor = Color.Aqua;

                    ApartadoDVentana.Provincia prov = new ApartadoDVentana.Provincia(pos1.Column,
                                                                                        pos1.Row,
                                                                                        pos2.Column + 1,
                                                                                        pos2.Row + 1,
                                                                                        cont.ToString());
                    cont++;
                    // Meter provincia en la lista
                    ApartadoDVentana.provs.Add(prov);

                    // Comprobar solapados
                    if (ApartadoDVentana.CuadradosSolapados(ApartadoDVentana.provs))
                    {
                        ApartadoDVentana.provs.RemoveAt(ApartadoDVentana.provs.Count - 1);
                        Console.WriteLine("ERROR: La provincia \"{0}\" NO ha sido introducida", prov.Nombre);

                        this.tableLayoutPanel1.GetControlFromPosition(pos1.Column, pos1.Row).BackColor = Color.White;

                    }
                    else
                    {
                        // Encontrar fronteras
                        ApartadoDVentana.fronteras = ApartadoDVentana.EncontrarFronteras(ApartadoDVentana.provs);

                        // Creamos Mapa
                        ApartadoDVentana.andalucia = new ApartadoDVentana.Mapa(ApartadoDVentana.provs, ApartadoDVentana.fronteras);

                        // Encontrar solucion
                        sol = ApartadoDVentana.SolucionColorear(
                            new Tuple<ApartadoDVentana.Mapa, List<ColorProvincia>>(ApartadoDVentana.andalucia,
                                                                                    ApartadoDVentana.coloresDisponibles));
                        // Pintar la nueva provincia en mapa
                        FuncionIntroducirProvincias(sol);
                    }
                }
                primerClick = false;
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
