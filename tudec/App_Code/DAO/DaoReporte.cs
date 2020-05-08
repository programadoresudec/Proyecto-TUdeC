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
    public List<EMotivoReporte> getMotivoReporte(string motivo)
    {

        List<EMotivoReporte> motivos = db.TablaMotivos.ToList();
        EMotivoReporte motivoReportado = new EMotivoReporte();
        motivoReportado.MotivoDelReporte = motivo;
        motivos.Insert(0, motivoReportado);
        return motivos;
    }


    public List<EReporte> reportesDelUsuario(string nombreDeUsuarioDenunciado)
    {
        return (from reporte in db.TablaReportes
                join comentario in db.TablaComentarios on reporte.IdComentario equals comentario.Id
                join message in db.TablaMensajes on reporte.IdMensaje equals message.Id
                where reporte.NombreDeUsuarioDenunciado == nombreDeUsuarioDenunciado && 
                message.NombreDeUsuarioEmisor == reporte.NombreDeUsuarioDenunciante
                select new
                {
                    comentario,
                    reporte,
                    message
                }).ToList().Select(x => new EReporte
                {
                    Fecha = x.reporte.Fecha,
                    MotivoDelReporte = x.reporte.MotivoDelReporte,
                    Comentario = x.comentario.Comentario,
                    Mensaje = x.message.Contenido
                }).ToList();
    }
}