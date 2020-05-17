using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_InformacionDelUsuarioSeleccionado : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        EUsuario usuarioInformacion = (EUsuario)Session[Constantes.USUARIO_SELECCIONADO];
        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        DaoUsuario gestorUsuario = new DaoUsuario();
        EPuntuacion puntuacion = new EPuntuacion();
        if (usuarioInformacion != null)
        {
            if (usuario == null || usuario.NombreDeUsuario.Equals(usuarioInformacion.NombreDeUsuario))
            {
                EstrellasPuntuacion.Visible = false;
            }
            else
            {
                puntuacion = gestorUsuario.GetPuntuacion(usuario, usuarioInformacion);
                if (puntuacion != null)
                {
                    EstrellasPuntuacion.Calificacion = puntuacion.Puntuacion;
                }
                else
                {
                    EstrellasPuntuacion.Calificacion = 0;
                }
            }
            etiquetaNombreUsuario.Text = usuarioInformacion.NombreDeUsuario;
            etiquetaNombre.Text = usuarioInformacion.PrimerNombre + " " + usuarioInformacion.SegundoNombre;
            etiquetaApellido.Text = usuarioInformacion.PrimerApellido + " " + usuarioInformacion.SegundoApellido;
            etiquetaDescripcion.Text = usuarioInformacion.Descripcion;
            imagenUsuario.ImageUrl = gestorUsuario.buscarImagen(usuarioInformacion.NombreDeUsuario);
            imagenUsuario.DataBind();

            ASP.controles_estrellas_estrellas_ascx estrellas = new ASP.controles_estrellas_estrellas_ascx();
            panelEstrellas.Style.Add("pointer-events", "none");


            if (usuarioInformacion.Puntuacion != null)
            {
                estrellas.Calificacion = (int)usuarioInformacion.Puntuacion;
            }
            else
            {
                estrellas.Calificacion = 0;
            }
            panelEstrellas.Controls.Remove(etiquetaPuntuacion);
            panelEstrellas.Controls.Add(estrellas);
        }
        else
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }

        GridViewUsuSelec.DataBind();

    }


  

    protected void GridViewUsuSelec_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;


        if (fila.Cells.Count > 1)
        {

            TableCell celdaArea = fila.Cells[0];
            TableCell celdaCurso = fila.Cells[1];
            TableCell celdaPuntuacion = fila.Cells[4];

            if (fila.RowIndex > -1)
            {

                string nombreArea = celdaArea.Text;

                Buscador buscador = new Buscador();

                EArea area = buscador.GetAreasSrc().Where(x => x.Area == nombreArea).FirstOrDefault();

                Image iconoArea = new Image();
                iconoArea.Width = 32;
                iconoArea.Height = 32;

                ASP.controles_estrellas_estrellas_ascx estrellas = new ASP.controles_estrellas_estrellas_ascx();

                estrellas.Calificacion = Int32.Parse(celdaPuntuacion.Text);

                iconoArea.ImageUrl = area.Icono;

                celdaPuntuacion.Enabled = false;

                LinkButton hiperEnlaceCurso = new LinkButton();
                hiperEnlaceCurso.Text = celdaCurso.Text;
                hiperEnlaceCurso.Click += new EventHandler(VerCurso);

                celdaCurso.Controls.Add(hiperEnlaceCurso);
                celdaArea.Controls.Add(iconoArea);
                celdaPuntuacion.Controls.Add(estrellas);

            }

        }

    }

    public void VerCurso(object sender, EventArgs e)
    {

        LinkButton boton = (LinkButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach (GridViewRow fila in GridViewUsuSelec.Rows)
        {

            if (fila.Cells[1].Controls.Contains(boton))
            {

                filaAEncontrar = fila;

            }

        }

        int idCurso = Int32.Parse(GridViewUsuSelec.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionCurso gestorCursos = new GestionCurso();

        ECurso curso = gestorCursos.GetCurso(idCurso);

        Session[Constantes.CURSO_SELECCIONADO] = curso;

        Response.Redirect("~/Vistas/Cursos/InformacionDelCurso.aspx");

    }

}