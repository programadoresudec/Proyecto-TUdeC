using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_ListaDeResultadosDelBuscadorTutores : System.Web.UI.Page
{
    private bool indicador = false;

    protected void Page_Load(object sender, EventArgs e)
    {

        tablaTutores.DataBind();

    }

    protected void botonCurso_Click(object sender, EventArgs e)
    {

        if (!indicador)
        {

            Response.Redirect("~/Vistas/Buscador/ListaDeResultadosDelBuscadorCursos.aspx");

        }
        else
        {

            indicador = false;

        }

    }

    protected void botonBuscar_Click(object sender, EventArgs e)
    {

    }

    protected void tablaTutores_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridViewRow fila = e.Row;
        if (fila.Cells.Count > 1)
        {

            TableCell celdaPerfilUsuario = fila.Cells[0];
            TableCell celdaHiperEnlaceUsuario = fila.Cells[1];
            TableCell celdaCalificacion = fila.Cells[4];


            Image icono = new Image();
            icono.Width = 64;
            icono.Height = 64;

            if (fila.RowIndex > -1)
            {
                LinkButton hiperEnlaceUsuario = new LinkButton();
                hiperEnlaceUsuario.Text = celdaHiperEnlaceUsuario.Text;
                hiperEnlaceUsuario.Click += new EventHandler(VerInformacionUsuario);

                celdaHiperEnlaceUsuario.Controls.Add(hiperEnlaceUsuario);

                int calificacion;

                if (celdaCalificacion.Text.Equals("&nbsp;"))
                {
                    calificacion = 0;
                }
                else
                {
                    calificacion = Int32.Parse(celdaCalificacion.Text);
                }
                ASP.controles_estrellas_estrellas_ascx estrellasMostradas = new ASP.controles_estrellas_estrellas_ascx();
                estrellasMostradas.Calificacion = calificacion;
                celdaCalificacion.Controls.Add(estrellasMostradas);
                celdaCalificacion.Enabled = false;
                string nombreUsuario = fila.Cells[1].Text;
                icono.ImageUrl = new DaoUsuario().buscarImagen(nombreUsuario);
                celdaPerfilUsuario.Controls.Add(icono);
            }
        }
    }

    public void VerInformacionUsuario(object sender, EventArgs e)
    {

        LinkButton hiperEnlace = (LinkButton)sender;

        DaoUsuario gestorUsuarios = new DaoUsuario();

        Session[Constantes.USUARIO_SELECCIONADO] = gestorUsuarios.GetUsuario(hiperEnlace.Text);

        Response.Redirect("~/Vistas/Usuarios/InformacionDelUsuarioSeleccionado.aspx");

    }

    [WebMethod]
    public static List<string> GetNombresTutores(string prefixText)
    {

        Buscador gestorBuscador = new Buscador();

        List<string> nombres = gestorBuscador.GetTutoresSrc(prefixText);

        return nombres;

    }


    protected void cajaBuscador_TextChanged(object sender, EventArgs e)
    {
        indicador = true;
    }
}