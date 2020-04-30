using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_InformacionDelCurso : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        DaoUsuario gestorUsuarios = new DaoUsuario();

        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO];
        EUsuario creador = gestorUsuarios.GetUsuario(curso.Creador);

        etiquetaTitulo.Text = curso.Nombre;
        etiquetaNombreUsuario.Text = curso.Creador;
        etiquetaNombre.Text = creador.PrimerNombre + " " + creador.SegundoNombre;
        etiquetaApellido.Text = creador.PrimerApellido + " " + creador.SegundoApellido;
        etiquetaCorreo.Text = creador.CorreoInstitucional;

    }
}