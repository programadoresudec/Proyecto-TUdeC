using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_InformacionDelCurso : System.Web.UI.Page
{

    private bool inscripcion;
    private EUsuario creador;
    private EUsuario usuario;

    protected void Page_Load(object sender, EventArgs e)
    {
        Uri urlAnterior = Request.UrlReferrer;
        DaoUsuario gestorUsuarios = new DaoUsuario();
        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO];
        if (curso != null)
        {
            Hyperlink_Devolver.NavigateUrl = urlAnterior == null ? "~/Vistas/Home.aspx" : urlAnterior.ToString();
            creador = gestorUsuarios.GetUsuario(curso.Creador);

            usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

            GestionCurso gestorCursos = new GestionCurso();
            if (usuario == null)
            {
                inscripcion = false;
            }
            else
            {
                inscripcion = gestorCursos.IsInscrito(usuario, curso);
            }
            if (!inscripcion)
            {
                botonInbox.Visible = false;
                CajaComentarios.Visible = false;
                etiquetaComentarios.Text = "Debes inscribirte al curso para poder comentar y ver los comentarios";
            }


            if (inscripcion || usuario == null || usuario.NombreDeUsuario.Equals(creador.NombreDeUsuario))
            {

                botonInscribirse.Visible = false;

            }


            if (usuario == null || usuario.NombreDeUsuario.Equals(creador.NombreDeUsuario))
            {

                botonInbox.Visible = false;


            }

            if (curso != null)
            {
                etiquetaTitulo.Text = curso.Nombre;
                etiquetaNombreUsuario.Text = curso.Creador;
                etiquetaNombre.Text = creador.PrimerNombre + " " + creador.SegundoNombre + " " + creador.PrimerApellido + " " + creador.SegundoApellido; ;
                etiquetaCorreo.Text = creador.CorreoInstitucional;
                etiquetaArea.Text = curso.Area;
                campoDescripcion.Text = curso.Descripcion;
                imagenArea.Width = 32;
                imagenArea.Height = 32;
                imagenArea.ImageUrl = "~/Recursos/Imagenes/IconosAreas/" + curso.Area + ".png";
            }


            if (tablaTemas.Rows.Count == 0)
            {

                Literal sinTemas = new Literal();
                sinTemas.Text = "Este curso no dispone de temas por el momento";
                panelTemas.Controls.Clear();
                panelTemas.Controls.Add(sinTemas);
                panelTemas.Style.Add(HtmlTextWriterStyle.Padding, "50px");
            }


            if (usuario == null || usuario.NombreDeUsuario.Equals(creador.NombreDeUsuario))
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
        else
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }

        if (Session["inscribiendose"] != null && (bool)Session["inscribiendose"])
        {

            MostrarModal();

        }

    }

    protected void tablaTemas_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;

        TableCell celdaTema = fila.Cells[0];

        if (fila.RowIndex > -1)
        {
            if (usuario != null)
            {

                if (inscripcion || usuario.NombreDeUsuario.Equals(creador.NombreDeUsuario))
                {

                    LinkButton hiperEnlaceTema = new LinkButton();
                    hiperEnlaceTema.Text = celdaTema.Text;
                    hiperEnlaceTema.Click += new EventHandler(VerTema);

                    celdaTema.Controls.Add(hiperEnlaceTema);

                }
            }
        }
    }

    public void VerTema(object sender, EventArgs e)
    {
        LinkButton hiperEnlace = (LinkButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in tablaTemas.Rows)
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

    public Panel GetModal()
    {

        Panel fondoModal = new Panel();
        fondoModal.Style.Add(HtmlTextWriterStyle.ZIndex, "1030");
        fondoModal.Style.Add("background-color", "rgba(0,0,0,0.5)");

        fondoModal.Width = Unit.Percentage(100);
        fondoModal.Height = Unit.Percentage(100);
        fondoModal.Style.Add(HtmlTextWriterStyle.Position, "fixed");
        fondoModal.Style.Add(HtmlTextWriterStyle.Top, "0px");


        return fondoModal;

    }

    public void MostrarModal()
    {
        Panel modal = GetModal();

        ASP.controles_interfazinscribirsecurso_interfazinscribirsecurso_ascx interfazInscripcion = new ASP.controles_interfazinscribirsecurso_interfazinscribirsecurso_ascx();

        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO];

        interfazInscripcion.NombreDeUsuario = usuario.NombreDeUsuario;
        interfazInscripcion.IdCurso = curso.Id;
        interfazInscripcion.Codigo = curso.CodigoInscripcion;

        modal.Controls.Add(interfazInscripcion);
        panelModal.Controls.Add(modal);

    }

    protected void botonInscribirse_Click(object sender, EventArgs e)
    {

        MostrarModal();
        Session["inscribiendose"] = true;

    }

    protected void botonInbox_Click(object sender, EventArgs e)
    {

        Session[Constantes.CURSO_SELECCIONADO_PARA_CHAT] = Session[Constantes.CURSO_SELECCIONADO];
        Response.Redirect("~/Vistas/Chat/Chat.aspx");

    }
}