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
        EUsuario usuario = new EUsuario();
        if (campoUsuario.Text.Contains("@"))
        {
            usuario = new DaoLogin().GetUsuarioxCorreo(campoUsuario.Text, campoPass.Text);
        }
        else
        {
           usuario = new DaoLogin().GetUsuario(campoUsuario.Text, campoPass.Text);
        }
     
        Session[Constantes.USUARIOS_LOGEADOS] = usuario;

        if (usuario != null)
        {
            if (usuario.Estado.Equals(Constantes.ESTADO_EN_ESPERA))
            {
                LB_Validacion.Text = "Su cuenta no ha sido activada.¡revise su correo!";
                LB_Validacion.Visible = true;
                return;
            }
            else if (usuario.Estado.Equals(Constantes.ESTADO_CAMBIO_PASS))
            {
                conexion();
                LB_Validacion.CssClass = "text-success";
                LB_Validacion.Text = "Satisfactorio.";
                LB_Validacion.Visible = true;
                usuario.Token = null;
                usuario.Session = usuario.NombreDeUsuario;
                usuario.VencimientoToken = null;
                usuario.Estado = Constantes.ESTADO_ACTIVO;
                new DaoUsuario().actualizarUsuario(usuario);
                Response.Redirect("~/Vistas/Home.aspx");
            }
            else if (usuario.Estado.Equals(Constantes.ESTADO_ACTIVO))
            {
                conexion();
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
    protected void conexion()
    {
        EAutentication autenticar = new EAutentication();
        Mac conexion = new Mac();
        autenticar.FechaInicio = DateTime.Now;
        autenticar.Ip = conexion.ip();
        autenticar.Mac = conexion.mac();
        autenticar.NombreDeUsuario = ((EUsuario)Session[Constantes.USUARIOS_LOGEADOS]).NombreDeUsuario;
        autenticar.Session = Session.SessionID;
        new DaoSeguridad().insertarAutentication(autenticar);
    }

}