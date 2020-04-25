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
        DaoUsuario gestorUsuarios = new DaoUsuario();
        EUsuario usuario = gestorUsuarios.GetUsuario("Kali");
        Session["UsuarioSeleccionado"] = usuario;

        etiquetaNombreUsuario.Text = usuario.NombreDeUsuario;
        etiquetaNombre.Text = usuario.PrimerNombre + " " + usuario.SegundoNombre;
        etiquetaApellido.Text = usuario.PrimerApellido + " " + usuario.SegundoApellido;
        etiquetaPuntuacion.Text = "" + usuario.Puntuacion;


    }
}