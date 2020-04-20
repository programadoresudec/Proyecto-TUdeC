using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_InformacionDelUsuarioSeleccionado : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        GestionUsuario gestorUsuarios = new GestionUsuario();
        EUsuario usuario = gestorUsuarios.GetUsuario("Kali");
        Session["UsuarioSeleccionado"] = usuario;
    }
}