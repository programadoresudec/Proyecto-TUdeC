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
            acercaDeNosotros.Visible = false;
            ImagenPerfil.ImageUrl = new DaoUsuario().buscarImagen(usuario.NombreDeUsuario);
            ImagenPerfil.Visible = true;    
            ImagenPerfil.DataBind();
            ConfiguracionCuenta.Visible = true;
            iniciarSesion.Visible = false;
            registrarse.Visible = false;
            LinkBtnCerrarSesion.Visible = true;
            if (usuario.Rol.Equals(Constantes.ROL_USER))
            {
                
                misCursos.Visible = true;
                CursosCreados.Visible = true;
                CursosInscritos.Visible = true;
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
