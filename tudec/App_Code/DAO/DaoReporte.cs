using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DaoReportes
/// </summary>
public class DaoReporte
{
    private Base db = new Base();
    public List<EMotivoReporte> getMotivoReporte()
    {
        List<EMotivoReporte> motivos = db.TablaMotivos.ToList();
        EMotivoReporte motivoDefault = new EMotivoReporte();
        motivoDefault.Motivo = "Motivo";
        motivos.Insert(0, motivoDefault);
        return motivos;
    }

    public List<EReporte> reportesDelUsuario(string nombreDeUsuarioDenunciado)
    {
        return (from reporte in db.TablaReportes
                join comentario in db.TablaComentarios on reporte.IdComentario equals comentario.Id into reportexComentario
                from rc in reportexComentario.DefaultIfEmpty()
                join mensaje in db.TablaMensajes on reporte.IdMensaje equals mensaje.Id into reportexMensaje
                from rm in reportexMensaje.DefaultIfEmpty()
                where reporte.Estado == false && reporte.NombreDeUsuarioDenunciado.Equals(nombreDeUsuarioDenunciado)
                select new
                {
                    reporte,
                    rm,
                    rc
                }).ToList().Select(x => new EReporte
                {
                    Id = x.reporte.Id,
                    Descripcion = x.reporte.Descripcion,
                    MotivoDelReporte = x.reporte.MotivoDelReporte,
                    NombreDeUsuarioDenunciado = x.reporte.NombreDeUsuarioDenunciado,
                    NombreDeUsuarioDenunciante = x.reporte.NombreDeUsuarioDenunciante,
                    Fecha = x.reporte.Fecha,
                    IdComentario = x.reporte.IdComentario == null ? 0 : x.reporte.IdComentario,
                    Comentario = x.rc == null ? string.Empty : x.rc.Comentario,
                    ImagenesComentario = x.rc == null ? null : x.rc.Imagenes,
                    IdMensaje = x.reporte.IdMensaje == null ? 0 : x.reporte.IdMensaje,
                    Mensaje = x.rm == null ? string.Empty : x.rm.Contenido,

                }
        ).OrderByDescending(x => x.Fecha).ToList();
    }

    public List<EReporte> reportesVistos(string nombreUsuario)
    {
        return (from reporte in db.TablaReportes
                where reporte.NombreDeUsuarioDenunciado.ToLower().Equals(nombreUsuario.ToLower()) && reporte.Estado == true
                select new
                {
                    reporte

                }).ToList().Select(x => new EReporte
                {
                    MotivoDelReporte = x.reporte.MotivoDelReporte,
                    Descripcion = x.reporte.Descripcion,
                    NombreDeUsuarioDenunciado = x.reporte.NombreDeUsuarioDenunciado,
                    NombreDeUsuarioDenunciante = x.reporte.NombreDeUsuarioDenunciante,
                    Fecha = x.reporte.Fecha
                }).ToList();
    }

    public void desbloquearUsuario(string usuario)
    {
        EUsuario desbloquear = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(usuario)).First();
        desbloquear.Estado = Constantes.ESTADO_ACTIVO;
        desbloquear.PuntuacionDeBloqueo = 0;
        desbloquear.LastModify = DateTime.Now;
        Base.Actualizar(desbloquear);
    }

    public void actualizarMotivo(EReporte reporte)
    {
        EReporte reportado = db.TablaReportes.Where(x => x.Id == reporte.Id).First();
        reportado.MotivoDelReporte = reporte.MotivoDelReporte;
        reportado.Estado = true;
        Base.Actualizar(reportado);
        List<int> listaDiasYpuntuacion = buscarDiasYPuntuacionParaReportar(reportado.MotivoDelReporte);
        validarMotivoDelReporte(reportado.MotivoDelReporte, reportado.NombreDeUsuarioDenunciado, listaDiasYpuntuacion);
    }

    public List<int> buscarDiasYPuntuacionParaReportar(string motivoDelReporte)
    {
        int dias = db.TablaMotivos.Where(x => x.Motivo.Equals(motivoDelReporte)).Select(c => c.DiasxReporte).First();
        int puntuacionParaBloquear = db.TablaMotivos.Where(x => x.Motivo.Equals(motivoDelReporte)).Select(c => c.PuntuacionxBloqueo).First();
        List<int> lista = new List<int> { dias, puntuacionParaBloquear };
        return lista;
    }


    public void quitarReporte(int id)
    {
        EReporte reportado = db.TablaReportes.Where(x => x.Id == id).First();
        Base.Eliminar(reportado);
    }

    private void validarMotivoDelReporte(string motivoDelReporte, string nombre, List<int> lista)
    {
        EUsuario user = new DaoUsuario().GetUsuario(nombre);
        switch (motivoDelReporte)
        {
            case Constantes.MOTIVO_1:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, lista[0]);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, lista[1]);
                if (user.PuntuacionDeBloqueo < Constantes.PUNTUACION_MAXIMA_PARA_SER_BLOQUEADO)
                {
                    user.Estado = Constantes.ESTADO_REPORTADO;
                }
                else
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_2:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, lista[0]);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, lista[1]);
                if (user.PuntuacionDeBloqueo < Constantes.PUNTUACION_MAXIMA_PARA_SER_BLOQUEADO)
                {
                    user.Estado = Constantes.ESTADO_REPORTADO;
                }
                else
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_3:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, lista[0]);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, lista[1]);
                if (user.PuntuacionDeBloqueo < Constantes.PUNTUACION_MAXIMA_PARA_SER_BLOQUEADO)
                {
                    user.Estado = Constantes.ESTADO_REPORTADO;
                }
                else
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_4:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, lista[0]);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, lista[1]);
                if (user.PuntuacionDeBloqueo < Constantes.PUNTUACION_MAXIMA_PARA_SER_BLOQUEADO)
                {
                    user.Estado = Constantes.ESTADO_REPORTADO;
                }
                else
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_5:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, lista[0]);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, lista[1]);
                if (user.PuntuacionDeBloqueo < Constantes.PUNTUACION_MAXIMA_PARA_SER_BLOQUEADO)
                {
                    user.Estado = Constantes.ESTADO_REPORTADO;
                }
                else
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            default:
                break;
        }
    }

    private DateTime? agregarDiasDeBloqueo(string nombreDeUsuario, double diasAgregados)
    {
        Nullable<DateTime> fechaDeDesbloqueo = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreDeUsuario)).Select(x => x.FechaDesbloqueo).SingleOrDefault();
        return fechaDeDesbloqueo = fechaDeDesbloqueo == null ? DateTime.Now.AddDays(diasAgregados)
            : fechaDeDesbloqueo < DateTime.Now ? DateTime.Now.AddDays(diasAgregados)
            : fechaDeDesbloqueo.Value.AddDays(diasAgregados);
    }

    private int? sumarPuntuacionDeBloqueo(string nombreDeUsuario, int puntuacionMotivo)
    {
        Nullable<int> puntuacionActual = db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreDeUsuario)).Select(x => x.PuntuacionDeBloqueo).SingleOrDefault();
        return puntuacionActual == null ? puntuacionActual = puntuacionMotivo
            : (puntuacionActual.Value + puntuacionMotivo);
    }
}