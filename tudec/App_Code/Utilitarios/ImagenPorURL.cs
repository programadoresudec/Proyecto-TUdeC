using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ImagenPorURL
/// Clase que renderiza y muestra una imagen a partir de la URL
/// </summary>
public partial class ImagenPorURL : System.Web.UI.Page
{
    public byte[] obtenerImagen(String url)
    {
        String urlImagen = Server.MapPath(url);

        if (!System.IO.File.Exists(urlImagen))
        {
            urlImagen = Server.MapPath("~\\Recursos\\Imagenes\\PerfilUsuario" + "Usuario.png");
        }
        byte[] fileBytes = System.IO.File.ReadAllBytes(urlImagen);
        return fileBytes;
    }
}