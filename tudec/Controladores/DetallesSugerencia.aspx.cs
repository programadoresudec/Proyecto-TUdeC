using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_DetallesSugerencia : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        EUsuario usuario = (EUsuario)(Session[Constantes.USUARIO_LOGEADO]);
        if (usuario != null && usuario.Rol.Equals(Constantes.ROL_ADMIN))
        {
            ESugerencia sugerencia = (ESugerencia)Session["Sugerencia"];
            Sugerencia gestorSugerencias = new Sugerencia();
            string valor = sugerencia.Contenido;
            titulo.Text = sugerencia.Titulo;
            emisor.Text = sugerencia.Emisor;
            if (sugerencia.Emisor == null)
            {

                imagenUsuario.Visible = false;
                emisor.Visible = false;
            }
            else
            {
                imagenUsuario.ImageUrl = new DaoUsuario().buscarImagen(usuario.NombreDeUsuario);
            }
            sugerencia.Estado = true;
            Base.Actualizar(sugerencia);
        }
        else
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
    }
}