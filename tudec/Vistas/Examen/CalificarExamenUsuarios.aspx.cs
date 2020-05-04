using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Examen_CalificarExamenUsuarios : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        tablaUsuarios.DataBind();

    }

    protected void tablaUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = (GridViewRow)e.Row;

        if(fila.RowIndex > -1)
        {

            TableCell celdaNombre = fila.Cells[0];

            LinkButton hiperEnlaceCalificarExamen = new LinkButton();
            hiperEnlaceCalificarExamen.Text = celdaNombre.Text;
            hiperEnlaceCalificarExamen.Click += new EventHandler(CalificarExamen);

            celdaNombre.Controls.Add(hiperEnlaceCalificarExamen);

        }

    }

    public void CalificarExamen(object sender, EventArgs e)
    {

        LinkButton hiperEnlace = (LinkButton)sender;

        DaoUsuario gestorUsuarios = new DaoUsuario();

        EUsuario usuario = gestorUsuarios.GetUsuario(hiperEnlace.Text);

        Session[Constantes.USUARIO_SELECCIONADO] = usuario;

        Response.Redirect("~/Vistas/Examen/CalificarExamen.aspx");

    }

}