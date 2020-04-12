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
        ClientScriptManager cm = this.ClientScript;
        EUsuario usuarioEnRegistro = new EUsuario();
        usuarioEnRegistro.NombreDeUsuario = cajaNombreUsuario.Text;
        usuarioEnRegistro.Pass = cajaPass.Text;
        usuarioEnRegistro.PrimerNombre = cajaPrimerNombre.Text;
        usuarioEnRegistro.SegundoNombre = cajaSegundoNombre.Text;
        usuarioEnRegistro.PrimerApellido = cajaPrimerApellido.Text;
        usuarioEnRegistro.SegundoApellido = cajaSegundoApellido.Text;
        usuarioEnRegistro.FechaCreacion = DateTime.Now;
        usuarioEnRegistro.CorreoInstitucional = cajaEmail.Text + labelCorreoUdec.Text;
        usuarioEnRegistro.Rol = Constantes.ROL_USER;
        usuarioEnRegistro.Estado = Constantes.ESTADO_EN_ESPERA;
        usuarioEnRegistro.Token = new Encriptacion().encriptar(JsonConvert.SerializeObject(usuarioEnRegistro));
        usuarioEnRegistro.VencimientoToken = DateTime.Now.AddHours(3);
        new DaoRegister().registroUsuario(usuarioEnRegistro);
        if (usuarioEnRegistro.Estado.Equals(Constantes.ESTADO_UNIQUE))
        {
            LB_ErrorUsuario_Correo.Text = "Ese Correo Institucional ya está en uso. Prueba con otro.";
            LB_ErrorUsuario_Correo.Visible = true;
            usuarioEnRegistro = null;
        }
        else if (usuarioEnRegistro.Estado.Equals(Constantes.ESTADO_PK))
        {
            LB_ErrorUsuario_Correo.Text = "Ese Nombre de usuario ya está en uso. Prueba con otro.";
            LB_ErrorUsuario_Correo.Visible = true;
            usuarioEnRegistro = null;
        }

        if (usuarioEnRegistro != null)
        {
            labelValidandoCuenta.Text = "Revise el correo para activar su cuenta.";
            labelValidandoCuenta.Visible = true;
            new Correo().enviarCorreo(usuarioEnRegistro.CorreoInstitucional, usuarioEnRegistro.Token,
                Constantes.MENSAJE_VALIDAR_CUENTA, Constantes.URL_VALIDAR_CUENTA);
        }
    }
}