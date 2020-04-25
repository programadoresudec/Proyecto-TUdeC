using Npgsql;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

public class DaoRegister : IToken
{
    private Base db = new Base();
    public DaoRegister()
    {

    }
    /// <summary>
    /// metodo que buscar el usuario por el token
    /// </summary>
    /// <param name="token"></param>
    /// <returns>
    /// retorna un objeto Eusuario
    /// </returns>
    public EUsuario buscarUsuarioxToken(string token)
    {
        return db.TablaUsuarios.Where(x => x.Token.Equals(token)
        && x.Estado.Equals(Constantes.ESTADO_EN_ESPERA)).FirstOrDefault();
    }

    /// <summary>
    /// metodo que registra el usuario
    /// </summary>
    /// <param name="registro"></param>
    public void registroUsuario(EUsuario registro)
    {
        db.TablaUsuarios.Add(registro);
        try
        {
            db.SaveChanges();
        }
        catch (DbUpdateException ex) // catch DbUpdateException
        {
            // variable que le pasa un metodo para obtener el error dentro de postgres
            var pgsqlException = new Excepciones().GetInnerException<PostgresException>(ex);
            if (pgsqlException != null)
            {
                switch (pgsqlException.SqlState)
                {
                    // el error 23505 de postgres clave unica(pk o unique)
                    case "23505":
                        if (pgsqlException.ConstraintName.Contains(Constantes.ESTADO_PK))
                        {
                            registro.Estado = Constantes.ESTADO_PK;
                        }
                        else if (pgsqlException.ConstraintName.Contains(Constantes.ESTADO_UNIQUE))
                        {
                            registro.Estado = Constantes.ESTADO_UNIQUE;
                        }
                        break;
                    default:
                        throw;
                }
            }
        }
    }
}