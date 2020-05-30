using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_ReportesCrystal_ReporteAdmin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void generarReporte_Click(object sender, EventArgs e)
    {
        pintarReporte();
    }

    protected void pintarReporte()
    {
        
        sourceReporteAdmin.ReportDocument.SetDataSource(imprimirReporte(TB_nombreUsuario.Text));
        CRV_Admin.Visible = true;
        CRV_Admin.ReportSource = sourceReporteAdmin;

    }

    protected DataSet imprimirReporte(string nombreUsuario)
    {
        DataSet reporte = new DataSet();
        List<EReporte> lista = new DaoReporte().reportesVistos(nombreUsuario);
        DataTable datosFinal = reporte.Usuario;
        DataRow fila;

        foreach (EReporte reportesVistos in lista)
        {
            fila = datosFinal.NewRow();
            fila["usuarioDenunciado"] = reportesVistos.NombreDeUsuarioDenunciado;
            fila["usuarioDenunciante"] = reportesVistos.NombreDeUsuarioDenunciante;
            fila["Motivo"] = reportesVistos.MotivoDelReporte;
            fila["Descripcion"] = reportesVistos.Descripcion;
            fila["FechaReporte"]= reportesVistos.Fecha;
            datosFinal.Rows.Add(fila);
        }
        return reporte;
    }
}