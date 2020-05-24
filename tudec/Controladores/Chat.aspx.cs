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
        emisor = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        Uri urlAnterior = Request.UrlReferrer;
        if (emisor != null)
        {
            Hyperlink_Devolver.NavigateUrl = urlAnterior == null ? "~/Vistas/Home.aspx" : urlAnterior.ToString();
            DaoUsuario gestorUsuarios = new DaoUsuario();
            curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO_PARA_CHAT];
            EUsuario creadorCurso = gestorUsuarios.GetUsuario(curso.Creador);

            if (emisor.NombreDeUsuario != creadorCurso.NombreDeUsuario)
            {
                receptor = creadorCurso;
                Table1.Rows[0].Cells[0].Width = Unit.Percentage(0);
                Table1.Rows[0].Cells[1].Width = Unit.Percentage(100);
                Table2.Rows[0].Cells[0].Width = Unit.Percentage(0);
                Table2.Rows[0].Cells[1].Width = Unit.Percentage(100);
                Table2.Rows[1].Cells[0].Width = Unit.Percentage(0);
                Table2.Rows[1].Cells[1].Width = Unit.Percentage(100);
                panelChats.ScrollBars = ScrollBars.None;
            }
            else
            {

                EUsuario usuarioChat;

                if (Session[Constantes.USUARIO_SELECCIONADO_CHAT] == null)
                {

                    usuarioChat = gestorUsuarios.GetUsuarios(curso).FirstOrDefault();

                }
                else
                {

                    usuarioChat = (EUsuario)Session[Constantes.USUARIO_SELECCIONADO_CHAT];

                }
                receptor = usuarioChat;
                panelChats.Controls.Add(GetTablaChats());
            }

            if (receptor != null)
            {
                Session[Constantes.RECEPTOR_DEL_REPORTE] = receptor.NombreDeUsuario;
                etiquetaCurso.Text = curso.Nombre;

                etiquetaNombre.Text = receptor.NombreDeUsuario;

                imagenPerfil.ImageUrl = receptor.ImagenPerfil;

                if (string.IsNullOrEmpty(imagenPerfil.ImageUrl))
                {

                    imagenPerfil.ImageUrl = Constantes.IMAGEN_DEFAULT;

                }
                panelMensajes.Controls.Add(GetTablaMensajes());
            }
            else
            {

                etiquetaCurso.Visible = false;

                etiquetaNombre.Visible = false;

                botonEnviar.Enabled = false;

                botonEnviarImagen.Enabled = false;

                temporizador.Enabled = false;

                imagenPerfil.Visible = false;

            }

            if (Session["subiendoImagen"] != null && (bool)Session["subiendoImagen"])
            {

                MostrarModal();

            }
        }
        else
        {
            Response.Redirect("~/Vistas/Home.aspx");
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

        foreach (EMensaje mensaje in mensajes)
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

            interfazMensaje.IdMensaje = mensaje.Id;

            if (mensaje.NombreDeUsuarioEmisor.Equals(emisor.NombreDeUsuario))
            {
                celdaEmisor.Controls.Add(interfazMensaje);
            }
            else
            {
                celdaReceptor.Controls.Add(interfazMensaje);
            }
            tabla.Rows.Add(fila);
        }
        return tabla;
    }

    public Table GetTablaChats()
    {
        Table tabla = new Table();
        tabla.Width = Unit.Percentage(100);
        DaoUsuario gestorUsuarios = new DaoUsuario();
        List<EUsuario> usuarios = gestorUsuarios.GetUsuarios(curso);
        foreach (EUsuario usuario in usuarios)
        {
            TableRow fila = new TableRow();
            TableCell celdaImagen = new TableCell();
            TableCell celdaBoton = new TableCell();
            ImageButton imagenUsuario = new ImageButton();
            imagenUsuario.ImageUrl = usuario.ImagenPerfil;
            imagenUsuario.CssClass = "card-img rounded-circle";
            if ( string.IsNullOrEmpty(imagenUsuario.ImageUrl))
            {
                imagenUsuario.ImageUrl = Constantes.IMAGEN_DEFAULT;
            }
            imagenUsuario.Width = Unit.Percentage(100);
            imagenUsuario.Height = 40;
            imagenUsuario.Click += new ImageClickEventHandler(CambiarDeChatPorImagen);

            LinkButton botonChat = new LinkButton();
            botonChat.Text = usuario.NombreDeUsuario;
            botonChat.Width = Unit.Percentage(100);
            botonChat.Height = 40;
            botonChat.Click += new EventHandler(CambiarDeChat);
            celdaImagen.Width = Unit.Percentage(20);
            celdaBoton.Width = Unit.Percentage(79);
            celdaImagen.Controls.Add(imagenUsuario);
            celdaBoton.Controls.Add(botonChat);

            fila.Cells.Add(celdaImagen);
            fila.Cells.Add(celdaBoton);

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

        Table tablaActual = GetTablaMensajes();
        if (Session["numeroFilas"] != null)
        {
            if (tablaActual.Rows.Count > (int)Session["numeroFilas"])
            {
                panelMensajes.Controls.Clear();
                panelMensajes.Controls.Add(GetTablaMensajes());
                ScriptManager.RegisterStartupScript(this, GetType(), "CallFunction", "bajarBarrita()", true);
                panelActualizarTabla.Update();
            }
        }
        Session["numeroFilas"] = tablaActual.Rows.Count;
    }

    public void MostrarModal()
    {
        Panel modal = GetModal();

        ASP.controles_interfazsubirimagen_interfazsubirimagen_ascx interfazImagen = new ASP.controles_interfazsubirimagen_interfazsubirimagen_ascx();

        interfazImagen.Receptor = receptor;

        modal.Controls.Add(interfazImagen);

        modal.Style.Add(HtmlTextWriterStyle.PaddingLeft, "37%");
        modal.Style.Add(HtmlTextWriterStyle.PaddingTop, "15%");

        panelModal.Controls.Add(modal);

    }

    protected void botonEnviarImagen_Click(object sender, EventArgs e)
    {
        MostrarModal();
        Session["subiendoImagen"] = true;
    }

    public void CambiarDeChat(object sender, EventArgs e)
    {
        LinkButton boton = (LinkButton)sender;
        DaoUsuario gestorUsuarios = new DaoUsuario();
        EUsuario usuario = gestorUsuarios.GetUsuario(boton.Text);
        Session[Constantes.USUARIO_SELECCIONADO_CHAT] = usuario;
        Response.Redirect("~/Vistas/Chat/Chat.aspx");
    }

    public void CambiarDeChatPorImagen(object sender, EventArgs e)
    {

        ImageButton boton = (ImageButton)sender;
        Table tablaChats = (Table)panelChats.Controls[0];
        string nombreDeUsuario = "";

        foreach (TableRow fila in tablaChats.Rows)
        {
            if (fila.Cells[0].Controls.Contains(boton))
            {
                LinkButton botonEnlace = (LinkButton)fila.Cells[1].Controls[0];
                nombreDeUsuario = botonEnlace.Text;
            }
        }

        DaoUsuario gestorUsuarios = new DaoUsuario();

        EUsuario usuario = gestorUsuarios.GetUsuario(nombreDeUsuario);

        Session[Constantes.USUARIO_SELECCIONADO_CHAT] = usuario;

        Response.Redirect("~/Vistas/Chat/Chat.aspx");

    }
}