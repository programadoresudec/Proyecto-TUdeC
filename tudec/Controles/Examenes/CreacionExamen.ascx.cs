using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_CreacionExamen : System.Web.UI.UserControl
{


    protected void Page_Load(object sender, EventArgs e)
    {
        cajaFecha_CalendarExtender.StartDate = DateTime.Now;
        for (int hora=0; hora<24; hora++)
        {
            ListItem item = new ListItem();
            item.Text = hora.ToString();
            item.Value = hora.ToString();
            desplegableHora.Items.Add(item);

        }

        for(int minuto = 0; minuto<60; minuto++)
        {

            ListItem item = new ListItem();
            string minutoTexto = minuto.ToString();

            if(minutoTexto.Length == 1)
            {

                minutoTexto =  minutoTexto.Insert(0, "0");

            }

            item.Text = minutoTexto;
            item.Value = minutoTexto;
            desplegableMinuto.Items.Add(item);

        }

    }



}