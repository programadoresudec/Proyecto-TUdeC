using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_CreacionYEdicionTema : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void botonCrearExamen_Click(object sender, EventArgs e)
    {
        if (botonCrearExamen.Text.Equals("Crear examen"))
        {

            botonCrearExamen.Text = "Eliminar examen";

            ASP.controles_examenes_creacionexamen_ascx herramientaCrecionExamen = new ASP.controles_examenes_creacionexamen_ascx();

            panelExamen.Controls.Add(herramientaCrecionExamen);

        }
        else
        {
    
            botonCrearExamen.Text = "Crear examen";

            panelExamen.Controls.Clear();

        }   

    }

    [WebMethod]
    public static void CrearTema(string titulo, string contenido, bool existeExamen)
    {

        ETema tema = new ETema();

        tema.Titulo = titulo;
        tema.Informacion = contenido;

        ECurso curso = (ECurso)HttpContext.Current.Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR_TEMAS];

        tema.IdCurso = curso.Id;
        if (!existeExamen)
        {

            Base.Insertar(tema);
            

        }
        
    }

}