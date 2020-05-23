using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_CampanaNotificacion_CampanaNotifcacion : System.Web.UI.UserControl
{
    EUsuario usuario;
    protected void Page_Load(object sender, EventArgs e)
    {
        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        if (usuario != null)
        {
            BtnNotificaciones.Visible = true;
            int numDeNotificaciones = new DaoNotificacion().numeroDeNotificaciones(usuario.NombreDeUsuario);
            if (numDeNotificaciones > 0)
            {
                LB_campana.Text = numDeNotificaciones.ToString();
                LB_campana.Visible = true;
                if (numDeNotificaciones == 1)
                {
                    Notificaciones.Text = "Tiene " + numDeNotificaciones.ToString() + " Notificación";
                }
                else
                {
                    Notificaciones.Text = "Tiene " + numDeNotificaciones.ToString() + " Notificaciones";
                }
            }
            else
            {
                LB_campana.Visible = false;
                Notificaciones.Text = "No Tiene Notificaciones.";
            }
        }
    }

    protected void Notificaciones_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Vistas/Notificaciones/Notificaciones.aspx");
    }



    //protected void tiempoDeRefresco_Tick(object sender, EventArgs e)
    //{
    //    if (!IsPostBack)
    //    {
    //        tiempoDeRefresco.Enabled = true;
    //        usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
    //        if (usuario != null)
    //        {
    //            int numDeNotificaciones = new DaoNotificacion().numeroDeNotificaciones(usuario.NombreDeUsuario);
    //            if (numDeNotificaciones > 0)
    //            {
    //                LB_campana.Visible = true;
    //                if (numDeNotificaciones == 1)
    //                {
    //                    Notificaciones.Text = "Tiene " + numDeNotificaciones.ToString() + " Notificación";
    //                }
    //                else
    //                {
    //                    Notificaciones.Text = "Tiene " + numDeNotificaciones.ToString() + " Notificaciones";
    //                }
    //            }
    //            else
    //            {
    //                LB_campana.Visible = false;
    //                Notificaciones.Text = "No Tiene Notificaciones.";
    //            }
    //        }
    //    }
    //}
}
