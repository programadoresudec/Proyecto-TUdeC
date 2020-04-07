using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_ListaDeResultadosDelBuscadorTutores : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        tablaTutores.DataBind();

    }

    protected void botonCurso_Click(object sender, EventArgs e)
    {

        Response.Redirect("~/Vistas/ListaDeResultadosDelBuscadorCursos.aspx");

    }

    protected void botonBuscar_Click(object sender, EventArgs e)
    {

    }

    protected void tablaTutores_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;

        TableCell celdaPerfilUsuario = fila.Cells[0];
        TableCell celdaCalificacion = fila.Cells[4];

        string nombreArea = celdaPerfilUsuario.Text;

        Image icono = new Image();
        icono.Width = 32;
        icono.Height = 32;

        if (fila.RowIndex > -1)
        {
            int calificacion = Int32.Parse(celdaCalificacion.Text);
            ASP.controles_estrellas_estrellas_ascx estrellasMostradas = new ASP.controles_estrellas_estrellas_ascx();
            estrellasMostradas.Calificacion = calificacion;
            celdaCalificacion.Controls.Add(estrellasMostradas);
            celdaCalificacion.Enabled = false;

            Buscador buscador = new Buscador();

            string nombreUsuario = fila.Cells[1].Text;

            EUsuario usuario = buscador.GetUsuario(nombreUsuario);

            icono.ImageUrl = usuario.ImagenPerfil;

            if (icono.ImageUrl == "")
            {

                icono.ImageUrl = "~/Recursos/Imagenes/PerfilUsuarios/Usuario.png";

            }

            celdaPerfilUsuario.Controls.Add(icono);

        }

    }

    [WebMethod]
    public static List<string> GetNombresTutores(string prefixText)
    {

        Buscador gestorBuscador = new Buscador();

        List<string> nombres = gestorBuscador.GetTutoresSrc(prefixText);

        return nombres;

    }

}