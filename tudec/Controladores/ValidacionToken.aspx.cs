using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Account_ValidacionToken : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var token = Session[Constantes.VALIDAR_TOKEN];
        
        if (Request.QueryString.Count > 0)
        {
            if (token!= null)
            {
                if (token.Equals(Constantes.VALIDAR_TOKEN))
                {
                    LB_TextoOne.Text = "NO SE HA PODIDO VERIFICAR LA DIRECCIÓN DE CORREO ELECTRÓNICO";
                    LB_TextoTwo.Text = "Esta solicitud de verificación es demasiado antigua. Intenta crear otro.";
                }
            }
        } 
    }
}