using System;
using System.Collections.Generic;
using System.Web.Services;

public partial class MasterPage : System.Web.UI.MasterPage
{
    EUsuario usuario;
    protected void Page_Load(object sender, EventArgs e)
    {
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario != null)
        {
            int numDeNotificaciones = new DaoNotificacion().numeroDeNotificaciones(usuario.NombreDeUsuario);
            if (numDeNotificaciones > 0)
            {
                LB_campana.Visible = true;
                Notificaciones.Text = "Tiene " + numDeNotificaciones.ToString() + "Notificaciones";
            }
            else
            {
                Notificaciones.Text = "No Tiene Notificaciones.";
            }
            BtnNotificaciones.Visible = true;
            ImagenPerfil.ImageUrl = new DaoUsuario().buscarImagen(usuario.NombreDeUsuario);
            ImagenPerfil.Visible = true;
            ImagenPerfil.DataBind();
            apodo.Text = usuario.NombreDeUsuario;
            iniciarSesion.Visible = false;
            registrarse.Visible = false;
            if (usuario.Rol.Equals(Constantes.ROL_USER))
            {
                misCursos.Visible = true;
                CrearCurso.Visible = true;
            }
            else if (usuario.Rol.Equals(Constantes.ROL_ADMIN))
            {
                AdministrarUser.Visible = true;
                Sugerencias.Visible = true;
            }
        }
    }

    protected void btnBuscar_Click(object sender, EventArgs e)
    {
        Session["Buscador"] = cajaBuscador.Text;
        Response.Redirect("~/Vistas/Buscador/ListaDeResultadosDelBuscadorCursos.aspx");
    }

    protected void LinkBtnCerrarSesion_Click(object sender, EventArgs e)
    {
        EAutentication autenticar = new EAutentication();
        EUsuario signOut = ((EUsuario)Session[Constantes.USUARIO_LOGEADO]);
        if (signOut != null)
        {
            autenticar.NombreDeUsuario = signOut.NombreDeUsuario;
            autenticar.Session = Session.SessionID;
            new DaoSeguridad().actualizarUsuarioAutentication(autenticar);
            Session.Contents.Remove(Constantes.USUARIO_LOGEADO);
            Session.Abandon();
            Session.Clear();
        }
        Response.Redirect("~/Vistas//Home.aspx");
    }

    protected void cajaBuscador_TextChanged(object sender, EventArgs e)
    {
        Session["Buscador"] = cajaBuscador.Text;
        Response.Redirect("~/Vistas/Buscador/ListaDeResultadosDelBuscadorCursos.aspx");
    }
    [WebMethod]
    public static List<string> GetNombresCursos(string prefixText)
    {
        Buscador gestorBuscador = new Buscador();
        List<string> nombres = gestorBuscador.GetCursosSrc(prefixText);
        return nombres;
    }

    protected void tiempoDeRefresco_Tick(object sender, EventArgs e)
    {
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario != null)
        {
            int numDeNotificaciones = new DaoNotificacion().numeroDeNotificaciones(usuario.NombreDeUsuario);
            if (numDeNotificaciones > 0)
            {
                LB_campana.Visible = true;
                Notificaciones.Text = "Tiene " + numDeNotificaciones.ToString() + "Notificaciones";
            }
            else
            {
                Notificaciones.Text = "No Tiene Notificaciones.";
            }
        }
    }

    protected void Notificaciones_Click(object sender, EventArgs e)
    {
        Session[Constantes.NOTIFICACIONES] = usuario.NombreDeUsuario;
        Response.Redirect("~/Vistas/Notificaciones/Notificaciones.aspx");
    }
}
