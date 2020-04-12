using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Inicio : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

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

        if (e.ContentType.Contains("jpg") || e.ContentType.Contains("gif")
            || e.ContentType.Contains("png") || e.ContentType.Contains("jpeg"))
        {
            Session["fileContentType_" + e.FileId] = e.ContentType;
            Session["fileContents_" + e.FileId] = e.GetContents();
        }

        e.PostedUrl = string.Format("?preview=1&fileId={0}", e.FileId);

    }

    protected void enviar_Click(object sender, EventArgs e)
    {

        string contenido = System.Web.HttpUtility.HtmlDecode(buzon.Text);
        string contenidoAuxiliar = contenido;

        List<byte[]> archivos = new List<byte[]>();

        do
        {

            int indiceInicial = contenidoAuxiliar.IndexOf("fileId=") + 7;
            int indiceFinal = contenidoAuxiliar.IndexOf('>') - 2;
            int longitud = indiceFinal - indiceInicial + 1;
            string idArchivo = contenidoAuxiliar.Substring(indiceInicial, longitud);
            byte[] archivo = (byte[])Session["fileContents_" + idArchivo];
            archivos.Add(archivo);
            contenidoAuxiliar = contenidoAuxiliar.Substring(indiceFinal + 1);

        } while (contenidoAuxiliar.Contains("fileId"));

        List<string> contenidoAReemplazar = new List<string>();
        contenidoAuxiliar = contenido;

        while (contenidoAuxiliar.Contains("src="))
        {

            int indiceInicial = contenidoAuxiliar.IndexOf("src=") + 5;
            int indiceFinal = contenidoAuxiliar.IndexOf('"', indiceInicial)-1;
            int longitud = indiceFinal - indiceInicial + 1;

            contenidoAReemplazar.Add(contenidoAuxiliar.Substring(indiceInicial, longitud));

            contenidoAuxiliar = contenidoAuxiliar.Substring(indiceFinal);

        }

        foreach(string subcontenido in contenidoAReemplazar)
        {

            contenido = contenido.Replace(subcontenido, "&");

        }

        string nombreUsuario = (string)Session["Usuario"];

        Sugerencia gestorSugerencias = new Sugerencia();
        ESugerencia sugerencia = new ESugerencia();

        if (nombreUsuario == null)
        {

            

        }
        else
        {

            sugerencia.Emisor = nombreUsuario;

        }
        
        sugerencia.Estado = false;
        sugerencia.Contenido = contenido;
        sugerencia.Imagenes = new List<string>();

        int contadorImagen = 0;

        foreach(byte[] archivo in archivos)
        {
            
            FileStream archivoImagen = File.Create(Server.MapPath("/Recursos/Imagenes/SugerenciasEnviadas/") + "Sugerencia" + gestorSugerencias.GetCantidadSugerencias() + "Imagen" + contadorImagen + ".png");

            archivoImagen.Write(archivo, 0, archivo.Length);
            contadorImagen++;

            sugerencia.Imagenes.Add(archivoImagen.Name);

        }

        gestorSugerencias.Enviar(sugerencia);

    }
}