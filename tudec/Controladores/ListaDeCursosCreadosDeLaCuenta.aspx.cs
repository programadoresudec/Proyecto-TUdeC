using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_ListaDeCursosDeLaCuenta : System.Web.UI.Page
{

    private static EUsuario usuario;

    protected void Page_Load(object sender, EventArgs e)
    {

        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

    }

    protected void tablaCursos_RowCreated(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;
     
        if (fila.Cells.Count > 1)
        {

            TableCell celdaArea = fila.Cells[1];
            TableCell celdaCalificacion = fila.Cells[4];
            TableCell celdaEditar = fila.Cells[5];
            TableCell celdaExpulsar = fila.Cells[6];
            TableCell celdaCalificar = fila.Cells[7];

            string nombreArea = celdaArea.Text;

            Image iconoArea = new Image();
            Image iconoEditar = new Image();
            Image iconoExpulsar = new Image();
            Image iconoCalificar = new Image();

            iconoEditar.ImageUrl = "~/Recursos/GestionCursos/Editar Curso.png";
            iconoExpulsar.ImageUrl = "~/Recursos/GestionCursos/Expulsar Usuarios.png";
            iconoCalificar.ImageUrl = "~/Recursos/GestionCursos/Calificar Exámenes.png";

            iconoArea.Width = 32;
            iconoArea.Height = 32;
            iconoEditar.Width = 32;
            iconoEditar.Height = 32;
            iconoExpulsar.Width = 32;
            iconoExpulsar.Height = 32;
            iconoCalificar.Width = 32;
            iconoCalificar.Height = 32;

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

                celdaEditar.Controls.Add(iconoEditar);
                celdaExpulsar.Controls.Add(iconoExpulsar);
                celdaCalificar.Controls.Add(iconoCalificar);

            }

        }

    }

    [WebMethod]
    public static List<string> GetNombresCursos(string prefixText)
    {

        GestionCurso gestorCurso = new GestionCurso();
        
        List<string> nombres = gestorCurso.GetCursosCreadosSrc(usuario, prefixText);

        return nombres;

    }


    protected void botonInscritos_Click(object sender, EventArgs e)
    {

        Response.Redirect("~/Vistas/Cursos/ListaDeCursosInscritosDeLaCuenta.aspx");

    }
}