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
        // IspostBack solo se ejecuta una vez. el page Load.
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
                    usuario.Estado = Constantes.ESTADO_ACTIVO;
                    usuario.LastModify = DateTime.Now;
                    usuario.Token = null;
                    usuario.VencimientoToken = null;
                    usuario.Session = usuario.NombreDeUsuario;
                    Base.Actualizar(usuario);
                }
            }
            else
            {
                Response.Redirect("~/Vistas/Home.aspx");
            }
        }
    }

    protected void btnLogeo_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Vistas/Account/Login.aspx");
    }
}