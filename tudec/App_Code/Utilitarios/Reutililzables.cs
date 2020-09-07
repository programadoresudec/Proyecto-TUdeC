using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
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


    public static string generarCodigoCurso()
    {
        string codigo = string.Empty;
        string[] letras = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
        Random EleccionAleatoria = new Random();

        for (int i = 0; i < Constantes.LONGITUD_CODIGO; i++)
        {
            int LetraAleatoria = EleccionAleatoria.Next(0, 100);
            int NumeroAleatorio = EleccionAleatoria.Next(0, 9);

            if (LetraAleatoria < letras.Length)
            {
                codigo += letras[LetraAleatoria];
            }
            else
            {
                codigo += NumeroAleatorio.ToString();
            }
        }
        return codigo;
    }

    public void FolderIsExist(string path) 
    { 
        bool folderExists = Directory.Exists(Server.MapPath(path)); 
        if (!folderExists)
            Directory.CreateDirectory(Server.MapPath(path));
    }
}