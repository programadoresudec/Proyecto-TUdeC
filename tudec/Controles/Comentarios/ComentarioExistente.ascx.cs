using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_Comentarios_ComentarioExistente : System.Web.UI.UserControl
{
    private int idComentario;
    private string nombreUsuario;
    private string contenido;

    private List<EComentario> comentariosHilo;
    private LinkButton opcionHilo;

    public string NombreUsuario { get => nombreUsuario; set => nombreUsuario = value; }
    public string Contenido { get => contenido; set => contenido = value; }
    public int IdComentario { get => idComentario; set => idComentario = value; }

    protected void Page_Load(object sender, EventArgs e)
    {

        etiquetaUsuario.Text = nombreUsuario;
        cajaComentarios.Text = contenido;

        GestionComentarios gestorComentarios = new GestionComentarios();
        
        if (idComentario != 0)
        {

            comentariosHilo = gestorComentarios.GetComentarios(gestorComentarios.GetComentario(idComentario));

            opcionHilo = new LinkButton();
            opcionHilo.Click += new EventHandler(VerHilo);

            if (comentariosHilo.Count > 0)
            {

                opcionHilo.Text = "Ver respuestas";

            }
            else
            {

                opcionHilo.Text = "Responder";

            }

            panelOpcion.Controls.Add(opcionHilo);

        }        

    }

    public void VerHilo(object sender, EventArgs e)
    {

        opcionHilo = new LinkButton();
        opcionHilo.Text = "Ocultar";
        opcionHilo.Click += new EventHandler(OcultarHilo);

        panelOpcion.Controls.Clear();
        panelOpcion.Controls.Add(opcionHilo);

        ASP.controles_comentarios_nuevocomentario_ascx nuevoComentario = new ASP.controles_comentarios_nuevocomentario_ascx();

        panelHilo.Controls.Add(nuevoComentario);

        foreach(EComentario comentario in comentariosHilo)
        {

            ASP.controles_comentarios_comentarioexistente_ascx comentarioHilo = new ASP.controles_comentarios_comentarioexistente_ascx();
            comentarioHilo.nombreUsuario = comentario.Emisor;
            comentarioHilo.contenido = comentario.Comentario;

            panelHilo.Controls.Add(comentarioHilo);

        }


    }

    public void OcultarHilo(object sender, EventArgs e)
    {

        panelHilo.Controls.Clear();

        opcionHilo = new LinkButton();
        opcionHilo.Click += new EventHandler(VerHilo);

        panelOpcion.Controls.Clear();
        panelOpcion.Controls.Add(opcionHilo);

        if (comentariosHilo.Count > 0)
        {

            opcionHilo.Text = "Ver respuestas";

        }
        else
        {

            opcionHilo.Text = "Responder";

        }

    }

}