using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_DetallesSugerencia : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        ESugerencia sugerencia = (ESugerencia)Session["Sugerencia"];
        string valor = sugerencia.Contenido;
        titulo.Text = sugerencia.Titulo;

    }
}