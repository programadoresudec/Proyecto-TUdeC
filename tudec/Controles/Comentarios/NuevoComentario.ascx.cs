using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_Comentarios_NuevoComentario : System.Web.UI.UserControl
{
    private int idComentario;

    public int IdComentario { get => idComentario; set => idComentario = value; }

    protected void Page_Load(object sender, EventArgs e)
    {

        Session["idComentario"] = IdComentario;
        
    }

}