using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Admin_ReportesPorUsuario : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        EUsuario usuario = (EUsuario)(Session[Constantes.USUARIO_LOGEADO]);

        if (usuario == null)
        {
            Response.Redirect("~/Vistas/Home.aspx");

        }
        else if (usuario != null && usuario.Rol.Equals(Constantes.ROL_USER))
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
    }

    protected void Quitar_Click(object sender, EventArgs e)
    {
        ListViewItem Item = ((LinkButton)sender).NamingContainer as ListViewItem;
        if (Item != null)
        {
            //PARA EL DATAKEY
            //int ID = (int)LV_Reportes.DataKeys[Item.DataItemIndex]["Id"];
            //BUSCANDO EL ID mediante un label
            int id = int.Parse(((Label)Item.FindControl("LB_IdReporte")).Text);
            string usuarioDenunciado = ((Label)Item.FindControl("LB_NombreUsuarioDenunciado")).Text;
            new DaoReporte().quitarReporte(id);
            LV_Reportes.DataBind();
            new DaoUsuario().bloquearUsuariosConCuenta(usuarioDenunciado);
        }
    }

    protected void LV_Reportes_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        LinkButton botonMensaje = (LinkButton)e.Item.FindControl("LinkB_Mensaje");
        LinkButton botonComentario = (LinkButton)e.Item.FindControl("LinkB_Comentario");
        string labelComentario = ((Label)e.Item.FindControl("ComentarioLabel")).Text;
        string imagenComentario = ((Image)e.Item.FindControl("ImagenesComentario")).ImageUrl;

        string labelMensaje = ((Label)e.Item.FindControl("MensajeLabel")).Text;
        string imagenMensaje = ((Image)e.Item.FindControl("ImagenesMensaje")).ImageUrl;

        if (string.IsNullOrEmpty(labelComentario) && string.IsNullOrEmpty(imagenComentario))
        {
            if (botonMensaje != null)
            {
                botonComentario.Visible = false;
            }
        }
        else if (string.IsNullOrEmpty(labelMensaje) && string.IsNullOrEmpty(imagenMensaje))
        {
            if (botonMensaje != null)
            {
                
                botonMensaje.Visible = false;
            }
        }
    }
}