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

        if (usuario == null || usuario.NombreDeUsuario.Equals(usuarioInformacion.NombreDeUsuario))
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
        imagenUsuario.ImageUrl = new DaoUsuario().buscarImagen(usuarioInformacion.NombreDeUsuario);
        imagenUsuario.DataBind();
     
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


    protected void GridViewUsuSelec_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        GridViewRow fila = e.Row;


        if (fila.Cells.Count > 1)
        {

            TableCell celdaArea = fila.Cells[0];
            TableCell celdaPuntuacion = fila.Cells[4];

            if (fila.RowIndex > -1)
            {

                string nombreArea = celdaArea.Text;

                Buscador buscador = new Buscador();

                EArea area = buscador.GetAreasSrc().Where(x => x.Area == nombreArea).FirstOrDefault();

                Image iconoArea = new Image();
                iconoArea.Width = 32;
                iconoArea.Height = 32;

                ASP.controles_estrellas_estrellas_ascx estrellas = new ASP.controles_estrellas_estrellas_ascx();

                estrellas.Calificacion = Int32.Parse(celdaPuntuacion.Text);

                iconoArea.ImageUrl = area.Icono;

                celdaPuntuacion.Enabled = false;

                celdaArea.Controls.Add(iconoArea);
                celdaPuntuacion.Controls.Add(estrellas);

            }

        }

    }
}