using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_ListaDeCursosDeLaCuenta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        GestionCurso gestor = new GestionCurso();
        Session["Usuario"] = gestor.GetUsuario("Frand");

    }

    protected void tablaCursos_RowCreated(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;

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
        iconoCalificar.ImageUrl ="~/Recursos/GestionCursos/Calificar Exámenes.png";

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