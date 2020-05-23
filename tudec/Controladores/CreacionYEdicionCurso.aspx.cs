using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_CreacionYEdicionCurso : System.Web.UI.Page
{

    private ECurso cursoExistente;

    protected void Page_Load(object sender, EventArgs e)
    {

        cajaFechaInicio_CalendarExtender.StartDate = DateTime.Now;

        cursoExistente = (ECurso)Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR];

        cajaFechaInicio.Attributes.Add("readonly", "readonly");

        if (Session["actualizando"] != null)
        {

            if (DateTime.Now >= cursoExistente.FechaInicio && (bool)Session["actualizando"])
            {
                cajaFechaInicio.Enabled = false;
                Session["actualizando"] = false;

                cursoExistente.Estado = "activo";

                Base.Actualizar(cursoExistente);

            }
        }

        if (cursoExistente != null && !IsPostBack)
        {

            etiquetaCrearCurso.Text = "Editar curso";
            botonCrearCurso.Text = "Editar curso";

            cajaTitulo.Text = cursoExistente.Nombre;
            desplegableArea.SelectedValue = cursoExistente.Area;

            cajaFechaInicio.Text = cursoExistente.FechaInicio.ToString("dd/MM/yyyy");

            cajaDescripcion.Text = cursoExistente.Descripcion;

            desplegableArea.Enabled = false;


            if (DateTime.Now >= cursoExistente.FechaInicio)
            {
                cajaFechaInicio.Enabled = false;
          
            }

        }

    }

    protected void botonCrearCurso_Click(object sender, EventArgs e)
    {

        if (desplegableArea.SelectedItem.Text != "Área del conocimiento")
        {

            ECurso curso = new ECurso();

            EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

            curso.Creador = usuario.NombreDeUsuario;
            curso.Area = desplegableArea.SelectedItem.Text;

            int dia = Int32.Parse(cajaFechaInicio.Text.Split('/')[0]);
            int mes = Int32.Parse(cajaFechaInicio.Text.Split('/')[1]);
            int anio = Int32.Parse(cajaFechaInicio.Text.Split('/')[2]);

            DateTime fechaInicio = new DateTime(anio, mes, dia);

            curso.FechaInicio = fechaInicio;

            DateTime fechaActual = DateTime.Now;

            if (fechaInicio > fechaActual)
            {

                curso.Estado = "en_espera";

            }
            else
            {

                curso.Estado = "activo";

            }

            curso.Nombre = cajaTitulo.Text;

            curso.FechaCreacion = fechaActual;
            curso.Puntuacion = 0;

            if (cajaDescripcion.Text != "")
            {

                curso.Descripcion = cajaDescripcion.Text;

            }

            


            if (cursoExistente == null)
            {

                bool validar;
                string codigo;
                do
                {
                    codigo = Reutilizables.generarCodigoCurso();
                    validar = new GestionCurso().existeCodigoCurso(codigo);
                } while (validar != false);

                curso.CodigoInscripcion = codigo;

                Base.Insertar(curso);

                ScriptManager.RegisterStartupScript(this, GetType(), "CallFunction", "alert('Él código de su curso es " + codigo + "');", true);


                Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR_TEMAS] = curso;

                Response.Redirect("~/Vistas/Cursos/ListaDeTemasDelCurso.aspx");

            }
            else
            {

                cursoExistente.Nombre = curso.Nombre;
                cursoExistente.Descripcion = curso.Descripcion;
                cursoExistente.FechaInicio = curso.FechaInicio;

                Base.Actualizar(cursoExistente);

                Session["actualizando"] = true;

                Response.Redirect("~/Vistas/Cursos/CreacionYEdicionCurso.aspx");

                

            }

            

        }
        else
        {
            
            Response.Write("<script>alert('Seleccione un área')</script>");


        }

    }
}