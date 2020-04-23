using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Hosting;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Inicio : System.Web.UI.Page
{

    private static string contenidoHtmlEditor;

    protected void Page_Load(object sender, EventArgs e)
    {

        EUsuario usuario = (EUsuario)(Session[Constantes.USUARIOS_LOGEADOS]);

        if (usuario != null)
        {

            if (usuario.Rol.Equals(Constantes.ROL_ADMIN))
            {

                Button botonVerSugerencias = new Button();
                botonVerSugerencias.Text = "Ver Sugerencias";
                botonVerSugerencias.CssClass = "form-control";
                botonVerSugerencias.Click += new EventHandler(VerSugerencias);

                panelBuzon.Controls.Remove(panelCamposBuzon);
                panelBuzon.Controls.Add(botonVerSugerencias);

            }

        }

        if (Request.QueryString["preview"] == "1" && !string.IsNullOrEmpty(Request.QueryString["fileId"]))
        {
            var fileId = Request.QueryString["fileId"];
            var fileContents = (byte[])Session["fileContents_" + fileId];
            var fileContentType = (string)Session["fileContentType_" + fileId];

            if (fileContents != null)
            {
                Response.Clear();
                Response.ContentType = fileContentType;
                Response.BinaryWrite(fileContents);
                Response.End();
            }
        }


    }

    protected void buzon_HtmlEditorExtender_ImageUploadComplete(object sender, AjaxControlToolkit.AjaxFileUploadEventArgs e)
    {
        MemoryStream datosImagen = new MemoryStream(e.GetContents());
        System.Drawing.Image imagen = System.Drawing.Image.FromStream(datosImagen);

        if (imagen.Width > imagen.Height)
        {

            if(imagen.Width > 250)
            {

                int alturaImagen = 250 * imagen.Height / imagen.Width;

                imagen = new Bitmap(imagen, 250, alturaImagen);

            }

        }
        else
        {

            if (imagen.Height > 250)
            {

                int anchuraImagen = 250 * imagen.Width / imagen.Height;

                imagen = new Bitmap(imagen, anchuraImagen, 250);

            }
        }
        ImageConverter conversor = new ImageConverter();
        byte[] datosImagenRedimensionada = (byte[])conversor.ConvertTo(imagen, typeof(byte[]));

        if (e.ContentType.Contains("jpg") || e.ContentType.Contains("gif")
            || e.ContentType.Contains("png") || e.ContentType.Contains("jpeg"))
        {
            Session["fileContentType_" + e.FileId] = e.ContentType;
            Session["fileContents_" + e.FileId] = datosImagenRedimensionada;
        }

        e.PostedUrl = string.Format("?preview=1&fileId={0}", e.FileId);

    }

    protected void VerSugerencias(object sender, EventArgs e)
    {

        Response.Redirect("~/Vistas/Sugerencias/VisualizacionDeSugerencias.aspx");

    }

    [WebMethod]
    public static void Test()
    {
        Console.WriteLine("");

    }

    [WebMethod]
    public static void EnviarHtml(string titulo, string contenido)
    {

        string contenidoAuxiliar = contenido;

        List<byte[]> archivos = new List<byte[]>();
        List<string> extensiones = new List<string>();


        if (contenidoAuxiliar.Contains("img"))
        {

            do
            {

                int indiceInicial = contenidoAuxiliar.IndexOf("fileId=") + 7;
                int indiceFinal = contenidoAuxiliar.IndexOf('>',indiceInicial) - 2;
                int longitud = indiceFinal - indiceInicial + 1;
                string idArchivo = contenidoAuxiliar.Substring(indiceInicial, longitud);
                byte[] archivo = (byte[])HttpContext.Current.Session["fileContents_" + idArchivo];
                string extension = (string)HttpContext.Current.Session["fileContentType_" + idArchivo];
                archivos.Add(archivo);
                extensiones.Add(extension);
                contenidoAuxiliar = contenidoAuxiliar.Substring(indiceFinal + 3);

            } while (contenidoAuxiliar.Contains("fileId"));

        }


        List<string> contenidoAReemplazar = new List<string>();
        contenidoAuxiliar = contenido;

        while (contenidoAuxiliar.Contains("src="))
        {

            int indiceInicial = contenidoAuxiliar.IndexOf("src=") + 5;
            int indiceFinal = contenidoAuxiliar.IndexOf('"', indiceInicial) - 1;
            int longitud = indiceFinal - indiceInicial + 1;

            contenidoAReemplazar.Add(contenidoAuxiliar.Substring(indiceInicial, longitud));

            contenidoAuxiliar = contenidoAuxiliar.Substring(indiceFinal);

        }

        foreach (string subcontenido in contenidoAReemplazar)
        {

            contenido = contenido.Replace(subcontenido, "&");

        }

        EUsuario usuario = (EUsuario)HttpContext.Current.Session[Constantes.USUARIOS_LOGEADOS];

        string nombreUsuario;


        Sugerencia gestorSugerencias = new Sugerencia();
        ESugerencia sugerencia = new ESugerencia();

        sugerencia.Titulo = titulo;

        if (usuario != null)
        {
            nombreUsuario = usuario.NombreDeUsuario;
            sugerencia.Emisor = nombreUsuario;

        }

        sugerencia.Estado = false;
        sugerencia.Contenido = contenido;
        sugerencia.Fecha = DateTime.Now;
        sugerencia.Imagenes = new List<string>();

        int contadorImagen = 0;

        foreach (byte[] archivo in archivos)
        {


            FileStream archivoImagen = File.Create(System.Web.HttpContext.Current.Server.MapPath("../Recursos/Imagenes/SugerenciasEnviadas/") + "Sugerencia" + gestorSugerencias.GetCantidadSugerencias() + "Imagen" + contadorImagen + extensiones[archivos.IndexOf(archivo)]);

            archivoImagen.Write(archivo, 0, archivo.Length);

            sugerencia.Imagenes.Add("..\\\\..\\\\Recursos\\\\Imagenes\\\\SugerenciasEnviadas\\\\Sugerencia" + gestorSugerencias.GetCantidadSugerencias() + "Imagen" + contadorImagen + extensiones[archivos.IndexOf(archivo)]);
            contadorImagen++;

            archivoImagen.Close();

        }

        sugerencia.ImagenesJson = JsonConvert.SerializeObject(sugerencia.Imagenes);

        gestorSugerencias.Enviar(sugerencia);


    }

}