using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Views_Account_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void botonIniciar_Click(object sender, EventArgs e)
    {
        var usuario = new EUsuario();
        if (campoUsuario.Text.Contains("@"))
        {
            usuario = new DaoLogin().GetUsuarioxCorreo(campoUsuario.Text, campoPass.Text);
        }
        else
        {
           usuario = new DaoLogin().GetUsuario(campoUsuario.Text, campoPass.Text);
        }
     
        Session["Usuario"] = usuario;

        if (usuario != null)
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
        else
        {
            LB_usuarioNoExiste.Text = "No Existe ese usuario.";
            LB_usuarioNoExiste.Visible = true;
        }
    }
}