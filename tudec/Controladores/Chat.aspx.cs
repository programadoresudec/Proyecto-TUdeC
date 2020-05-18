using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Chat_Chat : System.Web.UI.Page
{
    private EUsuario emisor;
    private EUsuario receptor;
    private ECurso curso;

    protected void Page_Load(object sender, EventArgs e)
    {


        DaoUsuario gestorUsuarios = new DaoUsuario();

        emisor = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

        curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO];
        EUsuario creadorCurso = gestorUsuarios.GetUsuario(curso.Creador);

        if(emisor != creadorCurso)
        {

            receptor = creadorCurso;
            Table1.Rows[0].Cells[0].Width = Unit.Percentage(0);
            Table1.Rows[0].Cells[1].Width = Unit.Percentage(100);

        }


        etiquetaCurso.Text = curso.Nombre;
        etiquetaNombre.Text = receptor.NombreDeUsuario;

        panelMensajes.Controls.Add(GetTablaMensajes());

        if(Session["subiendoImagen"] != null && (bool)Session["subiendoImagen"])
        {

            MostrarModal();

        }
     

    }

    public Panel GetModal()
    {

        Panel fondoModal = new Panel();
        fondoModal.Style.Add(HtmlTextWriterStyle.ZIndex, "1030");
        fondoModal.Style.Add("background-color", "rgba(0,0,0,0.8)");

        fondoModal.Width = Unit.Percentage(100);
        fondoModal.Height = Unit.Percentage(100);
        fondoModal.Style.Add(HtmlTextWriterStyle.Position, "fixed");
        fondoModal.Style.Add(HtmlTextWriterStyle.Top, "0px");


        return fondoModal;

    }

    public Table GetTablaMensajes()
    {

        Table tabla = new Table();
        tabla.Width = Unit.Percentage(100);

        GestionMensajes gestorMensajes = new GestionMensajes();

        List<EMensaje> mensajes = gestorMensajes.GetMensajes(emisor, receptor, curso);

        foreach(EMensaje mensaje in mensajes)
        {

            TableRow fila = new TableRow();
            TableCell celdaReceptor = new TableCell();
            TableCell celdaEmisor = new TableCell();

            celdaEmisor.Style.Add(HtmlTextWriterStyle.TextAlign, "right");

            celdaReceptor.Width = Unit.Percentage(50);
            celdaEmisor.Width = Unit.Percentage(50);

            fila.Cells.Add(celdaReceptor);
            fila.Cells.Add(celdaEmisor);

            ASP.controles_chat_mensaje_ascx interfazMensaje = new ASP.controles_chat_mensaje_ascx();

            if (mensaje.NombreDeUsuarioEmisor.Equals(emisor.NombreDeUsuario))
            {
                
                interfazMensaje.Mensaje = mensaje.Contenido;
                celdaEmisor.Controls.Add(interfazMensaje);

            }
            else
            {
                interfazMensaje.Mensaje = mensaje.Contenido;
                celdaReceptor.Controls.Add(interfazMensaje);

            }

            tabla.Rows.Add(fila);

        }


        return tabla;

    }

    protected void botonEnviar_Click(object sender, EventArgs e)
    {

        EMensaje mensaje = new EMensaje();
        mensaje.NombreDeUsuarioEmisor = emisor.NombreDeUsuario;
        mensaje.NombreDeUsuarioReceptor = receptor.NombreDeUsuario;
        mensaje.Contenido = cajaMensaje.Text;
        mensaje.Fecha = DateTime.Now;
        mensaje.IdCurso = curso.Id;

        Base.Insertar(mensaje);

        Response.Redirect("~/Vistas/Chat/Chat.aspx");

    }

    protected void temporizador_Tick(object sender, EventArgs e)
    {
        
        panelMensajes.Controls.Clear();
        panelMensajes.Controls.Add(GetTablaMensajes());

        ScriptManager.RegisterStartupScript(this, GetType(), "CallFunction", "bajarBarrita()", true);

    }

    public void MostrarModal()
    {
        Panel modal = GetModal();

        ASP.controles_interfazsubirimagen_interfazsubirimagen_ascx interfazImagen = new ASP.controles_interfazsubirimagen_interfazsubirimagen_ascx();

        modal.Controls.Add(interfazImagen);

        modal.Style.Add(HtmlTextWriterStyle.PaddingLeft, "37%");
        modal.Style.Add(HtmlTextWriterStyle.PaddingTop, "15%");

        panelModal.Controls.Add(modal);

    }

    protected void botonEnviarImagen_Click(object sender, ImageClickEventArgs e)
    {

        MostrarModal();
        Session["subiendoImagen"] = true;

    }
}