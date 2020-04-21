using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_ListaDeCursosInscritosDeLaCuenta : System.Web.UI.Page
{

    private static EUsuario usuario;

    protected void Page_Load(object sender, EventArgs e)
    {

        usuario = (EUsuario)Session[Constantes.USUARIOS_LOGEADOS];

    }

    protected void tablaCursos_RowCreated(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;

        if (fila.Cells.Count > 1)
        {

            TableCell celdaArea = fila.Cells[1];
            TableCell celdaCalificacion = fila.Cells[4];
            TableCell celdaBoleta = fila.Cells[5];
            TableCell celdaCancelar = fila.Cells[6];

            string nombreArea = celdaArea.Text;

            Image iconoArea = new Image();
            Image iconoBoleta = new Image();
            Image iconoCancelar = new Image();

            iconoBoleta.ImageUrl = "~/Recursos/GestionCursos/Boleta Calificaciones.png";
            iconoCancelar.ImageUrl = "~/Recursos/GestionCursos/Cancelar Inscripción.png";

            iconoArea.Width = 32;
            iconoArea.Height = 32;
            iconoBoleta.Width = 32;
            iconoBoleta.Height = 32;
            iconoCancelar.Width = 32;
            iconoCancelar.Height = 32;

            if (fila.RowIndex > -1)
            {
                int calificacion = Int32.Parse(celdaCalificacion.Text);
                ASP.controles_estrellas_estrellas_ascx estrellasMostradas = new ASP.controles_estrellas_estrellas_ascx();
                estrellasMostradas.Calificacion = calificacion;
                celdaCalificacion.Controls.Add(estrellasMostradas);
                celdaCalificacion.Enabled = false;

                Buscador buscador = new Buscador();

                EArea area = buscador.GetAreasSrc().Where(x => x.Area == nombreArea).FirstOrDefault();

                iconoArea.ImageUrl = area.Icono;

                celdaArea.Controls.Add(iconoArea);

                celdaBoleta.Controls.Add(iconoBoleta);
                celdaCancelar.Controls.Add(iconoCancelar);

            }

        }

    }

    [WebMethod]
    public static List<string> GetNombresCursos(string prefixText)
    {

        GestionCurso gestorCurso = new GestionCurso();

        List<string> nombres = gestorCurso.GetCursosInscritosSrc(usuario, prefixText);

        return nombres;

    }

    [WebMethod]
    public static List<string> GetNombresTutores(string prefixText)
    {

        GestionCurso gestorCurso = new GestionCurso();

        List<string> nombres = gestorCurso.GetTutoresSrc(usuario, prefixText);

        return nombres;

    }


    protected void botonCreados_Click(object sender, EventArgs e)
    {

        Response.Redirect("~/Vistas/Cursos/ListaDeCursosCreadosDeLaCuenta.aspx");

    }
}