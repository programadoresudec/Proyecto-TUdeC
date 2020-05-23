using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_Chat_Mensaje : System.Web.UI.UserControl
{

    private string mensaje;
    private DateTime fecha;
    public string Mensaje { get => mensaje; set => mensaje = value; }
    public DateTime Fecha { get => fecha; set => fecha = value; }

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!mensaje.Contains("<img"))
        {

            TextBox cajaTexto = new TextBox();

            cajaTexto.Width = Unit.Percentage(100);

            cajaTexto.Height = (int)(Math.Ceiling((double)(mensaje.Length / 56.0))*25);
            
            cajaTexto.TextMode = TextBoxMode.MultiLine;

            cajaTexto.Text = mensaje;

            cajaTexto.Enabled = false;

            cajaTexto.BackColor = System.Drawing.Color.Transparent;

            cajaTexto.ForeColor = System.Drawing.Color.Black;

            cajaTexto.Style.Add(HtmlTextWriterStyle.Overflow, "hidden");

            cajaTexto.Style.Add("border", "0px");

            

            panelMensaje.Controls.Add(cajaTexto);
            

        }
        else
        {

            Literal imagen = new Literal();
            imagen.Text = mensaje;

            panelMensaje.Controls.Add(imagen);

        }


        Label etiquetaFecha = new Label();

        etiquetaFecha.Text = Fecha.ToString();
        panelMensaje.Controls.Add(etiquetaFecha);

    }
}