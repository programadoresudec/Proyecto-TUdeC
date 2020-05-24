using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Descripción breve de ComentariosService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente. 
[System.Web.Script.Services.ScriptService]
public class ComentariosService : System.Web.Services.WebService
{

    public ComentariosService()
    {

        //Elimine la marca de comentario de la línea siguiente si utiliza los componentes diseñados 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public void SubirComentario(string paginaContenedora, string contenidoCaja, string idComentarioString)
    {

        int idComentario = Int32.Parse(idComentarioString);

        if (paginaContenedora.Equals("ASP.vistas_cursos_informaciondelcurso_aspx"))
        {

            ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO];
            EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

            EComentario comentario = new EComentario();

            comentario.Emisor = usuario.NombreDeUsuario;

            if (idComentario != 0)
            {
                comentario.IdComentario = idComentario;
            }
            else
            {
                comentario.IdCurso = curso.Id;
            }

            comentario.Comentario = contenidoCaja;
            comentario.FechaEnvio = System.DateTime.Now;
            Base.Insertar(comentario);
            if (comentario.IdComentario != null)
            {
                string nombreReceptor = new DaoNotificacion().buscarNombreReceptor(comentario.IdComentario);
                if (nombreReceptor != usuario.NombreDeUsuario)
                {
                    ENotificacion notificacionComentario = new ENotificacion();
                    notificacionComentario.Estado = true;
                    notificacionComentario.Fecha = DateTime.Now;
                    notificacionComentario.Mensaje = "Tiene un nuevo comentario: " + comentario.Comentario;
                    notificacionComentario.NombreDeUsuario = nombreReceptor;
                    Base.Insertar(notificacionComentario);
                }
            }
        }
        else
        {

            ETema tema = (ETema)Session[Constantes.TEMA_SELECCIONADO];
            EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

            EComentario comentario = new EComentario();

            comentario.Emisor = usuario.NombreDeUsuario;


            if (idComentario != 0)
            {
                comentario.IdComentario = idComentario;
            }
            else
            {
                comentario.IdTema = tema.Id;
            }
            comentario.Comentario = contenidoCaja;
            comentario.FechaEnvio = System.DateTime.Now;

            Base.Insertar(comentario);

        }



    }

}
