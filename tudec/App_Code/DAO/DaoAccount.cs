using Npgsql;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
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
        try
        {
            db.SaveChanges();
        }
        catch (DbUpdateException ex) // catch DbUpdateException explicitly
        {
            if (ex.GetBaseException() is NpgsqlException pgException)
            {
                switch (pgException.SqlState)
                {
                    case "23505":
                        
                    default:
                        throw;
                }
            }
        }
    }

    public TException GetInnerException<TException>(Exception exception)
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