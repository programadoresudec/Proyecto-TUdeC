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
    public List<ECurso> GetCursos(EUsuario eUsuario)
    {
        List<ECurso> cursos = db.TablaCursos.Where(x => x.Creador.Equals(eUsuario.NombreDeUsuario)).ToList();
        return cursos;
    }

    public EUsuario GetUsuario(string nombreUsuario)
    {
        EUsuario usuario = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).First();
        return usuario;
    }

    public List<EUsuario> gestionDeUsuarioAdmin()
    {
        return (from usuario in db.TablaUsuarios where usuario.Rol == Constantes.ROL_USER
               
                select new
                {
                    usuario
    
                }).ToList().Select(x => new EUsuario
                {
                    NombreDeUsuario = x.usuario.NombreDeUsuario,
                    ImagenPerfil = x.usuario.ImagenPerfil,
                    FechaCreacion = x.usuario.FechaCreacion,
                    NumCursos =  obtenerNumeroDeCursosxUsuario(x.usuario.NombreDeUsuario)
                }).ToList();
    }

    public int obtenerNumeroDeCursosxUsuario(string user)
    {
         return db.TablaCursos.Where(x => x.Creador == user).Count(); 
    }

}