//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;

//public partial class Master_Page_MasterPageUsuarioNoAutenticado : System.Web.UI.MasterPage
//{
//    protected void Page_Load(object sender, EventArgs e)
//    {

//    }


//    protected void Button1_Click(object sender, EventArgs e)
//    {

//    }

//    protected void BT_Iniciar_Sesion_Click(object sender, EventArgs e)
//    {

//        Response.Redirect("~/Vistas/Login.aspx");

//    }

//    protected void BT_Registrarse_Click(object sender, EventArgs e)
//    {

//        Response.Redirect("~/Vistas/Register.aspx");

//    }

//    protected void BT_Sobre_Nosotros_Click(object sender, EventArgs e)
//    {

//        Response.Redirect("~/Vistas/About.aspx");

//    }
//}


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void cajaBuscador_TextChanged(object sender, EventArgs e)
    {

        Session["Buscador"] = cajaBuscador.Text;

        Response.Redirect("~/Vistas/ListaDeResultadosDelBuscadorCursos.aspx");

    }

    protected void btnBuscar_Click(object sender, EventArgs e)
    {

    }
}
