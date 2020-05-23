using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_ListaDeTemasDelCurso : System.Web.UI.Page
{
    private static EUsuario usuario;
    protected void Page_Load(object sender, EventArgs e)
    {
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario == null)
        {
            Response.Redirect("~/Vistas/Home.aspx");

        }
        else if (usuario != null && usuario.Rol.Equals(Constantes.ROL_ADMIN))
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
            hiperEnlaceTema.Click += new EventHandler(VerTema);

            celdaTituloTema.Controls.Add(hiperEnlaceTema);

        }

    }

    public void VerTema(object sender, EventArgs e)
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

        Response.Redirect("~/Vistas/Cursos/CreacionYEdicionTema.aspx");

    }



    protected void botonAgregarTema_Click(object sender, EventArgs e)
    {

        Session[Constantes.TEMA_SELECCIONADO] = null;
        Response.Redirect("~/Vistas/Cursos/CreacionYEdicionTema.aspx");

    }
}