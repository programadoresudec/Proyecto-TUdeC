using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_InformacionDelUsuarioSeleccionado : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        EUsuario usuarioInformacion = (EUsuario)Session[Constantes.USUARIO_SELECCIONADO];
        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

        DaoUsuario gestorUsuario = new DaoUsuario();
        EPuntuacion puntuacion;

        if (usuario == null)
        {

            EstrellasPuntuacion.Visible = false;

        }
        else
        {

            puntuacion = gestorUsuario.GetPuntuacion(usuario, usuarioInformacion);
            EstrellasPuntuacion.Calificacion = puntuacion.Puntuacion;

        }

        etiquetaNombreUsuario.Text = usuarioInformacion.NombreDeUsuario;
        etiquetaNombre.Text = usuarioInformacion.PrimerNombre + " " + usuarioInformacion.SegundoNombre;
        etiquetaApellido.Text = usuarioInformacion.PrimerApellido + " " + usuarioInformacion.SegundoApellido;
        etiquetaDescripcion.Text = usuarioInformacion.Descripcion;

        
        
        
        ASP.controles_estrellas_estrellas_ascx estrellas = new ASP.controles_estrellas_estrellas_ascx();
        panelEstrellas.Style.Add("pointer-events", "none");
        

        if(usuarioInformacion.Puntuacion != null)
        {

            estrellas.Calificacion = (int)usuarioInformacion.Puntuacion;

        }
        else
        {

            estrellas.Calificacion = 0;

        }
        
        panelEstrellas.Controls.Remove(etiquetaPuntuacion);
        panelEstrellas.Controls.Add(estrellas);

    }
}