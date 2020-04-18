using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DaoUsuario
/// </summary>
public class DaoUsuario
{
    private Base db = new Base();
    public DaoUsuario()
    {

    }

    public void  actualizarUsuario(EUsuario usuario)
    {
        //EntityState Enum
        //System.Data.Entity
        db.Entry(usuario).State = System.Data.Entity.EntityState.Modified;
         db.SaveChanges();
    }
}