using System;


public partial class Vistas_Admin_GestionUsuarios : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        EUsuario usuario = (EUsuario)(Session[Constantes.USUARIO_LOGEADO]);
        if (usuario.Rol.Equals(Constantes.ROL_ADMIN))
        {

        }
    }
}