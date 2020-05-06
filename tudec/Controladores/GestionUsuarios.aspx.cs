using System;
using System.Web.UI.WebControls;

public partial class Vistas_Admin_GestionUsuarios : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        EUsuario usuario = (EUsuario)(Session[Constantes.USUARIO_LOGEADO]);

        GridViewGestionUsuario.DataBind();
        if (usuario == null)
        {
            Response.Redirect("~/Vistas/Home.aspx");

        }
        else if (usuario != null && usuario.Rol.Equals(Constantes.ROL_USER))
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
    }

    protected void botonVerReportes_Click(object sender, EventArgs e)
    {
        LinkButton btnDetalles = sender as LinkButton;
        GridViewRow gridV = (GridViewRow)btnDetalles.NamingContainer;
        Session[Constantes.USUARIO_CON_REPORTES] = gridV.Cells[1].Text;
        this.ModalBloquearUsuario.Show();
    }

    protected void botonBloquearUsuario_Click(object sender, EventArgs e)
    {
        
    }

    protected void btnActualizar_Click(object sender, EventArgs e)
    {

    }

    protected void DataListReportes_ItemCommand(object source, DataListCommandEventArgs e)
    {
       
    }
}