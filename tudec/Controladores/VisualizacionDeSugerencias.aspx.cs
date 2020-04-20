using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_VisualizacionDeSugerencias : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        tablaSugerencias.DataBind();

    }

    protected void tablaSugerencias_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;
        TableCell celdaEmisor = fila.Cells[0];
        TableCell celdaVerDetalles = fila.Cells[4];

        if(fila.RowIndex > -1)
        {

            ImageButton botonVerDetalles = new ImageButton();
            botonVerDetalles.ImageUrl = "~/Recursos/Imagenes/Sugerencias/VerDetalles.png";
            botonVerDetalles.Width = 32;
            botonVerDetalles.Height = 32;
            botonVerDetalles.Click += new ImageClickEventHandler(VerDetalles);
            ESugerencia sugerencia = (ESugerencia)fila.DataItem;
            botonVerDetalles.ID = sugerencia.Id.ToString();

            if(celdaEmisor.Controls.Count == 0)
            {

                celdaEmisor.Text = "Anónimo";
                
            }

            celdaVerDetalles.Controls.Add(botonVerDetalles);

        }

    }

    private void VerDetalles(object sender, EventArgs e)
    {

        ImageButton boton = (ImageButton)sender;
        Sugerencia gestorSugerencias = new Sugerencia();
        ESugerencia sugerencia = gestorSugerencias.GetSugerencia(Int32.Parse(boton.ID));
        Session["Sugerencia"] = sugerencia;
        Response.Redirect("~/Vistas/Sugerencias/DetallesSugerencia.aspx");

    }
}