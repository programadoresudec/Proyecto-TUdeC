using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Views_Account_Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnRegistrar_Click(object sender, EventArgs e)
    {
        EUsuario usuarioEnRegistro = new EUsuario();
        usuarioEnRegistro.NombreDeUsuario = cajaNombreUsuario.Text;
        usuarioEnRegistro.Pass = cajaPass.Text;
        usuarioEnRegistro.PrimerNombre = cajaPrimerNombre.Text;
        usuarioEnRegistro.SegundoNombre = cajaSegundoNombre.Text;
        usuarioEnRegistro.PrimerApellido = cajaPrimerApellido.Text;
        usuarioEnRegistro.SegundoApellido = cajaSegundoApellido.Text;
        usuarioEnRegistro.FechaCreacion = DateTime.Now;
        usuarioEnRegistro.CorreoInstitucional = cajaEmail.Text + Constantes.CORREO_INSTITUCIONAL;
        usuarioEnRegistro.Rol = Constantes.ROL_USER;
        usuarioEnRegistro.Estado = Constantes.ESTADO_EN_ESPERA;
        usuarioEnRegistro.Token = Reutilizables.encriptar(JsonConvert.SerializeObject(usuarioEnRegistro));
        usuarioEnRegistro.VencimientoToken = DateTime.Now.AddHours(8);
        usuarioEnRegistro.ImagenPerfil = Constantes.IMAGEN_DEFAULT;
        new DaoRegister().registroUsuario(usuarioEnRegistro);

        if (usuarioEnRegistro.Estado.Equals(Constantes.ESTADO_PK))
        {
            labelValidar.CssClass = "alert alert-danger";
            labelValidar.Text = "Ese Nombre de usuario ya está en uso. Prueba con otro.";
            labelValidar.Visible = true;
            usuarioEnRegistro = null;
            return;
        }

        else if (usuarioEnRegistro.Estado.Equals(Constantes.ESTADO_UNIQUE))
        {
            labelValidar.CssClass = "alert alert-danger";
            labelValidar.Text = "Ese Correo Institucional ya está en uso. Prueba con otro.";
            labelValidar.Visible = true;
            usuarioEnRegistro = null;
            return;
        }

        if (usuarioEnRegistro != null)
        {
            new Correo().enviarCorreo(usuarioEnRegistro.CorreoInstitucional, usuarioEnRegistro.Token,
                Constantes.MENSAJE_VALIDAR_CUENTA, Constantes.URL_VALIDAR_CUENTA, usuarioEnRegistro.Estado);
            labelValidar.CssClass = "alert alert-success";
            labelValidar.Text = "Revise el correo para activar su cuenta.";
            labelValidar.Visible = true;
            usuarioEnRegistro = null;
        }
    }

}