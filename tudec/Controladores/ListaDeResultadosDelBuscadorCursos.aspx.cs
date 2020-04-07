using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ListaDeResultadosDelBuscador : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            cajaBuscador.Text = (string)Session["Buscador"];

        }

        tablaCursos.DataBind();

    }

    protected void botonTutor_Click(object sender, EventArgs e)
    {
        
        Response.Redirect("~/Vistas/ListaDeResultadosDelBuscadorTutores.aspx");

    }



    protected void botonBuscar_Click(object sender, EventArgs e)
    {

       

    }

    protected void tablaCursos_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      
        GridViewRow fila = e.Row;

        TableCell celdaArea = fila.Cells[0];
        TableCell celdaCalificacion = fila.Cells[4];

        string nombreArea = celdaArea.Text;

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

            EArea area = buscador.GetAreasSrc().Where(x => x.Area == nombreArea).FirstOrDefault();

            icono.ImageUrl = area.Icono;

            celdaArea.Controls.Add(icono);

        }

    }

    [WebMethod]
    public static List<string> GetNombresCursos(string prefixText)
    {

        Buscador gestorBuscador = new Buscador();

        List<string> nombres = gestorBuscador.GetCursosSrc(prefixText);

        return nombres;

    }

    [WebMethod]
    public static List<string> GetNombresTutores(string prefixText)
    {

        Buscador gestorBuscador = new Buscador();

        List<string> nombres = gestorBuscador.GetTutoresSrc(prefixText);

        return nombres;

    }

}