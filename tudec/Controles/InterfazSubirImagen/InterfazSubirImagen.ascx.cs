using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_InterfazSubirImagen_InterfazSubirImagen : System.Web.UI.UserControl {

    private EUsuario receptor;

    public EUsuario Receptor { get => receptor; set => receptor = value; }

    protected void Page_Load(object sender, EventArgs e)
    {



    }

    protected void botonEnviar_Click(object sender, EventArgs e)
    {

        Session["subiendoImagen"] = false;

        EUsuario emisor = (EUsuario)Session[Constantes.USUARIO_LOGEADO];
        ECurso curso = (ECurso)Session[Constantes.CURSO_SELECCIONADO_PARA_CHAT];

        EMensaje mensaje = new EMensaje();
        mensaje.NombreDeUsuarioEmisor = emisor.NombreDeUsuario;
        mensaje.NombreDeUsuarioReceptor = Receptor.NombreDeUsuario;
        mensaje.Contenido = "";
        mensaje.Fecha = DateTime.Now;
        mensaje.IdCurso = curso.Id;

        Base.Insertar(mensaje);

        //

        MemoryStream datosImagen = new MemoryStream(gestorArchivo.FileBytes);
        System.Drawing.Image imagen = System.Drawing.Image.FromStream(datosImagen);

        int anchoImagen = 0;
        int altoImagen = 0;

        if (imagen.Width > imagen.Height)
        {

            if (imagen.Width > 250)
            {
                anchoImagen = 250;
                altoImagen = 250 * imagen.Height / imagen.Width;

            }

        }
        else
        {

            if (imagen.Height > 250)
            {

                anchoImagen = 250 * imagen.Width / imagen.Height;
                altoImagen = 250;

            }
        }

        //

        mensaje.Contenido = "<img width='" + anchoImagen + "px' heigth='" + altoImagen + "px' src='" + "../../Recursos/Imagenes/Chat/" + mensaje.Id + Path.GetExtension(gestorArchivo.FileName) + "'>";

        Base.Actualizar(mensaje);

        gestorArchivo.SaveAs(Server.MapPath("~/Recursos/Imagenes/Chat/" + mensaje.Id) + Path.GetExtension(gestorArchivo.FileName));

        Response.Redirect("~/Vistas/Chat/Chat.aspx");

    }

    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {

        
        Session["subiendoImagen"] = false;

        Response.Redirect("~/Vistas/Chat/Chat.aspx");

    }
}