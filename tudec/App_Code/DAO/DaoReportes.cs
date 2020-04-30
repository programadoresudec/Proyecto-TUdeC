using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DaoReportes
/// </summary>
public class DaoReportes
{
    private Base db = new Base();
    public List<EMotivoReporte> getMotivoReporte()
    {
        List<EMotivoReporte> motivos = db.TablaMotivos.ToList();
        EMotivoReporte motivoPorDefecto = new EMotivoReporte();
        motivoPorDefecto.MotivoDelReporte = "Estado";
        motivos.Insert(0, motivoPorDefecto);
        return motivos;
    }
}