using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_InformacionDelCurso : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        DaoUsuario gestorUsuarios = new DaoUsuario();

        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO];
        EUsuario creador = gestorUsuarios.GetUsuario(curso.Creador);

        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

        etiquetaTitulo.Text = curso.Nombre;
        etiquetaNombreUsuario.Text = curso.Creador;
        etiquetaNombre.Text = creador.PrimerNombre + " " + creador.SegundoNombre + " " + creador.PrimerApellido + " " + creador.SegundoApellido; ;
        etiquetaCorreo.Text = creador.CorreoInstitucional;
        etiquetaArea.Text = curso.Area;
        etiquetaDescripcion.Text = curso.Descripcion;
        imagenArea.Width = 32;
        imagenArea.Height = 32;
        imagenArea.ImageUrl = "~/Recursos/Imagenes/IconosAreas/" + curso.Area  + ".png";

        if(usuario == null || usuario.NombreDeUsuario.Equals(creador.NombreDeUsuario))
        {

            botonInbox.Visible = false;
            botonInscribirse.Visible = false;

        }
        else if (usuario.Rol.Equals(Constantes.ROL_ADMIN))
        {

            botonInscribirse.Visible = false;

        }

        tablaTemas.DataBind();

    }

    protected void tablaTemas_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;

        TableCell celdaTema = fila.Cells[0];

        if (fila.RowIndex > -1)
        {

            LinkButton hiperEnlaceTema = new LinkButton();
            hiperEnlaceTema.Text = celdaTema.Text;
            hiperEnlaceTema.Click += new EventHandler(VerTema);

            celdaTema.Controls.Add(hiperEnlaceTema);

        }

    }

    public void VerTema(object sender, EventArgs e)
    {
        LinkButton hiperEnlace = (LinkButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach(GridViewRow fila in tablaTemas.Rows)
        {

            if (fila.Cells[0].Controls.Contains(hiperEnlace))
            {

                filaAEncontrar = fila;
                break;

            }

        }

        int idTema = Int32.Parse(tablaTemas.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionTemas gestorTemas = new GestionTemas();
        ETema tema = gestorTemas.GetTema(idTema);


        Session[Constantes.TEMA_SELECCIONADO] = tema;

        Response.Redirect("~/Vistas/Cursos/visualizacionTemaDelCurso.aspx");

    }
}