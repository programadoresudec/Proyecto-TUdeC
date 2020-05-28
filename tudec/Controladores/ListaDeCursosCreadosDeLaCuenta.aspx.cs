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

    protected void tablaCursos_RowCreated(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;

        if (fila.Cells.Count > 1)
        {

            TableCell celdaNombreCurso = fila.Cells[0];
            TableCell celdaArea = fila.Cells[1];
            TableCell celdaCalificacion = fila.Cells[5];
            TableCell celdaEditar = fila.Cells[6];
            TableCell celdaEditarTema = fila.Cells[7];
            TableCell celdaExpulsar = fila.Cells[8];
            TableCell celdaCalificar = fila.Cells[9];
            TableCell celdaChat = fila.Cells[10];

            string nombreArea = celdaArea.Text;

            Image iconoArea = new Image();


            ImageButton botonEditarCurso = new ImageButton();
            ImageButton botonEditarTema = new ImageButton();
            ImageButton botonExpulsar = new ImageButton();
            ImageButton botonCalificar = new ImageButton();
            ImageButton botonChat = new ImageButton();

            botonEditarCurso.ImageUrl = "~/Recursos/GestionCursos/Editar Curso.png";
            botonExpulsar.ImageUrl = "~/Recursos/GestionCursos/Expulsar Usuarios.png";
            botonEditarTema.ImageUrl = "~/Recursos/GestionCursos/Crear y Editar Temas.png";
            botonCalificar.ImageUrl = "~/Recursos/GestionCursos/Calificar Exámenes.png";
            botonChat.ImageUrl = "~/Recursos/GestionCursos/Chat.png";

            iconoArea.Width = 32;
            iconoArea.Height = 32;
            botonEditarCurso.Width = 32;
            botonEditarCurso.Height = 32;
            botonExpulsar.Width = 32;
            botonExpulsar.Height = 32;
            botonEditarTema.Width = 32;
            botonEditarTema.Height = 32;
            botonCalificar.Width = 32;
            botonCalificar.Height = 32;
            botonChat.Width = 32;
            botonChat.Height = 32;

            botonEditarCurso.Click += new ImageClickEventHandler(EditarCurso);
            botonEditarTema.Click += new ImageClickEventHandler(CrearYEditarTemas);
            botonExpulsar.Click += new ImageClickEventHandler(ExpulsarAlumnos);
            botonCalificar.Click += new ImageClickEventHandler(CalificarExamenes);
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

                celdaEditar.Controls.Add(botonEditarCurso);
                celdaExpulsar.Controls.Add(botonExpulsar);
                celdaEditarTema.Controls.Add(botonEditarTema);
                celdaCalificar.Controls.Add(botonCalificar);
                celdaChat.Controls.Add(botonChat);


            }

        }

    }

    public void ExpulsarAlumnos(object sender, EventArgs e)
    {
        ImageButton boton = (ImageButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in tablaCursos.Rows)
        {

            if (fila.Cells[8].Controls.Contains(boton))
            {

                filaAEncontrar = fila;

            }

        }

        int idCurso = Int32.Parse(tablaCursos.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionCurso gestorCursos = new GestionCurso();

        ECurso curso = gestorCursos.GetCurso(idCurso);

        Session[Constantes.CURSO_SELECCIONADO_PARA_EXPULSAR_ALUMNOS] = curso;

        Response.Redirect("~/Vistas/Cursos/ExpulsarAlumnos.aspx");


    }

    public void EditarCurso(object sender, EventArgs e)
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

        Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR] = curso;

        Response.Redirect("~/Vistas/Cursos/CreacionYEdicionCurso.aspx");


    }

    public void CrearYEditarTemas(object sender, EventArgs e)
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

        Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR_TEMAS] = curso;

        Response.Redirect("~/Vistas/Cursos/ListaDeTemasDelCurso.aspx");


    }

    public void CalificarExamenes(object sender, EventArgs e)
    {

        ImageButton boton = (ImageButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in tablaCursos.Rows)
        {

            if (fila.Cells[9].Controls.Contains(boton))
            {

                filaAEncontrar = fila;

            }

        }

        int idCurso = Int32.Parse(tablaCursos.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionCurso gestorCursos = new GestionCurso();

        ECurso curso = gestorCursos.GetCurso(idCurso);

        Session[Constantes.CURSO_SELECCIONADO_PARA_CALIFICAR_EXAMEN] = curso;

        Response.Redirect("~/Vistas/Examen/CalificarExamenTemario.aspx");

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


    public void VerChat(object sender, EventArgs e)
    {

        ImageButton boton = (ImageButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in tablaCursos.Rows)
        {

            if (fila.Cells[10].Controls.Contains(boton))
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