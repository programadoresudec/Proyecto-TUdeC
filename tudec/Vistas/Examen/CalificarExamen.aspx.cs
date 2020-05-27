using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Examen_CalificarExamen : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_SELECCIONADO];

        if(usuario == null)
        {

            Response.Redirect("~/Vistas/Home.aspx");

        }

    }
}