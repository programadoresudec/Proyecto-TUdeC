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
        cajaFechaCreacion_CalendarExtender.EndDate = DateTime.Now;
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario == null)
        {
            Response.Redirect("~/Vistas/Home.aspx");

        }
        else if (usuario != null && usuario.Rol.Equals(Constantes.ROL_ADMIN))
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }

        tablaCursos.DataBind();

    }

    public void EliminarInscripcion(object sender, EventArgs e)
    {

        ImageButton boton = (ImageButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in tablaCursos.Rows)
        {

            if (fila.Cells[7].Controls.Contains(boton))
            {

                filaAEncontrar = fila;

            }

        }

        int idCurso = Int32.Parse(tablaCursos.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionCurso gestorCursos = new GestionCurso();

        ECurso curso = gestorCursos.GetCurso(idCurso);

        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

        EInscripcionesCursos inscripcion = gestorCursos.GetInscripcion(usuario, curso);

        Base.Eliminar(inscripcion);

        Response.Redirect("~/Vistas/Cursos/ListaDeCursosInscritosDeLaCuenta.aspx");

    }

    public void VerCalificaciones(object sender, EventArgs e)
    {

        ImageButton boton = (ImageButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in tablaCursos.Rows)
        {

            if (fila.Cells[5].Controls.Contains(boton))
            {

                filaAEncontrar = fila;

            }

        }

        int idCurso = Int32.Parse(tablaCursos.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionCurso gestorCursos = new GestionCurso();

        ECurso curso = gestorCursos.GetCurso(idCurso);

        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

        Session[Constantes.CURSO_SELECCIONADO_PARA_VER_NOTAS] = curso;

        Response.Redirect("~/Vistas/Cursos/VerMisNotas.aspx");

    }

    protected void tablaCursos_RowCreated(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;

        if (fila.Cells.Count > 1)
        {

            TableCell celdaNombreCurso = fila.Cells[0];
            TableCell celdaArea = fila.Cells[1];
            TableCell celdaCalificacion = fila.Cells[4];
            TableCell celdaBoleta = fila.Cells[5];
            TableCell celdaChat = fila.Cells[6];
            TableCell celdaCancelar = fila.Cells[7];

            string nombreArea = celdaArea.Text;

            Image iconoArea = new Image();
            ImageButton botonBoleta = new ImageButton();
            ImageButton botonCancelar = new ImageButton();
            ImageButton botonChat = new ImageButton();

            botonBoleta.ImageUrl = "~/Recursos/GestionCursos/Boleta Calificaciones.png";
            botonCancelar.ImageUrl = "~/Recursos/GestionCursos/Cancelar Inscripción.png";
            botonChat.ImageUrl = "~/Recursos/GestionCursos/Chat.png";

            iconoArea.Width = 32;
            iconoArea.Height = 32;
            botonBoleta.Width = 32;
            botonBoleta.Height = 32;
            botonCancelar.Width = 32;
            botonCancelar.Height = 32;
            botonChat.Width = 32;
            botonChat.Height = 32;

            botonBoleta.Click += new ImageClickEventHandler(VerCalificaciones);
            botonCancelar.Click += new ImageClickEventHandler(EliminarInscripcion);
            botonChat.Click += new ImageClickEventHandler(VerChat);

            if (fila.RowIndex > -1)
            {

                LinkButton hiperEnlaceInfoCurso = new LinkButton();
                hiperEnlaceInfoCurso.Text = celdaNombreCurso.Text;
                hiperEnlaceInfoCurso.Click += new EventHandler(VerInformacionCurso);
                celdaNombreCurso.Controls.Add(hiperEnlaceInfoCurso);

                int calificacion = Int32.Parse(celdaCalificacion.Text);
                ASP.controles_estrellas_estrellas_ascx estrellasMostradas = new ASP.controles_estrellas_estrellas_ascx();
                estrellasMostradas.Calificacion = calificacion;
                celdaCalificacion.Controls.Add(estrellasMostradas);
                celdaCalificacion.Enabled = false;

                Buscador buscador = new Buscador();

                EArea area = buscador.GetAreasSrc().Where(x => x.Area == nombreArea).FirstOrDefault();

                iconoArea.ImageUrl = area.Icono;

                celdaArea.Controls.Add(iconoArea);
                celdaChat.Controls.Add(botonChat);
                celdaBoleta.Controls.Add(botonBoleta);
                celdaCancelar.Controls.Add(botonCancelar);

            }

        }

    }


    public void VerInformacionCurso(object sender, EventArgs e)
    {

        LinkButton hiperEnlace = (LinkButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in tablaCursos.Rows)
        {

            if (fila.Cells[0].Controls.Contains(hiperEnlace))
            {

                filaAEncontrar = fila;
                break;

            }


        }


        DataKeyArray arreglo = tablaCursos.DataKeys;
        int idCurso = Int32.Parse(tablaCursos.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionCurso gestorCursos = new GestionCurso();

        ECurso curso = gestorCursos.GetCurso(idCurso);

        Session[Constantes.CURSO_SELECCIONADO] = curso;

        Response.Redirect("~/Vistas/Cursos/InformacionDelCurso.aspx");


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

    public void VerChat(object sender, EventArgs e)
    {

        ImageButton boton = (ImageButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in tablaCursos.Rows)
        {

            if (fila.Cells[6].Controls.Contains(boton))
            {

                filaAEncontrar = fila;

            }

        }

        int idCurso = Int32.Parse(tablaCursos.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionCurso gestorCursos = new GestionCurso();

        ECurso curso = gestorCursos.GetCurso(idCurso);

        Session[Constantes.CURSO_SELECCIONADO_PARA_CHAT] = curso;

        Response.Redirect("~/Vistas/Chat/Chat.aspx");


    }

    protected void botonCreados_Click(object sender, EventArgs e)
    {

        Response.Redirect("~/Vistas/Cursos/ListaDeCursosCreadosDeLaCuenta.aspx");

    }
}