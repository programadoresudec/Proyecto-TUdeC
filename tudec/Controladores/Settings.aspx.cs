using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Account_Settings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        EUsuario usuario = (EUsuario)(Session[Constantes.USUARIO_LOGEADO]);
        //if (usuario != null)
        //{
        //    if (this.IsPostBack)
        //    {
        //        TabName.Value = Request.Form[TabName.UniqueID];
        //    }
        //    ImagenPerfil.ImageUrl = new DaoUsuario().buscarImagen(usuario.NombreDeUsuario);
        //    ImagenPerfil.DataBind();
        //    LbNombreUsuario.Text = usuario.NombreDeUsuario;
        //}
        //else
        //{
        //    Response.Redirect("~/Vistas/Home.aspx");
        //}
    }

    protected void BtnCambiarPass_Click(object sender, EventArgs e)
    {
        EUsuario usuario = (EUsuario)(Session[Constantes.USUARIO_LOGEADO]);
        EUsuario cambiarPass = new EUsuario();
        //if (new DaoUsuario().validarPassActual(usuario.NombreDeUsuario, passActual.Text))
        //{
        //    new DaoUsuario().actualizarPass(usuario.NombreDeUsuario, passNueva.Text);
        //    LB_ValidacionPass.CssClass = "alert alert-success";
        //    LB_ValidacionPass.Text = "Tus cambios han sido guardadados con exito.";
        //    LB_ValidacionPass.Visible = true;
        //}
        //else
        //{
        //    LB_ValidacionPass.CssClass = "alert alert-danger";
        //    LB_ValidacionPass.Text = "Su contraseña actual no coincide.";
        //    LB_ValidacionPass.Visible = true;
        //}
    }
}