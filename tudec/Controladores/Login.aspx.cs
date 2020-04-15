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
            if (usuario.Estado.Equals(Constantes.ESTADO_EN_ESPERA))
            {
               
                return;
            }
            else if (usuario.Estado.Equals(Constantes.ESTADO_CAMBIO_PASS))
            {
                LB_Validacion.Text = "";
                return;
            }
            else if (usuario.Estado.Equals(Constantes.ESTADO_ACTIVO))
            {
                LB_Validacion.CssClass = "text-success";
                LB_Validacion.Text = "Satisfactorio.";
                LB_Validacion.Visible = true;
                Response.Redirect("~/Vistas/Home.aspx");
            }
        }



        else
        {
            LB_Validacion.Text = "No Existe ese usuario.";
            LB_Validacion.Visible = true;
        }
    }

    protected void RestablecerPass_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Vistas/Account/VerificarEmail.aspx");
    }
}