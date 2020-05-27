using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_ReportesCrystal_ReporteCursosAreas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        sourceReporte.ReportDocument.SetDataSource(informacionReporte());
        viewerReporte.ReportSource = sourceReporte;

    }


    protected DataSet informacionReporte()
    {

        DataSet esquema = new DataSet();
        GestionCurso gestorCursos = new GestionCurso();
        List<EArea> areas = gestorCursos.GetAreas();

        DataTable tablaCursos = esquema.Areas;
        DataRow fila;

        foreach (EArea area in areas)
        {

            fila = tablaCursos.NewRow();

            fila["nombre"] = area.Area;
            fila["nCursos"] = gestorCursos.GetCursos().Where(x => x.Area.Equals(area.Area)).Count();

            tablaCursos.Rows.Add(fila);

        }

        return esquema;

    }
}