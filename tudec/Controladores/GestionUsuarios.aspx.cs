using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Vistas_Admin_GestionUsuarios : System.Web.UI.Page
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
        else
        {
            GridViewGestionUsuario.DataBind();
        }
    }

    protected void botonVerReportes_Click(object sender, EventArgs e)
    {
        LinkButton btnDetalles = sender as LinkButton;
        GridViewRow gridV = (GridViewRow)btnDetalles.NamingContainer;
        Session[Constantes.USUARIO_CON_REPORTES] = gridV.Cells[1].Text;
        Response.Redirect("~/Vistas/Admin/ReportesPorUsuario.aspx");
    }

    [WebMethod]
    public static List<string> GetNombreUsuario(string prefixText)
    {
        List<string> nombres = new Buscador().GetUsuarios(prefixText);
        return nombres;
    }

    protected void DDL_Estado_SelectedIndexChanged(object sender, EventArgs e)
    {
        Console.WriteLine();
    }

    protected void GridViewGestionUsuario_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.FindControl("Estado") != null)
        {
            string estado = ((Label)e.Row.FindControl("Estado")).Text;
            LinkButton btnDesbloquear = (LinkButton)e.Row.FindControl("botonDesbloquear");
            if (estado.Equals(Constantes.ESTADO_BLOQUEADO))
            {
                btnDesbloquear.Enabled = true;
                btnDesbloquear.ForeColor = System.Drawing.Color.Red;
                btnDesbloquear.CssClass = "fa fa-lock fa-lg";
            }
            else
            {

                btnDesbloquear.ForeColor = System.Drawing.Color.Green;
                btnDesbloquear.CssClass = "fas fa-unlock fa-lg";
            }
        }
    }

    protected void botonDesbloquear_Click(object sender, EventArgs e)
    {
        LinkButton btnDesbloquear = sender as LinkButton;
        GridViewRow gridV = (GridViewRow)btnDesbloquear.NamingContainer;
        string estado = ((Label)gridV.FindControl("Estado")).Text;
        if (estado.Equals(Constantes.ESTADO_BLOQUEADO))
        {
            new DaoReporte().desbloquearUsuario(Session[Constantes.USUARIO_CON_REPORTES].ToString());
            lB_Exito.CssClass = "alert alert-success";
            lB_Exito.Visible = true;
            GridViewGestionUsuario.DataBind();
        }
    }
}