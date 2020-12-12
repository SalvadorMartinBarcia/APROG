﻿namespace ApartadoD
{
    partial class Coloreador
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void crearBoton(int x, int y, int tabIndex)
        {
            System.Windows.Forms.Button b = new System.Windows.Forms.Button();

            this.tableLayoutPanel1.Controls.Add(b, x, y);
            b.Dock = System.Windows.Forms.DockStyle.Fill;
            b.BackColor = System.Drawing.Color.White;
            b.TabIndex = tabIndex;

            b.TabStop = false;
            b.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            b.FlatAppearance.BorderSize = 0;

            b.Click += new System.EventHandler(this.button_Click);
        }

        private void crearBoton2(int x, int y, int tabIndex)
        {
            System.Windows.Forms.Button b = new System.Windows.Forms.Button();

            //this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));

            this.tableLayoutPanel2.Controls.Add(b, x, y);
            b.Dock = System.Windows.Forms.DockStyle.Fill;
            b.BackColor = System.Drawing.Color.White;
            b.TabIndex = tabIndex;
            b.Text = (x + 1).ToString() + " colores";
            b.TabStop = false;
            b.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            b.FlatAppearance.BorderSize = 0;

            b.Click += new System.EventHandler(this.button_Click_Color);
        }

        private void InitializeComponent()
        {

            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();

            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.BackColor = System.Drawing.Color.Aquamarine;
            
            this.tableLayoutPanel1.ColumnCount = dimension;

            for (int i = 0; i < dimension; i++)    // ASIGNAMOS ESTILO A CADA COLUMNA 
                this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, (100F / dimension)));

            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";

            this.tableLayoutPanel1.RowCount = dimension;

            for (int i = 0; i < dimension; i++)    // ASIGNAMOS ESTILO A CADA FILA
                this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, (100F / dimension)));

            this.tableLayoutPanel1.TabIndex = 0;

            for (int i = (dimension - 1); i >= 0; i--)    // CREAMOS LOS BOTONES
                for (int j = (dimension - 1); j >= 0; j--)
                    this.crearBoton(j, i, i * dimension + j);

            // 
            // tableLayoutPanel2
            //
            this.tableLayoutPanel2.ColumnCount = 5;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 20F));
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(0, 350);
            this.tableLayoutPanel2.Name = "tableLayoutPanel1";
            this.tableLayoutPanel2.RowCount = 1;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(800, 100);
            this.tableLayoutPanel2.TabIndex = 1;

            for (int j = 0; j < 5; j++)
                this.crearBoton2(j, 0, j);

            // 
            // Coloreador
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.tableLayoutPanel1);
            this.Controls.Add(this.tableLayoutPanel2);
            this.Name = "Coloreador";
            this.Text = "EL TEOREMA DE LOS CUATRO COLORES";
            this.tableLayoutPanel1.ResumeLayout(false);
            this.ResumeLayout(false);

        }
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
    }
}