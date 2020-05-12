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
        return db.TablaMotivos.ToList();
    }

    public List<EReporte> reportesDelUsuario(string nombreDeUsuarioDenunciado)
    {
        return (from reporte in db.TablaReportes
                join comentario in db.TablaComentarios on reporte.IdComentario equals comentario.Id
                join message in db.TablaMensajes on reporte.IdMensaje equals message.Id
                where reporte.NombreDeUsuarioDenunciado.Equals(nombreDeUsuarioDenunciado) && reporte.Estado.Equals(false)
                select new
                {
                    comentario,
                    reporte,
                    message
                }).ToList().Select(x => new EReporte
                {
                    Id = x.reporte.Id,
                    Fecha = x.reporte.Fecha,
                    MotivoDelReporte = x.reporte.MotivoDelReporte,
                    NombreDeUsuarioDenunciado = x.reporte.NombreDeUsuarioDenunciado,
                    NombreDeUsuarioDenunciante = x.reporte.NombreDeUsuarioDenunciante,
                    IdComentario = x.reporte.IdComentario,
                    IdMensaje = x.reporte.IdMensaje,
                    Descripcion = x.reporte.Descripcion,
                    Comentario = x.comentario.Comentario,
                    Mensaje = x.message.Contenido,
                    ImagenesComentario = x.comentario.Imagenes,
                    ImagenesMensaje = x.message.Imagenes
                }).OrderByDescending(x => x.Fecha).ToList();
    }

    public void actualizarMotivo(EReporte reporte)
    {
        EReporte reportado = db.TablaReportes.Where(x => x.Id == reporte.Id).First();
        reportado.MotivoDelReporte = reporte.MotivoDelReporte;
        reportado.Estado = true;
        Base.Actualizar(reportado);
        validarMotivoDelReporte(reportado.MotivoDelReporte, reportado.NombreDeUsuarioDenunciado);
    }

    public void quitarReporte(int id)
    {
        EReporte reportado = db.TablaReportes.Where(x => x.Id == id).First();
        reportado.Estado = true;
        Base.Actualizar(reportado);
    }

    private void validarMotivoDelReporte(string motivoDelReporte, string nombre)
    {
        EUsuario user = new DaoUsuario().GetUsuario(nombre);
        switch (motivoDelReporte)
        {
            case Constantes.MOTIVO_1:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, Constantes.DIAS_MOTIVO_1);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, Constantes.PUNTUACION_MOTIVO_1);
                if (validarPuntosDeBloqueo(user.NombreDeUsuario))
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_2:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, Constantes.DIAS_MOTIVO_2);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, Constantes.PUNTUACION_MOTIVO_2);
                if (validarPuntosDeBloqueo(user.NombreDeUsuario))
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_3:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, Constantes.DIAS_MOTIVO_3);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, Constantes.PUNTUACION_MOTIVO_3);
                if (validarPuntosDeBloqueo(user.NombreDeUsuario))
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_4:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, Constantes.DIAS_MOTIVO_4);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, Constantes.PUNTUACION_MOTIVO_4);
                if (validarPuntosDeBloqueo(user.NombreDeUsuario))
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_5:
                user.FechaDesbloqueo = agregarDiasDeBloqueo(user.NombreDeUsuario, Constantes.DIAS_MOTIVO_5);
                user.PuntuacionDeBloqueo = sumarPuntuacionDeBloqueo(user.NombreDeUsuario, Constantes.PUNTUACION_MOTIVO_5);
                if (validarPuntosDeBloqueo(user.NombreDeUsuario))
                {
                    user.Estado = Constantes.ESTADO_BLOQUEADO;
                }
                Base.Actualizar(user);
                break;
            default:
                break;
        }
    }

    private bool validarPuntosDeBloqueo(string nombreDeUsuario)
    {
        return db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreDeUsuario)).Any(x => x.PuntuacionDeBloqueo == Constantes.PUNTUACION_MAXIMA_PARA_SER_REPORTADO);
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
        return puntuacionActual == null ? puntuacionActual = puntuacionMotivo : (puntuacionActual.Value + puntuacionMotivo);
    }
}