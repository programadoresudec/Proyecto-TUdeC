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

        

        string paginaContenedora = Page.GetType().ToString();

        if (paginaContenedora.Equals("ASP.vistas_cursos_informaciondelcurso_aspx"))
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

            Response.Redirect("~/Vistas/Cursos/InformacionDelCurso.aspx");

        }
        else
        {

            ETema tema = (ETema)Session[Constantes.TEMA_SELECCIONADO];
            EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

            EComentario comentario = new EComentario();

            comentario.Emisor = usuario.NombreDeUsuario;
            comentario.IdTema = tema.Id;
            comentario.Comentario = cajaComentarios.Text;
            comentario.FechaEnvio = System.DateTime.Now;

            Base.Insertar(comentario);

            cajaComentarios.Text = "";

            Response.Redirect("~/Vistas/Cursos/visualizacionTemaDelCurso.aspx");


        }            

    }
}