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
        
        Response.Redirect("~/Vistas/Buscador/ListaDeResultadosDelBuscadorTutores.aspx");

    }



    protected void botonBuscar_Click(object sender, EventArgs e)
    {

       

    }

    protected void tablaCursos_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      
        GridViewRow fila = e.Row;

        if (fila.Cells.Count > 1)
        {

            TableCell celdaArea = fila.Cells[0];
            TableCell celdaCalificacion = fila.Cells[4];
            TableCell celdaNombre = fila.Cells[1];

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

                LinkButton hiperenlaceInformacionCurso = new LinkButton();
                hiperenlaceInformacionCurso.Text = celdaNombre.Text;
                hiperenlaceInformacionCurso.Click += new EventHandler(VerInformacionCurso);

                celdaNombre.Controls.Add(hiperenlaceInformacionCurso);

                Buscador buscador = new Buscador();

                EArea area = buscador.GetAreasSrc().Where(x => x.Area == nombreArea).FirstOrDefault();

                icono.ImageUrl = area.Icono;

                celdaArea.Controls.Add(icono);

            }

        }

    }


    public void VerInformacionCurso(object sender, EventArgs e)
    {


        LinkButton hiperEnlace = (LinkButton)sender;
        GridViewRow filaAEncontrar = null;

        foreach(GridViewRow fila in tablaCursos.Rows)
        {

            if (fila.Cells[1].Controls.Contains(hiperEnlace))
            {

                filaAEncontrar = fila;
                break;

            }


        }


        DataKeyArray arreglo =  tablaCursos.DataKeys;
        int idCurso = Int32.Parse(tablaCursos.DataKeys[filaAEncontrar.RowIndex].Value.ToString());

        GestionCurso gestorCursos = new GestionCurso();

        ECurso curso = gestorCursos.GetCurso(idCurso);

        Session[Constantes.CURSO_SELECCIONADO] = curso;

        Response.Redirect("~/Vistas/Cursos/InformacionDelCurso.aspx");
        

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