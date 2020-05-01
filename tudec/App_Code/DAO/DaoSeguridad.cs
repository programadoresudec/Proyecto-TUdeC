using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DaoSeguridad
/// </summary>
public class DaoSeguridad
{

    Base db = new Base();
    public void actualizarUsuarioAutentication(EAutentication autenticar)
    {
        EAutentication autenticacion = db.TablaAutenticaciones.Where(x => x.Session == autenticar.Session
        && x.NombreDeUsuario == autenticar.NombreDeUsuario).First();
        autenticacion.FechaFin = DateTime.Now;
        Base.Actualizar(autenticacion);
    }
}