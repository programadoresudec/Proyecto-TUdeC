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
        Uri urlAnterior = Request.UrlReferrer;
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario != null)
        {
            Hyperlink_Devolver.NavigateUrl = urlAnterior == null ? "~/Vistas/Home.aspx" 
                : urlAnterior.ToString().Contains("Notificaciones") ? "~/Vistas/Home.aspx" : urlAnterior.ToString();
            Session[Constantes.NOTIFICACIONES] = usuario.NombreDeUsuario;
            if (new DaoNotificacion().tieneNotificaciones(usuario.NombreDeUsuario) == 0)
            {
                LNB_EnVistoTodos.Visible = false;
                LB_TieneNotificaciones.Visible = true;
                LNB_BorrarTodas.Visible = false;
            }
        }
        else
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
    }

    protected void LNB_EnVistoTodos_Click(object sender, EventArgs e)
    {
        new DaoNotificacion().marcarEnVistoTodas(usuario.NombreDeUsuario);
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
        Response.Redirect("~/Vistas/Notificaciones/Notificaciones.aspx");
    }

    protected void LNB_BorrarTodas_Click(object sender, EventArgs e)
    {
        new DaoNotificacion().eliminarTodas(usuario.NombreDeUsuario);
        DL_Notificaciones.DataBind();
        Response.Redirect("~/Vistas/Notificaciones/Notificaciones.aspx");
    }
}