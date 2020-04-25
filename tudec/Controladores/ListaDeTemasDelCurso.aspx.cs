using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_ListaDeTemasDelCurso : System.Web.UI.Page
{
    private static EUsuario usuario;
    protected void Page_Load(object sender, EventArgs e)
    {
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario == null)
        {
            Response.Redirect("~/Vistas/Home.aspx");

        }
        else if (usuario != null && usuario.Rol.Equals(Constantes.ROL_ADMIN))
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
    }
}