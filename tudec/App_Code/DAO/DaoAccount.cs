using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;


public class DaoAccount
{
    private Base db = new Base();

    //Metodo que valida el logeo por nombre de usuario
    public EUsuario GetUsuario(string nombreUsuario, string pass)
    {
        EUsuario usuario = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)
        && x.Pass.Equals(pass)).FirstOrDefault();
        return usuario;
    }

    //Metodo que valida el logeo por nombre de usuario
    public EUsuario GetUsuarioxCorreo(string correo, string pass)
    {
        EUsuario usuario = db.TablaUsuarios.Where(x => x.CorreoInstitucional.Equals(correo)
        && x.Pass.Equals(pass)).FirstOrDefault();
        return usuario;
    }

    //Metodo que registra el usuario
    public void registroUsuario(EUsuario registro)
    {
        db.TablaUsuarios.Add(registro);
        db.SaveChanges();
    }
}