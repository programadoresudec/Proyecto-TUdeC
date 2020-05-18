using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de GestionMensajes
/// </summary>
public class GestionMensajes
{
    
    private Base db = new Base();

    public GestionMensajes()
    {
        //
        // TODO: Agregar aquí la lógica del constructor
        //
    }

    public List<EMensaje> GetMensajes(EUsuario emisor, EUsuario receptor, ECurso curso)
    {

        List<EMensaje> mensajes = db.TablaMensajes.Where(x => x.NombreDeUsuarioEmisor.Equals(emisor.NombreDeUsuario) && x.NombreDeUsuarioReceptor.Equals(receptor.NombreDeUsuario) && x.IdCurso == curso.Id
        || x.NombreDeUsuarioEmisor.Equals(receptor.NombreDeUsuario) && x.NombreDeUsuarioReceptor.Equals(emisor.NombreDeUsuario) && x.IdCurso == curso.Id).OrderBy(x => x.Fecha).ToList();

        return mensajes;

    }
}