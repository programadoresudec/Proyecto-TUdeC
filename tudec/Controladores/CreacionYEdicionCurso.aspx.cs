using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_CreacionYEdicionCurso : System.Web.UI.Page
{
    private static EUsuario usuario;
    private ECurso cursoExistente;

    protected void Page_Load(object sender, EventArgs e)
    {
        cajaFechaInicio_CalendarExtender.StartDate = DateTime.Now;
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario == null)
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
        else if (usuario != null && usuario.Rol.Equals(Constantes.ROL_ADMIN))
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
        else
        {
            cursoExistente = (ECurso)Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR];
            cajaFechaInicio.Attributes.Add("readonly", "readonly");
            if (Session["actualizando"] != null && cursoExistente != null)
            {
                if (DateTime.Now >= cursoExistente.FechaInicio && (bool)Session["actualizando"])
                {
                    cajaFechaInicio.Enabled = false;
                    Session["actualizando"] = false;
                    cursoExistente.Estado = "activo";
                    Base.Actualizar(cursoExistente);
                    LB_editado.Visible = true;
                }
            }

            if (cursoExistente != null && !IsPostBack)
            {
                etiquetaCrearCurso.CssClass = "fa fa-edit fa-3x";
                etiquetaCrearCurso.Text = "Editar curso";
                botonCrearCurso.Text = "<strong>Editar curso</strong>";

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
                Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR_TEMAS] = curso;
                Lb_validacion.Visible = false;
                LB_creado.CssClass = "alertCursoCreado alert-success";
                LB_creado.Text = " <strong>¡Satisfactorio!</strong> Su curso se ha creado. Él código de su curso es: " + "<strong>" + codigo + "</strong>";
                LB_creado.Visible = true;
            }
            else
            {
                cursoExistente.Nombre = curso.Nombre;
                cursoExistente.Descripcion = curso.Descripcion;
                cursoExistente.FechaInicio = curso.FechaInicio;
                Base.Actualizar(cursoExistente);
                Session["actualizando"] = true;
                Lb_validacion.Visible = false;
                LB_editado.CssClass = "alertCursoEditado alert-success";
                LB_editado.Visible = true;
            }
        }
        else
        {
            Lb_validacion.CssClass = "alert alert-danger";
            Lb_validacion.Visible = true;
        }
    }
}