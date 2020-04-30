using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
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
                    Session[Constantes.USUARIO_ID] = usuario;
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
        EUsuario restablecer = (EUsuario)Session[Constantes.USUARIO_ID];
        restablecer.Token = null;
        restablecer.Session = restablecer.NombreDeUsuario;
        restablecer.VencimientoToken = null;
        restablecer.Pass = cajaPass.Text;
        restablecer.Estado = Constantes.ESTADO_ACTIVO;
        Base.Actualizar(restablecer);
        LB_Validacion.CssClass = "alert alert-success";
        LB_Validacion.Text = "Su Contraseña ha sido Actualizada.";
        LB_Validacion.Visible = true;
        restablecer = null;
        return;
    }
}
