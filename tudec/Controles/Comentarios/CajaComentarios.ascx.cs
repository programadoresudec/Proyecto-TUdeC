using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_CajaComentarios : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

        string paginaContenedora = Page.GetType().ToString();

        if (paginaContenedora.Equals("ASP.vistas_cursos_informaciondelcurso_aspx"))
        {

            ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO];
            EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

            GestionComentarios gestorComentarios = new GestionComentarios();
            List<EComentario> comentarios = gestorComentarios.GetComentarios(curso);

            foreach(EComentario comentario in comentarios)
            {

                ASP.controles_comentarios_comentarioexistente_ascx comentarioExistente = new ASP.controles_comentarios_comentarioexistente_ascx();
                comentarioExistente.IdComentario = comentario.Id;
                comentarioExistente.NombreUsuario = comentario.Emisor;
                comentarioExistente.Contenido = comentario.Comentario;

                panelComentarios.Controls.Add(comentarioExistente);

            }

        }
        else
        {

            ETema tema = (ETema)Session[Constantes.TEMA_SELECCIONADO];
            EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

            GestionComentarios gestorComentarios = new GestionComentarios();
            List<EComentario> comentarios = gestorComentarios.GetComentarios(tema);

            foreach (EComentario comentario in comentarios)
            {

                ASP.controles_comentarios_comentarioexistente_ascx comentarioExistente = new ASP.controles_comentarios_comentarioexistente_ascx();
                comentarioExistente.NombreUsuario = comentario.Emisor;
                comentarioExistente.Contenido = comentario.Comentario;

                panelComentarios.Controls.Add(comentarioExistente);

            }

        }


    }
}