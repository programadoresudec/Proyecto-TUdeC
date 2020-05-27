using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_VerMisNotas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO_PARA_VER_NOTAS];

        if(curso == null)
        {

            Response.Redirect("~/Vistas/Home.aspx");

        }

        tablaTemario.DataBind();

    }

    protected void tablaTemario_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = (GridViewRow)e.Row;

        if (fila.RowIndex > -1)
        {

            TableCell celdaTituloTema = fila.Cells[0];

            LinkButton hiperEnlaceTema = new LinkButton();
            hiperEnlaceTema.Text = celdaTituloTema.Text;
            hiperEnlaceTema.Click += new EventHandler(VerNota);

            celdaTituloTema.Controls.Add(hiperEnlaceTema);

        }

    }

    public void VerNota(object sender, EventArgs e)
    {

        LinkButton hiperEnlace = (LinkButton)sender;

        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in tablaTemario.Rows)
        {

            if (fila.Cells[0].Controls.Contains(hiperEnlace))
            {

                filaAEncontrar = fila;
                break;

            }

        }

        int indiceTema = Int32.Parse(tablaTemario.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionTemas gestorTemas = new GestionTemas();

        ETema tema = gestorTemas.GetTema(indiceTema);

        Session[Constantes.TEMA_SELECCIONADO] = tema;

        Session[Constantes.USUARIO_SELECCIONADO] = Session[Constantes.USUARIO_LOGEADO];

        Session[Constantes.CALIFICACION_EXAMEN] = false;

        Response.Redirect("~/Vistas/Examen/CalificarExamen.aspx");

    }


}