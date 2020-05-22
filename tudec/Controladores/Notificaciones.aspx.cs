using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Notificaciones_Notificaciones : System.Web.UI.Page
{
    EUsuario usuario;
    protected void Page_Load(object sender, EventArgs e)
    {
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario != null)
        {
            if (new DaoNotificacion().notificacionesDelUsuario(usuario.NombreDeUsuario) == null)
            {
                LB_TieneNotificaciones.Visible = true;
            }
        }
        else
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
    }
}