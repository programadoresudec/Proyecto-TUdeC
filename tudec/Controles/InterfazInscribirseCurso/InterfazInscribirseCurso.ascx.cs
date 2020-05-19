using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_InterfazInscribirseCurso_InterfazInscribirseCurso : System.Web.UI.UserControl
{

    private string nombreDeUsuario;
    private int idCurso;
    private string codigo;

    public string NombreDeUsuario { get => nombreDeUsuario; set => nombreDeUsuario = value; }
    public int IdCurso { get => idCurso; set => idCurso = value; }
    public string Codigo { get => codigo; set => codigo = value; }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void botonInscribirse_Click(object sender, EventArgs e)
    {

        if (cajaCodigo.Text.Equals(codigo))
        {

            EInscripcionesCursos inscripcion = new EInscripcionesCursos();

            inscripcion.FechaInscripcion = DateTime.Now;
            inscripcion.NombreUsuario = nombreDeUsuario;
            inscripcion.IdCurso = idCurso;
            LB_Validacion.CssClass = "alertHome alert-success";
            LB_Validacion.Text = "¡Se ha inscrito Satisfactoriamente!";
            LB_Validacion.Visible = true;
            Base.Insertar(inscripcion);
            Session["inscribiendose"] = false;
 
        }
        else
        {
            LB_Validacion.CssClass = "alertHome alert-danger";
            LB_Validacion.Text = "El codigo es incorrecto.";
            LB_Validacion.Visible = true;
            Session["inscribiendose"] = false;
        }

    }

    protected void botonCancelar_Click(object sender, ImageClickEventArgs e)
    {

        Session["inscribiendose"] = false;
        Response.Redirect("~/Vistas/Cursos/InformacionDelCurso.aspx");

    }
}