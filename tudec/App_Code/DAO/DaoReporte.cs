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
               // where reporte.NombreDeUsuarioDenunciado.Equals(nombreDeUsuarioDenunciado) && reporte.Estado.Equals(false)
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
                }).OrderByDescending(x=> x.Fecha).ToList();
    }

    public void actualizarMotivo(EReporte reporte)
    {
        EReporte reportado =  db.TablaReportes.Where(x => x.Id == reporte.Id).First();
        reportado.MotivoDelReporte = reporte.MotivoDelReporte;
        Base.Actualizar(reportado);
    }

    public void reportarUsuario(int id)
    {
        EReporte reportado = db.TablaReportes.Where(x => x.Id == id).First();
        
        Base.Actualizar(reportado);
    }

    private void validarMotivoDelReporte(string motivoDelReporte, string nombre)
    {
        EUsuario user = new DaoUsuario().GetUsuario(nombre);
        switch (motivoDelReporte)
        {
            case Constantes.MOTIVO_1:
                user.FechaDesbloqueo = DateTime.Now.AddDays(Constantes.DIAS_MOTIVO_1);
                user.PuntuacionDeBloqueo += Constantes.PUNTUACION_MOTIVO_1;
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_2:
                user.FechaDesbloqueo = DateTime.Now.AddDays(Constantes.DIAS_MOTIVO_2);
                user.PuntuacionDeBloqueo += Constantes.PUNTUACION_MOTIVO_2;
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_3:
                user.FechaDesbloqueo = DateTime.Now.AddDays(Constantes.DIAS_MOTIVO_3);
                user.PuntuacionDeBloqueo += Constantes.PUNTUACION_MOTIVO_3;
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_4:
                user.FechaDesbloqueo = DateTime.Now.AddDays(Constantes.DIAS_MOTIVO_4);
                user.PuntuacionDeBloqueo += Constantes.PUNTUACION_MOTIVO_4;
                Base.Actualizar(user);
                break;
            case Constantes.MOTIVO_5:
                user.FechaDesbloqueo = DateTime.Now.AddDays(Constantes.DIAS_MOTIVO_5);
                user.PuntuacionDeBloqueo += Constantes.PUNTUACION_MOTIVO_5;
                Base.Actualizar(user);
                break;
            default:
                break;
        }
    }
}