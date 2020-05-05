using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_Comentarios_NuevoComentario : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void botonEnvio_Click(object sender, EventArgs e)
    {

        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO];
        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

        EComentario comentario = new EComentario();

        comentario.Emisor = usuario.NombreDeUsuario;
        comentario.IdCurso = curso.Id;
        comentario.Comentario = cajaComentarios.Text;
        comentario.FechaEnvio = System.DateTime.Now;

        Base.Insertar(comentario);

        cajaComentarios.Text = "";

        string paginaContenedora = Page.GetType().ToString();

        if (paginaContenedora.Equals("ASP.vistas_cursos_informaciondelcurso_aspx"))
        {
            Response.Redirect("~/Vistas/Cursos/InformacionDelCurso.aspx");

        }
        else
        {



        }            

    }
}