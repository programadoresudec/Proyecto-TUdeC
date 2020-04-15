using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        EUsuario usuario = (EUsuario)(Session["Usuario"]);

        if (usuario != null)
        {

            HyperLink hiperEnlaceConfiguracionUsuario;

            if (usuario.Rol.Equals("usuario"))
            {
                HyperLink hiperEnlaceCreacionCurso = acercaDeNosotros;
                HyperLink hiperEnlaceCursosCuenta = (HyperLink)(vistaLogin.FindControl("iniciarSesion"));
                hiperEnlaceConfiguracionUsuario = (HyperLink)(vistaLogin.FindControl("registrarse"));

                hiperEnlaceCreacionCurso.Text = "Crear Curso";
                hiperEnlaceCursosCuenta.Text = "Mis Cursos";
                hiperEnlaceConfiguracionUsuario.Visible = false;

                hiperEnlaceCreacionCurso.NavigateUrl = "";
                hiperEnlaceCursosCuenta.NavigateUrl = "~/Vistas/ListaDeCursosCreadosDeLaCuenta.aspx";

            }
            else
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

        Response.Redirect("~/Vistas/ListaDeResultadosDelBuscadorCursos.aspx");

    }
}
