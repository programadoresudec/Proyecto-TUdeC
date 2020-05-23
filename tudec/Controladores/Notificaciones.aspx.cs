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
            Session[Constantes.NOTIFICACIONES] = usuario.NombreDeUsuario;
            if (new DaoNotificacion().tieneNotificaciones(usuario.NombreDeUsuario) == 0)
            {
                LNB_EnVistoTodos.Visible = false;
                LB_TieneNotificaciones.Visible = true;
            }
        }
        else
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
    }

    protected void LNB_EnVistoTodos_Click(object sender, EventArgs e)
    {
        new DaoNotificacion().MarcarEnVistoTodas(usuario.NombreDeUsuario);
    }

    protected void LNB_Borrar_Click(object sender, EventArgs e)
    {
        
        DataListItem Item = ((LinkButton)sender).NamingContainer as DataListItem;
        if (Item != null)
        {
            int id = int.Parse(((Label)Item.FindControl("LB_id")).Text);
            new DaoNotificacion().eliminar(id);
        }
        DL_Notificaciones.DataBind();
    }
}