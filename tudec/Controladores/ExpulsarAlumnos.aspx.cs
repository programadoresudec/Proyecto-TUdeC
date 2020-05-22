using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_ExpulsarAlumnos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        tablaUsuarios.DataBind();

    }

    protected void tablaUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = (GridViewRow)e.Row;

        if (fila.RowIndex > -1)
        {

            TableCell celdaNombre = fila.Cells[0];

            LinkButton hiperEnlaceCalificarExamen = new LinkButton();
            hiperEnlaceCalificarExamen.Text = celdaNombre.Text;
            hiperEnlaceCalificarExamen.Click += new EventHandler(Expulsar);

            celdaNombre.Controls.Add(hiperEnlaceCalificarExamen);

        }

    }

    public void Expulsar(object sender, EventArgs e)
    {

        LinkButton hiperEnlace = (LinkButton)sender;

        DaoUsuario gestorUsuarios = new DaoUsuario();
        GestionCurso gestorCursos = new GestionCurso();

        EUsuario usuario = gestorUsuarios.GetUsuario(hiperEnlace.Text);
        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO_PARA_EXPULSAR_ALUMNOS];

        EInscripcionesCursos inscripcion = gestorCursos.GetInscripcion(usuario, curso);

        Base.Eliminar(inscripcion);

        Response.Redirect("~/Vistas/Cursos/ExpulsarAlumnos.aspx");

    }

}
