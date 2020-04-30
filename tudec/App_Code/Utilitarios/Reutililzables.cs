using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;
/// <summary>
/// Clase que utiliza metodos reutlizables
/// </summary>
public partial class Reutilizables : Page
{
    /// <summary>
    /// Método para obtener una imagen mediante bytes.
    /// </summary>
    /// <param name="url"></param>
    /// <returns></returns>
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
    /// <summary>
    /// Metodo que encripta una cadena.
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    public static string encriptar(string input)
    {
        SHA256CryptoServiceProvider provider = new SHA256CryptoServiceProvider();
        byte[] inputBytes = Encoding.UTF8.GetBytes(input);
        byte[] hashedBytes = provider.ComputeHash(inputBytes);
        StringBuilder output = new StringBuilder();
        for (int i = 0; i < hashedBytes.Length; i++)
            output.Append(hashedBytes[i].ToString("x2").ToLower());
        return output.ToString();
    }
    /// <summary>
    /// Metodo que obtiene la excepcion interna.
    /// </summary>
    /// <typeparam name="TException"></typeparam>
    /// <param name="exception"></param>
    /// <returns></returns>
    public static TException GetInnerException<TException>(Exception exception)
        where TException : Exception
    {
        Exception innerException = exception;
        while (innerException != null)
        {
            if (innerException is TException result)
            {
                return result;
            }
            innerException = innerException.InnerException;
        }
        return null;
    }
}