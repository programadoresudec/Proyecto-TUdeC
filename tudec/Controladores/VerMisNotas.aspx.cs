using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_VerMisNotas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        tablaTemario.DataBind();

    }

    protected void tablaTemario_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = (GridViewRow)e.Row;

        if (fila.RowIndex > -1)
        {

            TableCell celdaTituloTema = fila.Cells[0];

            LinkButton hiperEnlaceTema = new LinkButton();
            hiperEnlaceTema.Text = celdaTituloTema.Text;
            hiperEnlaceTema.Click += new EventHandler(VerNota);

            celdaTituloTema.Controls.Add(hiperEnlaceTema);

        }

    }

    public void VerNota(object sender, EventArgs e)
    {

    }


}