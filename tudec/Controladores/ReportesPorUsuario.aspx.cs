using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Admin_ReportesPorUsuario : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Quitar_Click(object sender, EventArgs e)
    {
        int id = 0;
        foreach (ListViewItem item in LV_Reportes.Items)
        {
            id = (int)item.DataItemIndex;
        }
        new DaoReporte().quitarReporte(id);
    }
}