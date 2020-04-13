using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DaoLogin
/// </summary>
public class DaoLogin:IToken
{
    private Base db = new Base();
    public DaoLogin()
    {
    
    }

    //Metodo que valida el logeo por nombre de usuario
    public EUsuario GetUsuario(string nombreUsuario, string pass)
    {
        return db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)
        && x.Pass.Equals(pass)).FirstOrDefault();
    }

    //Metodo que valida el logeo por nombre de usuario
    public EUsuario GetUsuarioxCorreo(string correo, string pass)
    {
        return db.TablaUsuarios.Where(x => x.CorreoInstitucional.Equals(correo)
        && x.Pass.Equals(pass)).FirstOrDefault();
    }

    public EUsuario buscarUsuarioxToken(string token)
    {
        return db.TablaUsuarios.Where(x => x.Token.Equals(token) 
        && x.Estado.Equals(Constantes.ESTADO_CAMBIO_PASS)).FirstOrDefault();
    }
}