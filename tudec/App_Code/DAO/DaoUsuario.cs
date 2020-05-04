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
        return (from usuario in db.TablaUsuarios
                where usuario.Rol == Constantes.ROL_USER
                select new
                {
                    usuario
                }).ToList().Select(x => new EUsuario
                {
                    NombreDeUsuario = x.usuario.NombreDeUsuario,
                    ImagenPerfil = x.usuario.ImagenPerfil == null ? Constantes.IMAGEN_DEFAULT : x.usuario.ImagenPerfil,
                    FechaCreacion = x.usuario.FechaCreacion,
                    Estado = x.usuario.Estado,
                    NumCursos = obtenerNumeroDeCursosxUsuario(x.usuario.NombreDeUsuario)
                }).ToList();
    }

    public string buscarDescripcionUsuario(string nombreDeUsuario)
    {
        return db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreDeUsuario)).Select(x => x.Descripcion).First();
    }

    public bool validarPassActual(string nombreDeUsuario, string passActual)
    {
        return db.TablaUsuarios.Any(x => x.NombreDeUsuario.Equals(nombreDeUsuario) && x.Pass.Equals(passActual));
    }
    public void actualizarPass(string nombreDeUsuario, string passNueva)
    {
        EUsuario usuario = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreDeUsuario)).First();
        usuario.Pass = passNueva;
        Base.Actualizar(usuario);
    }

    public int obtenerNumeroDeCursosxUsuario(string user)
    {
        return db.TablaCursos.Where(x => x.Creador == user).Count();
    }

    public void actualizarPerfil(string nombreDeUsuario, string descripcion)
    {
        EUsuario usuario = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreDeUsuario)).First();
        usuario.Descripcion = descripcion;
        Base.Actualizar(usuario);
    }

    public List<EEstadoUsuario> obtenerEstadosUsuario()
    {
        List<EEstadoUsuario> estados = db.TablaEstadosUsuario.ToList();
        EEstadoUsuario estadoPordefecto = new EEstadoUsuario();
        estadoPordefecto.Estado = "Estado";
        estados.Insert(0, estadoPordefecto);
        return estados;
    }

    public List<EPuntuacion> GetPuntuaciones()
    {

        List<EPuntuacion> puntuaciones = db.TablaPuntuaciones.ToList();

        return puntuaciones;

    }

    public void actualizarImagen(string nombreDeUsuario, string saveLocation)
    {
        EUsuario usuario = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreDeUsuario)).First();
        usuario.ImagenPerfil = saveLocation;
        Base.Actualizar(usuario);
    }

    public EPuntuacion GetPuntuacion(EUsuario emisor, EUsuario receptor)
    {

        EPuntuacion puntuacion = db.TablaPuntuaciones.Where(x => x.Emisor.Equals(emisor.NombreDeUsuario) && x.Receptor.Equals(receptor.NombreDeUsuario)).FirstOrDefault();

        return puntuacion;

    }

    public List<EPuntuacion> GetPuntuacionesUsuario(EUsuario usuario)
    {

        List<EPuntuacion> puntuaciones = db.TablaPuntuaciones.Where(x => x.Receptor.Equals(usuario.NombreDeUsuario)).ToList();

        return puntuaciones;

    }
    /// <summary>
    /// Metodo que obtiene la imagen si se actualiza.
    /// </summary>
    /// <param name="usuario"></param>
    /// <returns></returns>
    public string buscarImagen(string usuario)
    {
        string url = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(usuario)).Select(x => x.ImagenPerfil).SingleOrDefault();
        return url == null ? Constantes.IMAGEN_DEFAULT : url;
    }

    public List<EUsuario> GetUsuariosExamen(ETema tema)
    {

        EExamen examen = db.TablaExamenes.Where(x => x.IdTema == tema.Id).First();

        List<EEjecucionExamen> ejecuciones = db.TablaEjecucionExamen.Where(x => x.IdExamen == examen.Id).ToList();

        List<EUsuario> usuarios = new List<EUsuario>();

        foreach(EEjecucionExamen ejecucion in ejecuciones)
        {

            usuarios.Add(GetUsuario(ejecucion.NombreUsuario));

        }

        return usuarios;

    }

}