using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_ReportarCuenta_ReportarCuenta : System.Web.UI.UserControl
{

    #region attributes
    private int idComentario;
    private int idMensaje;
    EUsuario usuarioDenunciante;
    EComentario comentarios;
    EMensaje mensajes;
    ENotificacion notificacionDeSugerencia;
    #endregion

    #region properties
    public int IdComentario { get => idComentario; set => idComentario = value; }
    public int IdMensaje { get => idMensaje; set => idMensaje = value; }
    #endregion


    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session[Constantes.USUARIO_LOGEADO] != null)
        {
            usuarioDenunciante = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
            comentarios = new GestionComentarios().GetComentario(IdComentario);
            mensajes = new GestionMensajes().GetMensaje(IdMensaje);
            if (comentarios != null && comentarios.Emisor.Equals(usuarioDenunciante.NombreDeUsuario))
            {
                BtnMostrarModal.Visible = false;
            }
            else if (mensajes != null && mensajes.NombreDeUsuarioEmisor.Equals(usuarioDenunciante.NombreDeUsuario))
            {
                BtnMostrarModal.Visible = false;
            }
        }
    }

    protected void btnCerrar_Click(object sender, EventArgs e)
    {

        if (comentarios != null)
        {
            Response.Redirect("~/Vistas/Cursos/InformacionDelCurso.aspx");
        }
        else if (mensajes != null)
        {
            Response.Redirect("~/Vistas/Chat/Chat.aspx");
        }

    }

    protected void btnEnviar_Click(object sender, EventArgs e)
    {
        string admin = new DaoNotificacion().buscarNombreAdministrador();
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
                return;
            }
            else
            {
                reportes.NombreDeUsuarioDenunciante = usuarioDenunciante.NombreDeUsuario;
                reportes.MotivoDelReporte = DDL_MotivoReporte.SelectedItem.Text;
                reportes.IdComentario = comentarios.Id;
                reportes.NombreDeUsuarioDenunciado = comentarios.Emisor;
                reportes.Descripcion = TB_Descripcion.Text;
                reportes.Fecha = DateTime.Now;
                Base.Insertar(reportes);
                LB_validar.CssClass = "alert alert-success";
                LB_validar.Text = "Su reporte se ha enviado.";
                LB_validar.Visible = true;

                admin = new DaoNotificacion().buscarNombreAdministrador();
                notificacionDeSugerencia = new ENotificacion();
                notificacionDeSugerencia.Estado = true;
                notificacionDeSugerencia.Fecha = reportes.Fecha;
                notificacionDeSugerencia.NombreDeUsuario = admin;
                notificacionDeSugerencia.Mensaje = "Se ha reportado un usuario.";
                Base.Insertar(notificacionDeSugerencia);
                CleanControl(this.Controls);
            }

        }
        else if (mensajes!= null)
        {
            if (DDL_MotivoReporte.SelectedItem.Text.Equals("Motivo"))
            {
                LB_validar.CssClass = "alert alert-danger";
                LB_validar.Text = "Debe escoger un motivo";
                LB_validar.Visible = true;
                return;
            }
            reportes.NombreDeUsuarioDenunciante = usuarioDenunciante.NombreDeUsuario;
            reportes.MotivoDelReporte = DDL_MotivoReporte.SelectedItem.Text;
            reportes.NombreDeUsuarioDenunciado = mensajes.NombreDeUsuarioEmisor;
            reportes.Descripcion = TB_Descripcion.Text;
            reportes.IdMensaje = mensajes.Id;
            reportes.Mensaje = mensajes.Contenido;
            reportes.Fecha = DateTime.Now;
            Base.Insertar(reportes);
            LB_validar.CssClass = "alert alert-success";
            LB_validar.Text = "Su reporte se ha enviado.";
            LB_validar.Visible = true;

            admin = new DaoNotificacion().buscarNombreAdministrador();
            notificacionDeSugerencia = new ENotificacion();
            notificacionDeSugerencia.Estado = true;
            notificacionDeSugerencia.Fecha = reportes.Fecha;
            notificacionDeSugerencia.NombreDeUsuario = admin;
            notificacionDeSugerencia.Mensaje = "Se ha reportado un usuario.";
            Base.Insertar(notificacionDeSugerencia);
            CleanControl(this.Controls);
        }
    }
    public void CleanControl(ControlCollection controles)
    {
        foreach (Control control in controles)
        {
            if (control is TextBox)
                ((TextBox)control).Text = string.Empty;
            else if (control.HasControls())
                //Esta linea detécta un Control que contenga otros Controles
                //Así ningún control se quedará sin ser limpiado.
                CleanControl(control.Controls);
        }
    }
}