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
                where reporte.NombreDeUsuarioDenunciado == nombreDeUsuarioDenunciado
                && comentario.Emisor == reporte.NombreDeUsuarioDenunciante
                select new
                {
                    comentario,
                    reporte
                }).ToList().Select(x => new EReporte
                {
                    Fecha = x.reporte.Fecha,
                    IdComentario = x.comentario.Id,
                    MotivoDelReporte = x.reporte.MotivoDelReporte,
                    Comentario = x.comentario.Comentario,

                                      
                }).ToList();
    }
}