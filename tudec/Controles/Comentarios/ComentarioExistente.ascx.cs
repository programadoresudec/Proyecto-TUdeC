using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_Comentarios_ComentarioExistente : System.Web.UI.UserControl
{

    private string nombreUsuario;
    private string contenido;

    public string NombreUsuario { get => nombreUsuario; set => nombreUsuario = value; }
    public string Contenido { get => contenido; set => contenido = value; }

    protected void Page_Load(object sender, EventArgs e)
    {

        etiquetaUsuario.Text = nombreUsuario;
        cajaComentarios.Text = contenido;

    }
}