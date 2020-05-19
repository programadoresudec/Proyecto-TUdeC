using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_ReportarCuenta_ReportarCuenta : System.Web.UI.UserControl
{
    EUsuario usuarioDenunciante;
    private int idComentario;
    EComentario comentarios;
    public int IdComentario { get => idComentario; set => idComentario = value; }


    protected void Page_Load(object sender, EventArgs e)
    {

        if(Session[Constantes.USUARIO_LOGEADO] != null)
        {

            usuarioDenunciante = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
            comentarios = new GestionComentarios().GetComentario(IdComentario);
            if (comentarios.Emisor.Equals(usuarioDenunciante.NombreDeUsuario))
            {
                BtnMostrarModal.Visible = false;
            }

        }

        
    }

    protected void btnCerrar_Click(object sender, EventArgs e)
    {
        ModalBloquearUsuario.Hide();
    }

    protected void btnEnviar_Click(object sender, EventArgs e)
    {

        EReporte reportes = new EReporte();
        comentarios = new GestionComentarios().GetComentario(IdComentario);
        EMensaje chat = new EMensaje();
        if (usuarioDenunciante != null && comentarios != null)
        {
            if (DDL_MotivoReporte.SelectedItem.Text.Equals("Motivo"))
            {
                LB_validar.CssClass = "alert alert-danger";
                LB_validar.Text = "Debe escoger un motivo";
                LB_validar.Visible = true;
            }
            else
            {
                reportes.NombreDeUsuarioDenunciante = usuarioDenunciante.NombreDeUsuario;
                reportes.MotivoDelReporte = DDL_MotivoReporte.SelectedItem.Text;
                reportes.IdComentario = comentarios.Id;
                reportes.ImagenesComentario = comentarios.Imagenes;
                reportes.NombreDeUsuarioDenunciado = comentarios.Emisor;
                reportes.Descripcion = TB_Descripcion.Text;
                reportes.Fecha = DateTime.Now;
                Base.Insertar(reportes);
                LB_validar.CssClass = "alert alert-success";
                LB_validar.Text = "Su reporte se ha enviado.";
                LB_validar.Visible = true;
            }
           
        }
        else if (usuarioDenunciante != null && chat != null)
        {

        }
    }
}