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
            usuarioEnRegistro.CorreoInstitucional = cajaEmail.Text + labelCorreoUdec.Text;
            usuarioEnRegistro.Rol = "usuario";
            usuarioEnRegistro.Estado = "espera de activacion";
            usuarioEnRegistro.Token = new seguridad().encriptar(JsonConvert.SerializeObject(usuarioEnRegistro));
            usuarioEnRegistro.VencimientoToken = DateTime.Now.AddHours(3);
            new DaoAccount().registroUsuario(usuarioEnRegistro);
    }
}