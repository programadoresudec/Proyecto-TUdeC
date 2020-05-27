using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_Estrellas_EstrellasPuntuacionUsuario : System.Web.UI.UserControl
{

    private List<ImageButton> estrellas;


    private int calificacion = 0;

    public int Calificacion { get => calificacion; set => calificacion = value; }

    protected void pintarEstrellas(object sender, EventArgs e)
    {



        ImageButton estrella = (ImageButton)sender;

        int nuevaCalificacion = estrellas.IndexOf(estrella) + 1;

        if (Calificacion != nuevaCalificacion)
        {

            Calificacion = estrellas.IndexOf(estrella) + 1;


            for (int i = 0; i < estrellas.IndexOf(estrella) + 1; i++)
            {

                estrellas[i].ImageUrl = "~/Controles/Estrellas/EstrellaMarcada.png";

            }



            for (int i = estrellas.IndexOf(estrella) + 1; i < estrellas.Count(); i++)
            {

                estrellas[i].ImageUrl = "~/Controles/Estrellas/Estrella.png";

            }

        }
        else
        {

            Calificacion = 0;

            foreach (ImageButton estrellaIteradora in estrellas)
            {

                estrellaIteradora.ImageUrl = "~/Controles/Estrellas/Estrella.png";

            }

        }

        CalificarCurso();

        Response.Redirect(Request.Url.AbsolutePath);

    }

    private void CalificarCurso()
    {

        EUsuario emisor = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO];

        GestionCurso gestorCursos = new GestionCurso();
        EPuntuacion puntuacion = gestorCursos.GetPuntuacion(emisor, curso);

        if (puntuacion != null)
        {

            puntuacion.Puntuacion = calificacion;
            Base.Actualizar(puntuacion);

        }
        else
        {

            puntuacion = new EPuntuacion();
            puntuacion.Emisor = emisor.NombreDeUsuario;
            puntuacion.IdCurso = curso.Id;
            puntuacion.Puntuacion = calificacion;

            Base.Insertar(puntuacion);

        }

        List<EPuntuacion> puntuaciones = gestorCursos.GetPuntuacionesCurso(curso);
        int promedio = 0;

        foreach (EPuntuacion elemento in puntuaciones)
        {

            promedio += elemento.Puntuacion;

        }

        promedio /= puntuaciones.Count();

        curso.Puntuacion = promedio;

        Base.Actualizar(curso);

    }

    protected void Page_Load(object sender, EventArgs e)
    {


        estrellas = new List<ImageButton>();

        estrellas.Add(estrella1);
        estrellas.Add(estrella2);
        estrellas.Add(estrella3);
        estrellas.Add(estrella4);
        estrellas.Add(estrella5);

        if (Calificacion == 0)
        {

            foreach (ImageButton estrella in estrellas)
            {

                if (estrella.ImageUrl == "~/Controles/Estrellas/EstrellaMarcada.png")
                {

                    Calificacion++;

                }

            }

            for (int i = 0; i < Calificacion; i++)
            {

                estrellas[i].ImageUrl = "~/Controles/Estrellas/EstrellaMarcada.png";

            }



            for (int i = Calificacion + 1; i < estrellas.Count(); i++)
            {

                estrellas[i].ImageUrl = "~/Controles/Estrellas/Estrella.png";

            }

        }
        else
        {

            for (int i = 0; i < Calificacion; i++)
            {

                estrellas[i].ImageUrl = "~/Controles/Estrellas/EstrellaMarcada.png";

            }


        }
    }
}