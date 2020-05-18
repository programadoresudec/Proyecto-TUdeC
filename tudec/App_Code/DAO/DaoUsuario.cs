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
        return db.TablaCursos.Where(x => x.Creador.Equals(eUsuario.NombreDeUsuario)).ToList();

    }

    public EUsuario GetUsuario(string nombreUsuario)
    {
        return db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).First();
    }

    public List<EUsuario> GetUsuarios(ECurso curso)
    {

        List<EInscripcionesCursos> inscripciones = db.TablaInscripciones.Where(x => x.IdCurso == curso.Id).ToList();

        List<EUsuario> usuarios = new List<EUsuario>();

        foreach(EInscripcionesCursos inscripcion in inscripciones)
        {

            EUsuario usuario = GetUsuario(inscripcion.NombreUsuario);

            usuarios.Add(usuario);

        }

        return usuarios;

    }

    public List<EUsuario> gestionDeUsuarioAdmin(string estado, string nombre)
    {
        List<EUsuario> usuarios = new List<EUsuario>();
        if (!string.IsNullOrEmpty(nombre) && estado.Equals("Estado"))
        {
            usuarios = filtroNombre(nombre);
        }
        else if (!(string.IsNullOrEmpty(estado) || estado.Equals("Estado")))
        {
            usuarios = filtroEstado(estado);
        }
        else if (estado.Equals("Estado"))
        {
            usuarios = (from usuario in db.TablaUsuarios
                        where usuario.Rol.Equals(Constantes.ROL_USER)
                        select new
                        {
                            usuario
                        }).ToList().Select(x => new EUsuario
                        {
                            NombreDeUsuario = x.usuario.NombreDeUsuario,
                            ImagenPerfil = x.usuario.ImagenPerfil == null ? Constantes.IMAGEN_DEFAULT : x.usuario.ImagenPerfil,
                            FechaCreacion = x.usuario.FechaCreacion,
                            Estado = x.usuario.Estado,
                            FechaDesbloqueo = x.usuario.FechaDesbloqueo,
                            NumCursos = getNumeroDeCursosxUsuario(x.usuario.NombreDeUsuario),
                            NumeroDeReportes = getNumeroDeReportesxUsuario(x.usuario.NombreDeUsuario),
                            PuntuacionDeBloqueo = x.usuario.PuntuacionDeBloqueo == null ? 0 : x.usuario.PuntuacionDeBloqueo,
                        }).OrderByDescending(x => x.FechaCreacion).ToList();
        }
        return usuarios;
    }

    private List<EUsuario> filtroNombre(string nombre)
    {
        return (from usuario in db.TablaUsuarios
                where usuario.Rol.Equals(Constantes.ROL_USER) && usuario.NombreDeUsuario.ToLower().Equals(nombre.ToLower())
                select new
                {
                    usuario
                }).ToList().Select(x => new EUsuario
                {
                    NombreDeUsuario = x.usuario.NombreDeUsuario,
                    ImagenPerfil = x.usuario.ImagenPerfil == null ? Constantes.IMAGEN_DEFAULT : x.usuario.ImagenPerfil,
                    FechaCreacion = x.usuario.FechaCreacion,
                    Estado = x.usuario.Estado,
                    FechaDesbloqueo = x.usuario.FechaDesbloqueo,
                    NumCursos = getNumeroDeCursosxUsuario(x.usuario.NombreDeUsuario),
                    NumeroDeReportes = getNumeroDeReportesxUsuario(x.usuario.NombreDeUsuario),
                    PuntuacionDeBloqueo = x.usuario.PuntuacionDeBloqueo == null ? 0 : x.usuario.PuntuacionDeBloqueo,
                }).OrderByDescending(x => x.FechaCreacion).ToList();
    }

    private List<EUsuario> filtroEstado(string estado)
    {
        return (from usuario in db.TablaUsuarios
                where usuario.Rol.Equals(Constantes.ROL_USER) && usuario.Estado.Equals(estado)
                select new
                {
                    usuario
                }).ToList().Select(x => new EUsuario
                {
                    NombreDeUsuario = x.usuario.NombreDeUsuario,
                    ImagenPerfil = x.usuario.ImagenPerfil == null ? Constantes.IMAGEN_DEFAULT : x.usuario.ImagenPerfil,
                    FechaCreacion = x.usuario.FechaCreacion,
                    Estado = x.usuario.Estado,
                    FechaDesbloqueo = x.usuario.FechaDesbloqueo,
                    NumCursos = getNumeroDeCursosxUsuario(x.usuario.NombreDeUsuario),
                    NumeroDeReportes = getNumeroDeReportesxUsuario(x.usuario.NombreDeUsuario),
                    PuntuacionDeBloqueo = x.usuario.PuntuacionDeBloqueo == null ? 0 : x.usuario.PuntuacionDeBloqueo,
                }).OrderByDescending(x => x.FechaCreacion).ToList();
    }


    public void bloquearUsuariosConCuenta(string nombreUsuario)
    {
        EUsuario usuarioParaBloquear = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).First();
        if (usuarioParaBloquear.PuntuacionDeBloqueo >= Constantes.PUNTUACION_MAXIMA_PARA_SER_BLOQUEADO)
        {
            usuarioParaBloquear.Estado = Constantes.ESTADO_BLOQUEADO;
        }
        Base.Actualizar(usuarioParaBloquear);
        // Query para modificar varias tablas.
        //usuariosConReportes.ForEach(x => x.Estado = Constantes.ESTADO_BLOQUEADO);
        //if (usuariosConReportes.Count > 0)
        //{
        //    foreach (var item in usuariosConReportes)
        //    {
        //        db.TablaUsuarios.Attach(item);
        //        db.Entry(item).Property(x => x.Estado).IsModified = true;
        //    }
        //}
        //db.SaveChanges();
    }

    private int getNumeroDeReportesxUsuario(string nombreDeUsuario)
    {
        return db.TablaReportes.Where(x => x.NombreDeUsuarioDenunciado == nombreDeUsuario).Count();
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

    public int getNumeroDeCursosxUsuario(string user)
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
        foreach (EEjecucionExamen ejecucion in ejecuciones)
        {
            usuarios.Add(GetUsuario(ejecucion.NombreUsuario));
        }
        return usuarios;
    }
}