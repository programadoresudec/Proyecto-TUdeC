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
            ModalBloquearUsuario.Hide();
            Response.Redirect("~/Vistas/Cursos/InformacionDelCurso.aspx");
        }
        else if (mensajes != null)
        {
            ModalBloquearUsuario.Hide();
            Response.Redirect("~/Vistas/Chat/Chat.aspx");
        }

    }

    protected void btnEnviar_Click(object sender, EventArgs e)
    {
        ClientScriptManager cs = Page.ClientScript;
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
                agregarReporte("comentarios");
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert();", true);
            }

        }
        else if (mensajes != null)
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
                agregarReporte("mensajes");
                ModalBloquearUsuario.Hide();
                Response.Redirect("~/Vistas/Chat/Chat.aspx");
                cs.RegisterStartupScript(this.GetType(), "mensaje", "<script> swal('Reporte Enviado!', 'Se realizo proceso con exito!', 'success') </script>");
            }
        }
    }
    protected void agregarReporte(string tipoDeReporte)
    {
        EReporte reportes = new EReporte();
        comentarios = new GestionComentarios().GetComentario(IdComentario);
        if (tipoDeReporte.Equals("comentarios"))
        {
            reportes.NombreDeUsuarioDenunciante = usuarioDenunciante.NombreDeUsuario;
            reportes.MotivoDelReporte = DDL_MotivoReporte.SelectedItem.Text;
            reportes.IdComentario = comentarios.Id;
            reportes.NombreDeUsuarioDenunciado = comentarios.Emisor;
            reportes.Descripcion = TB_Descripcion.Text;
            reportes.Fecha = DateTime.Now;
            Base.Insertar(reportes);
            agregarNotificacion(reportes.Fecha, reportes.NombreDeUsuarioDenunciado);
        }
        else if (tipoDeReporte.Equals("mensajes"))
        {
            reportes.NombreDeUsuarioDenunciante = usuarioDenunciante.NombreDeUsuario;
            reportes.MotivoDelReporte = DDL_MotivoReporte.SelectedItem.Text;
            reportes.NombreDeUsuarioDenunciado = mensajes.NombreDeUsuarioEmisor;
            reportes.Descripcion = TB_Descripcion.Text;
            reportes.IdMensaje = mensajes.Id;
            reportes.Mensaje = mensajes.Contenido;
            reportes.Fecha = DateTime.Now;
            Base.Insertar(reportes);
            agregarNotificacion(reportes.Fecha, reportes.NombreDeUsuarioDenunciado);
        }
        else
        {
            return;
        }

    }

    protected void agregarNotificacion(DateTime fecha, string nombreDeUsuarioDenunciado)
    {
        string admin = new DaoNotificacion().buscarNombreAdministrador();
        notificacionDeSugerencia = new ENotificacion();
        notificacionDeSugerencia.Estado = true;
        notificacionDeSugerencia.Fecha = fecha;
        notificacionDeSugerencia.NombreDeUsuario = admin;
        notificacionDeSugerencia.Mensaje = "Se ha reportado el usuario <strong>" + nombreDeUsuarioDenunciado + "<strong>";
        Base.Insertar(notificacionDeSugerencia);
    }

    protected void BtnMostrarModal_Click(object sender, EventArgs e)
    {
        ModalBloquearUsuario.Show();
    }
}