using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_Chat_Mensaje : System.Web.UI.UserControl
{
    private int idMensaje;

    public int IdMensaje { get => idMensaje; set => idMensaje = value; }

    protected void Page_Load(object sender, EventArgs e)
    {

        GestionMensajes gestorMensajes = new GestionMensajes();

        EMensaje mensaje = gestorMensajes.GetMensaje(idMensaje);

        ReportarCuenta.IdMensaje = mensaje.Id;

        string cuerpoMensaje = mensaje.Contenido;

        if (!cuerpoMensaje.Contains("<img"))
        {

            TextBox cajaTexto = new TextBox();

            cajaTexto.Width = Unit.Percentage(100);

            cajaTexto.Height = (int)(Math.Ceiling((double)(cuerpoMensaje.Length / 56.0))*25);
            
            cajaTexto.TextMode = TextBoxMode.MultiLine;

            cajaTexto.Text = cuerpoMensaje;

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
            imagen.Text = cuerpoMensaje;

            panelMensaje.Controls.Add(imagen);

        }


        Label etiquetaFecha = new Label();

        etiquetaFecha.Text = mensaje.Fecha.ToString();
        panelMensaje.Controls.Add(etiquetaFecha);

    }
}