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

    public async void  actualizarUsuario(EUsuario usuario)
    {
        EUsuario actualizar = db.TablaUsuarios.Where(x => x.NombreDeUsuario == usuario.NombreDeUsuario).First();
        actualizar.NombreDeUsuario = usuario.NombreDeUsuario;
        actualizar.PrimerNombre = usuario.PrimerNombre;
        actualizar.SegundoNombre = usuario.SegundoNombre;
        actualizar.PrimerApellido = usuario.PrimerApellido;
        actualizar.SegundoApellido = usuario.SegundoApellido;
        actualizar.CorreoInstitucional = usuario.CorreoInstitucional;
        actualizar.Estado = usuario.Estado;
        actualizar.Token = usuario.Token;
        actualizar.VencimientoToken = usuario.VencimientoToken;
        actualizar.PrimerApellido = usuario.PrimerApellido;
        actualizar.Puntuacion = usuario.Puntuacion;
        actualizar.Pass = usuario.Pass;
        db.TablaUsuarios.Attach(actualizar);
        var entry = db.Entry(actualizar);
        entry.State = EntityState.Modified;
        await db.SaveChangesAsync();

    }
}