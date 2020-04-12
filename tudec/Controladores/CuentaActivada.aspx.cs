using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Account_CuentaActivada : System.Web.UI.Page
{
    IToken verificarToken = new DaoRegister();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count > 0)
        {
            EUsuario usuario = verificarToken.buscarUsuarioxToken(Request.QueryString[0] == null ? "" : Request.QueryString[0]);

            if (usuario == null)
            {
                RegisterStartupScript("mensaje", "<script type='text/javascript'>alert('El Token es invalido. Genere uno nuevo');window.location=\"Login.aspx\"</script>");

            }
            else if (usuario.VencimientoToken < DateTime.Now)
            {
                RegisterStartupScript("mensaje", "<script type='text/javascript'>alert('El Token esta vencido. Genere uno nuevo');window.location=\"Login.aspx\"</script>");
            }
            else
            {
                Session["nombre_usuario"] = usuario;
                usuario.Estado = Constantes.ESTADO_ACTIVO;
                usuario.Token = null;
                usuario.VencimientoToken = null;
                usuario.Session = usuario.NombreDeUsuario;
                new DaoUsuario().actualizarUsuario(usuario);
            }
        }

        else
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
    }

    protected void btnLogeo_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Vistas/Account/Login.aspx");
    }
}