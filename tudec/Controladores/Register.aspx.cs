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
        usuarioEnRegistro.Rol = "usuario";
        usuarioEnRegistro.Estado = "espera de activacion";
        usuarioEnRegistro.Token = new seguridad().encriptar(JsonConvert.SerializeObject(usuarioEnRegistro));
        usuarioEnRegistro.VencimientoToken = DateTime.Now.AddHours(3);
        new DaoAccount().registroUsuario(usuarioEnRegistro);
        if (usuarioEnRegistro.Estado.Equals("en uso"))
        {
            //if (u)
            //{
            LB_ErrorUsuario_Correo.Text = "Ese Correo Institucional ya está en uso. Prueba con otro.";
            usuarioEnRegistro = null;
            //}
            //else if (true)
            //{
            //    LB_ErrorUsuario_Correo.Text = "Ese Nombre de usuario ya está en uso. Prueba con otro.";
            //    return;
            //} 
        }
        if (usuarioEnRegistro != null)
        {
            labelValidandoCuenta.Text = "Revise el correo para activar su cuenta.";
        }
    }
}