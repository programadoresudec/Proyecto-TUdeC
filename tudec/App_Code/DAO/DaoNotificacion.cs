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
       return db.TablaNotificaciones.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).OrderByDescending(x => x.Fecha).ToList();
    }

    public int numeroDeNotificaciones(string nombreUsuario)
    {
        return db.TablaNotificaciones.Where(x => x.NombreDeUsuario.Equals(nombreUsuario) && x.Estado == true).Count();
    }

    public int tieneNotificaciones(string nombreUsuario)
    {
        return db.TablaNotificaciones.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).Count();
    }

    public void MarcarEnVistoTodas(string nombreDeUsuario)
    {
        List<ENotificacion> notificaciones = db.TablaNotificaciones.Where(x => x.NombreDeUsuario.Equals(nombreDeUsuario)).ToList();
        notificaciones.ForEach(x => x.Estado = false);
        if (notificaciones.Count > 0)
        {
            foreach (var notificacion in notificaciones)
            {
                db.TablaNotificaciones.Attach(notificacion);
                db.Entry(notificacion).Property(x => x.Estado).IsModified = true;
            }
        }
        db.SaveChanges();
    }

    public string buscarNombreAdministrador()
    {
        return db.TablaUsuarios.Where(x => x.Rol.Equals(Constantes.ROL_ADMIN)).Select(x => x.NombreDeUsuario).First();
    }

    public void eliminar(int id)
    {
        ENotificacion notificacion = db.TablaNotificaciones.Where(x => x.Id == id).First();
        Base.Eliminar(notificacion);
        
    }
}