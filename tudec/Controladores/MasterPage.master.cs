using System;
using System.Collections.Generic;
using System.Threading;
using System.Web.Services;

public partial class MasterPage : System.Web.UI.MasterPage
{
    EUsuario usuario;
    protected void Page_Load(object sender, EventArgs e)
    {
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario != null)
        {
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
                PanelFooterUser.Visible = false;
                PanelFooterAdmin.Visible = true;
                acercaDeNosotros.Visible = false;
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

    protected void CrearCurso_Click(object sender, EventArgs e)
    {

        Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR] = null;
        Response.Redirect("~/Vistas/Cursos/CreacionYEdicionCurso.aspx");

    }
}
