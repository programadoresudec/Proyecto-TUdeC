using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_VisualizacionDeSugerencias : System.Web.UI.Page
{
    private static DropDownList desplegable;

    protected void Page_Load(object sender, EventArgs e)
    {

        desplegable = desplegableLectura;
        tablaSugerencias.DataBind();

    }

    protected void tablaSugerencias_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;

        if (fila.Cells.Count > 1)
        {

            TableCell celdaEmisor = fila.Cells[0];
            TableCell celdaVerDetalles = fila.Cells[4];
            TableCell celdaVisto = fila.Cells[2];


            if (fila.RowIndex > -1)
            {

                ImageButton botonVerDetalles = new ImageButton();
                botonVerDetalles.ImageUrl = "~/Recursos/Imagenes/Sugerencias/VerDetalles.png";
                botonVerDetalles.Width = 32;
                botonVerDetalles.Height = 32;
                botonVerDetalles.Click += new ImageClickEventHandler(VerDetalles);
                ESugerencia sugerencia = (ESugerencia)fila.DataItem;
                botonVerDetalles.ID = sugerencia.Id.ToString();

                CheckBox checkBox = (CheckBox)celdaVisto.Controls[0];

                celdaVisto.Controls.Clear();

                if (checkBox.Checked)
                {
                    
                    celdaVisto.Text = "Sí";

                }
                else
                {

                    celdaVisto.Text = "No";

                }

                if (celdaEmisor.Text.Equals("&nbsp;"))
                {

                    celdaEmisor.Text = "Anónimo";

                }

                celdaVerDetalles.Controls.Add(botonVerDetalles);
               

            }

        }

    }


    [WebMethod]
    public static List<string> GetTitulosSugerencias(string prefixText)
    {

        Sugerencia gestorSugerencias = new Sugerencia();

        List<string> nombres = gestorSugerencias.GetTitulosSrc(desplegable.SelectedValue, prefixText);

        return nombres;

    }

    private void VerDetalles(object sender, EventArgs e)
    {

        ImageButton boton = (ImageButton)sender;
        Sugerencia gestorSugerencias = new Sugerencia();
        ESugerencia sugerencia = gestorSugerencias.GetSugerencia(Int32.Parse(boton.ID));
        Session["Sugerencia"] = sugerencia;
        Response.Redirect("~/Vistas/Sugerencias/DetallesSugerencia.aspx");

    }


    protected void desplegableLectura_SelectedIndexChanged(object sender, EventArgs e)
    {
        Console.WriteLine();
    }
}