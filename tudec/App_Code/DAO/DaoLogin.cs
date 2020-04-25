using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DaoLogin
/// </summary>
public class DaoLogin : IToken
{
    private Base db = new Base();
    public DaoLogin()
    {

    }
    /// <summary>
    /// Metodo que retorna el logeo por nombre de usuario
    /// </summary>
    /// <param name="nombreUsuario"></param>
    /// <param name="pass"></param>
    /// <returns> retorna un objeto Eusuario</returns>
    public EUsuario GetUsuarioxApodo(string nombreUsuario, string pass)
    {
        return db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)
        && x.Pass.Equals(pass)).FirstOrDefault();
    }

    /// <summary>
    /// Metodo que retorna el logeo por correo eléctronico
    /// </summary>
    /// <param name="correo"></param>
    /// <param name="pass"></param>
    /// <returns>
    /// retorna un objeto Eusuario
    /// </returns>
    public EUsuario GetUsuarioxCorreo(string correo, string pass)
    {
        return db.TablaUsuarios.Where(x => x.CorreoInstitucional.Equals(correo)
        && x.Pass.Equals(pass)).FirstOrDefault();
    }

    /// <summary>
    /// Método que busca el usuario si tiene token
    /// </summary>
    /// <param name="token"></param>
    /// <returns></returns>
    public EUsuario buscarUsuarioxToken(string token)
    {
        return db.TablaUsuarios.Where(x => x.Token.Equals(token)
        && x.Estado.Equals(Constantes.ESTADO_CAMBIO_PASS)).FirstOrDefault();
    }
    /// <summary>
    /// Método que busca el correo si existe.
    /// </summary>
    /// <param name="correo"></param>
    /// <returns></returns>
    public EUsuario buscarCorreo(string correo)
    {
        return db.TablaUsuarios.Where(x => x.CorreoInstitucional.Equals(correo)).FirstOrDefault();
    }
}