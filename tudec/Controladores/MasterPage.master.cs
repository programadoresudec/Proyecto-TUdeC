using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario != null)
        {
            LinkButton cerrarSesion = (LinkButton)(vistaLogin.FindControl("LinkBtnCerrarSesion"));
            cerrarSesion.Visible = true;
            HyperLink hiperEnlaceConfiguracionUsuario;

            if (usuario.Rol.Equals(Constantes.ROL_USER))
            {
               
                HyperLink hiperEnlaceCreacionCurso = acercaDeNosotros;
                HyperLink hiperEnlaceCursosCuenta = (HyperLink)(vistaLogin.FindControl("iniciarSesion"));
                hiperEnlaceConfiguracionUsuario = (HyperLink)(vistaLogin.FindControl("registrarse"));
                hiperEnlaceCreacionCurso.Text = "Crear Curso";
                hiperEnlaceCursosCuenta.Text = "Mis Cursos";
                hiperEnlaceConfiguracionUsuario.Visible = false;
                hiperEnlaceCreacionCurso.NavigateUrl = "";
                hiperEnlaceCursosCuenta.NavigateUrl = "~/Vistas/Cursos/ListaDeCursosCreadosDeLaCuenta.aspx";
           
            }
            else if (usuario.Rol.Equals(Constantes.ROL_ADMIN))
            {
                HyperLink hiperEnlaceAdministrarUsuarios = acercaDeNosotros;
                hiperEnlaceConfiguracionUsuario = (HyperLink)(vistaLogin.FindControl("registrarse"));
                hiperEnlaceAdministrarUsuarios.Text = "Administrar Usuarios";
                hiperEnlaceConfiguracionUsuario.Visible = false;
                ((HyperLink)(vistaLogin.FindControl("iniciarSesion"))).Visible = false;
                hiperEnlaceAdministrarUsuarios.NavigateUrl = "";
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
        autenticar.NombreDeUsuario = ((EUsuario)Session[Constantes.USUARIO_LOGEADO]).NombreDeUsuario;
        autenticar.Session = Session.SessionID;
        new DaoSeguridad().actualizarUsuarioAutentication(autenticar);
        Session[Constantes.USUARIO_LOGEADO] = null;
        Session.Abandon();
        Session.Clear();
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
}
