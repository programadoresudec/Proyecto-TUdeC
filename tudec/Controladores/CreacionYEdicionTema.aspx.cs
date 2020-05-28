using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Hosting;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_CreacionYEdicionTema : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        

        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR_TEMAS];


        if(curso == null)
        {

            Response.Redirect("~/Vistas/Home.aspx");

        }


        ETema tema = (ETema)Session[Constantes.TEMA_SELECCIONADO];

        if (tema != null)
        {

            etiquetaCrearTema.Text = "Editar tema";
            cajaTitulo.Text = tema.Titulo;
            GestionExamen gestorExamenes = new GestionExamen();
            EExamen examen = gestorExamenes.GetExamen(tema);

            bool existenciaExamen = false;

            if (examen != null)
            {

                existenciaExamen = true;

            }

            Session["existenciaExamen"] = existenciaExamen;

        }

    }

 
    [WebMethod]
    public static void CrearTema(string titulo, string contenido, bool existeExamen)
    {

        ETema tema = new ETema();

        tema.Titulo = titulo;

        contenido = contenido.Replace("\n\n", "");

        contenido = contenido.Replace("\n", "");

        tema.Informacion = contenido;


        ECurso curso = (ECurso)HttpContext.Current.Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR_TEMAS];

        tema.IdCurso = curso.Id;
        if (!existeExamen)
        {

            Base.Insertar(tema);
            

        }
        
    }


    [WebMethod]
    public static void EditarTema(string titulo, string contenido)
    {

        ETema tema = (ETema)HttpContext.Current.Session[Constantes.TEMA_SELECCIONADO];

        tema.Titulo = titulo;

        contenido = contenido.Replace("\n\n", "");

        contenido = contenido.Replace("\n", "");

        tema.Informacion = contenido;

        Base.Actualizar(tema);

    }

}