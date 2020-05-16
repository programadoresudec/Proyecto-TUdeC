using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DaoNotificacion
/// </summary>
public class DaoNotificacion
{
    private Base db = new Base();
    public List<ENotificacion> notificacionesDelUsuario(string nombreUsuario)
    {
        return db.TablaNotificaciones.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).ToList();
    }

    public int numeroDeNotificaciones(string nombreUsuario)
    {
        return db.TablaNotificaciones.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).Count();
    }
}