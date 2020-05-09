using System;
using System.Collections.Generic;
using System.Web.Services;
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
        Response.Redirect("~/Vistas/Admin/ReportesPorUsuario.aspx");
    }

    protected void btnActualizar_Click(object sender, EventArgs e)
    {
        new DaoUsuario().bloquearUsuariosConCuenta();
    }
    [WebMethod]
    public static List<string> GetNombreUsuario(string prefixText)
    {
        return new Buscador().GetUsuariosReportados(prefixText);
    }

    protected void btnCerrar_Click(object sender, EventArgs e)
    {
        ModalBloquearUsuario.Hide();
    }
}