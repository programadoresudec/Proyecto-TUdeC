using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_ReportarCuenta_ReportarCuenta : System.Web.UI.UserControl
{

    private int idComentario;

    public int IdComentario { get => idComentario; set => idComentario = value; }


    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnCerrar_Click(object sender, EventArgs e)
    {
        ModalBloquearUsuario.Hide();
    }

    protected void btnEnviar_Click(object sender, EventArgs e)
    {
        
    }

    protected void BtnMostrarModal_Click(object sender, EventArgs e)
    {
        ModalBloquearUsuario.Show();
    }
}