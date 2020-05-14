using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_InterfazSubirImagen_InterfazSubirImagen : System.Web.UI.UserControl {


    protected void Page_Load(object sender, EventArgs e)
    {



    }



    protected void botonEnviar_Click(object sender, EventArgs e)
    {

        Session["subiendoImagen"] = false;

        Response.Redirect("~/Vistas/Chat/Chat.aspx");

    }
}