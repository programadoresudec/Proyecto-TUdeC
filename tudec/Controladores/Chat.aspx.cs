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

    protected void Page_Load(object sender, EventArgs e)
    {


        DaoUsuario gestorUsuarios = new DaoUsuario();

        emisor = gestorUsuarios.GetUsuario("Frand");
        receptor = gestorUsuarios.GetUsuario("Miguel500");

        etiquetaNombre.Text = receptor.NombreDeUsuario;

        panelMensajes.Controls.Add(GetTablaMensajes());

        

    }

    public Table GetTablaMensajes()
    {

        Table tabla = new Table();
        tabla.Width = Unit.Percentage(100);

        GestionMensajes gestorMensajes = new GestionMensajes();

        List<EMensaje> mensajes = gestorMensajes.GetMensajes(emisor, receptor);

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

        Base.Insertar(mensaje);

        Response.Redirect("~/Vistas/Chat/Chat.aspx");

    }
}