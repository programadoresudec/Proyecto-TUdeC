using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_Chat_Mensaje : System.Web.UI.UserControl
{

    private string mensaje;

    public string Mensaje { get => mensaje; set => mensaje = value; }

    protected void Page_Load(object sender, EventArgs e)
    {

        etiquetaMensaje.Text = mensaje;

    }
}