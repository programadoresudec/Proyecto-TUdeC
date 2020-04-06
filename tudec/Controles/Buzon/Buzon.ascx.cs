using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_Buzon_Buzon : System.Web.UI.UserControl
{
    private static Panel panelContenido;

    protected void Page_Load(object sender, EventArgs e)
    {   

        if (panelContenido == null)
        {

            panelContenido = new Panel();
            TextBox caja = new TextBox();
            panelContenido.ID = "panelContenido";
            panelContenido.ClientIDMode = ClientIDMode.Static;
            panelContenido.Width = panelSugerencia.Width;
            panelContenido.Height = panelSugerencia.Height;
            panelContenido.ScrollBars = ScrollBars.Vertical;

            caja.ID = "caja";
            caja.ClientIDMode = ClientIDMode.Static;
            caja.TextMode = TextBoxMode.MultiLine;
            caja.Width = (Unit)(panelContenido.Width.Value-26);
            panelContenido.Controls.Add(caja);

        }
   
        panelSugerencia.Controls.Add(panelContenido);
        
    }

    protected void BotonImagen_Click(object sender, ImageClickEventArgs e)
    {

        Image imagen = new Image();

        EUsuario usuario = (EUsuario)Session["Usuario"];

        Sugerencia gestorSugerencia = new Sugerencia();

        string nombreArchivo = usuario.NombreDeUsuario + (gestorSugerencia.GetCantidadImagenes(usuario) + 1).ToString();

        subidorImagenes.SaveAs(Server.MapPath("~/Recursos/Imagenes/Sugerencias/") + nombreArchivo);

        imagen.ImageUrl = "~/Recursos/Imagenes/Sugerencias/" + nombreArchivo;
        imagen.Width = (Unit)(panelContenido.Width.Value - 30);

        panelContenido.Controls.Add(imagen);

        TextBox caja = new TextBox();

        panelContenido.Controls.Add(caja);
        caja.TextMode = TextBoxMode.MultiLine;
        caja.Width = (Unit)(panelContenido.Width.Value - 26);


    }

    private string GenerarContenido()
    {

        string contenido = "";

        foreach(Control control in panelContenido.Controls)
        {

            if (control.Equals(typeof(TextBox)))
            {
                TextBox caja = (TextBox)control;
                contenido += "Texto=" + caja.Text + ";";

            }
            else
            {

                contenido += "Img;";

            }

        }

        return contenido;

    }

    private List<string> GetDirectorios()
    {

        List<string> directorios = new List<string>();

        foreach (Control control in panelContenido.Controls)
        {

            if (control.Equals(typeof(Image)))
            {
                Image imagen = (Image)control;
                directorios.Add(imagen.ImageUrl);

            }

        }

        return directorios;

    }

    protected void botonEnviar_Click(object sender, EventArgs e)
    {

        ESugerencia sugerencia = new ESugerencia();
        EUsuario usuario = (EUsuario)Session["usuario"];
        sugerencia.Emisor = usuario.NombreDeUsuario;
        sugerencia.Contenido = GenerarContenido();
        sugerencia.Estado = false;

        Sugerencia gestorSugerencia = new Sugerencia();
        gestorSugerencia.Enviar(sugerencia);

        List<string> directorios = GetDirectorios();

        foreach(string directorio in directorios)
        {

            EArchivo archivo = new EArchivo();
            archivo.IdSugerencia = sugerencia.Id;
            archivo.Direccion = directorio;
            gestorSugerencia.AlmacenarImagen(archivo);

        }
        

    }
}