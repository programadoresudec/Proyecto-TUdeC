using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Views_Account_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CleanControl(this.Controls);
        }
    }

    protected void botonIniciar_Click(object sender, EventArgs e)
    {
        EUsuario usuario = new EUsuario();
        if (campoUsuario.Text.Contains("@"))
        {
            usuario = new DaoLogin().GetUsuarioxCorreo(campoUsuario.Text, campoPass.Text);
        }
        else
        {
            usuario = new DaoLogin().GetUsuarioxApodo(campoUsuario.Text, campoPass.Text);
        }

        Session[Constantes.USUARIO_LOGEADO] = usuario;

        if (usuario != null)
        {
            if (usuario.FechaDesbloqueo < DateTime.Now)
            {
                usuario.Estado = Constantes.ESTADO_ACTIVO;
                Base.Actualizar(usuario);
            }
            if (usuario.Estado.Equals(Constantes.ESTADO_EN_ESPERA))
            {
                usuario.VencimientoToken = DateTime.Now.AddHours(8);
                usuario.Token = Reutilizables.encriptar(JsonConvert.SerializeObject(usuario));
                Base.Actualizar(usuario);
                new Correo().enviarCorreo(usuario.CorreoInstitucional, usuario.Token,
           Constantes.MENSAJE_VALIDAR_CUENTA, Constantes.URL_VALIDAR_CUENTA, usuario.Estado);
                LB_Validacion.CssClass = "alert alert-warning";
                LB_Validacion.Text = "<Strong>Su cuenta esta por activar</strong>, se le ha vuelto a enviar un correo verifique.";
                LB_Validacion.Visible = true;
                Session.Contents.Remove(Constantes.USUARIO_LOGEADO);
                usuario = null;
                CleanControl(this.Controls);
                return;
            }
            else if (usuario.Estado.Equals(Constantes.ESTADO_REPORTADO))
            {
                LB_Validacion.CssClass = "alert alert-danger";
                LB_Validacion.Text = "Su cuenta esta reportada por: "
                    + ((TimeSpan)(usuario.FechaDesbloqueo.Value.Date - DateTime.Now.Date)).Days.ToString() + " Días";
                LB_Validacion.Visible = true;
                usuario = null;
                Session.Contents.Remove(Constantes.USUARIO_LOGEADO);
                CleanControl(this.Controls);
                return;
            }
            else if (usuario.Estado.Equals(Constantes.ESTADO_BLOQUEADO))
            {
                LB_Validacion.CssClass = "alert alert-danger";
                LB_Validacion.Text = "Su cuenta esta bloqueada comuniquese con el administrador via E-mail.";
                LB_Validacion.Visible = true;
                usuario = null;
                Session.Contents.Remove(Constantes.USUARIO_LOGEADO);
                CleanControl(this.Controls);
                return;
            }
            else if (usuario.Estado.Equals(Constantes.ESTADO_CAMBIO_PASS))
            {
                conexion();
                usuario.Token = null;
                usuario.Session = usuario.NombreDeUsuario;
                usuario.VencimientoToken = null;
                usuario.Estado = Constantes.ESTADO_ACTIVO;
                Base.Actualizar(usuario);
                Response.Redirect("~/Vistas/Home.aspx");
            }
            else if (usuario.Estado.Equals(Constantes.ESTADO_ACTIVO))
            {
                conexion();
                Response.Redirect("~/Vistas/Home.aspx");
            }
        }
        else
        {
            LB_Validacion.CssClass = "alert alert-danger";
            LB_Validacion.Text = "El nombre de la cuenta, correo  y/o la contraseña que has introducido son incorrectos.";
            LB_Validacion.Visible = true;
            CleanControl(this.Controls);
            return;
        }
    }
    protected void conexion()
    {
        EAutentication autenticar = new EAutentication();
        Mac conexion = new Mac();
        autenticar.FechaInicio = DateTime.Now;
        autenticar.FechaFin = null;
        autenticar.Ip = conexion.ip();
        autenticar.Mac = conexion.mac();
        autenticar.NombreDeUsuario = ((EUsuario)Session[Constantes.USUARIO_LOGEADO]).NombreDeUsuario;
        autenticar.Session = Session.SessionID;
        if (autenticar != null)
        {
            Base.Insertar(autenticar);
        }
    }
    [WebMethod]
    public static List<string> GetNombresCursos(string prefixText)
    {
        Buscador gestorBuscador = new Buscador();
        List<string> nombres = gestorBuscador.GetCursosSrc(prefixText);
        return nombres;
    }
    public void CleanControl(ControlCollection controles)
    {
        foreach (Control control in controles)
        {
            if (control is TextBox)
                ((TextBox)control).Text = null;
            else if (control.HasControls())
                //Esta linea detécta un Control que contenga otros Controles
                //Así ningún control se quedará sin ser limpiado.
                CleanControl(control.Controls);
        }
    }
}