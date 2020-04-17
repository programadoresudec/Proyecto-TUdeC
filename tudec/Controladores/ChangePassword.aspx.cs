using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Account_ChangePassword : System.Web.UI.Page
{
    IToken verificarToken = new DaoLogin();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString.Count > 0)
            {
                EUsuario usuario = verificarToken.buscarUsuarioxToken(Request.QueryString[0] == null ? "" : Request.QueryString[0]);

                if (usuario == null)
                {
                    Response.Redirect("~/Vistas/Account/ValidacionToken.aspx?token=");
                }
                else if (usuario.VencimientoToken < DateTime.Now)
                {
                    Session[Constantes.VALIDAR_TOKEN] = Constantes.VALIDAR_TOKEN;
                    Response.Redirect("~/Vistas/Account/ValidacionToken.aspx?token=" + usuario.Token);
                }
                else
                {
                    Session["nombre_usuario"] = usuario;
                }
            }

            else
            {
                Response.Redirect("~/Vistas/Account/Login.aspx");
            }
        }       
    }

    protected void btnRestablecer_Click(object sender, EventArgs e)
    {

        EUsuario restablecer = (EUsuario)Session["nombre_usuario"];
        restablecer.Token = null;
        restablecer.Session = restablecer.NombreDeUsuario;
        restablecer.VencimientoToken = null;
        restablecer.Pass = cajaPass.Text;
        restablecer.Estado = Constantes.ESTADO_ACTIVO;
        new DaoUsuario().actualizarUsuario(restablecer);
        LB_Validacion.CssClass = "text-sucess";
        LB_Validacion.Text = "Su Contraseña ha sido Actualizada.";
        LB_Validacion.Visible = true;
    }
}
