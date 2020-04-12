using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for seguridad
/// </summary>
public partial class Encriptacion
{
    public Encriptacion()
    {
     
    }
    // Metodo Que encripta un string
    public string encriptar(string input)
    {
        SHA256CryptoServiceProvider provider = new SHA256CryptoServiceProvider();
        byte[] inputBytes = Encoding.UTF8.GetBytes(input);
        byte[] hashedBytes = provider.ComputeHash(inputBytes);
        StringBuilder output = new StringBuilder();
        for (int i = 0; i < hashedBytes.Length; i++)
        output.Append(hashedBytes[i].ToString("x2").ToLower());
        return output.ToString();
    }

}