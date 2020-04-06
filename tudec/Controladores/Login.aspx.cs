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

        Login gestorLogin = new Login();

        EUsuario usuario = gestorLogin.GetUsuario(campoUsuario.Text, campoPass.Text);

        Session["Usuario"] = usuario;

        if(usuario != null)
        {

            Response.Redirect("~/Vistas/Home.aspx");

        }

    }
}