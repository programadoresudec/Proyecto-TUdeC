using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Account_Settings : System.Web.UI.Page
{
    private static EUsuario usuario;
    private static string descripcionCreada;

    protected void Page_Load(object sender, EventArgs e)
    {
        usuario = (EUsuario)(Session[Constantes.USUARIO_LOGEADO]);
        if (usuario != null)
        {
            descripcionCreada = TB_descripcionUsuario.Text;
            string nombreCompleto = usuario.PrimerNombre + " " + usuario.SegundoNombre + " " + usuario.PrimerApellido + " " + usuario.SegundoApellido;
            if (IsPostBack)
            {
                TabName.Value = Request.Form[TabName.UniqueID];
            }
            ImagenPerfil.ImageUrl = new DaoUsuario().buscarImagen(usuario.NombreDeUsuario);
            ImagenPerfil.DataBind();
            LbNombreUsuario.Text = usuario.NombreDeUsuario;
            TB_correoInstitucional.Text = usuario.CorreoInstitucional;
            TB_nombreUsuario.Text = usuario.NombreDeUsuario;
            TB_nombreCompleto.Text = nombreCompleto;
            TB_descripcionUsuario.Text = new DaoUsuario().buscarDescripcionUsuario(usuario.NombreDeUsuario);
        }
        else
        {
            Response.Redirect("~/Vistas/Home.aspx");
        }
    }

    protected void BtnCambiarPass_Click(object sender, EventArgs e)
    {
        if (new DaoUsuario().validarPassActual(usuario.NombreDeUsuario, passActual.Text))
        {
            new DaoUsuario().actualizarPass(usuario.NombreDeUsuario, passNueva.Text);
            LB_ValidacionPass.CssClass = "alert alert-success";
            LB_ValidacionPass.Text = "Tus cambios han sido guardadados con exito.";
            LB_ValidacionPass.Visible = true;
        }
        else
        {
            LB_ValidacionPass.CssClass = "alert alert-danger";
            LB_ValidacionPass.Text = "Su contraseña actual no coincide.";
            LB_ValidacionPass.Visible = true;
        }
    }

    protected void BtnGuardarPerfil_Click(object sender, EventArgs e)
    {
        new DaoUsuario().actualizarPerfil(usuario.NombreDeUsuario, descripcionCreada);
        LB_validarGuardado.Text = "Tus cambios han sido guardadados con exito.";
        LB_validarGuardado.Visible = true;
        TB_descripcionUsuario.Text = new DaoUsuario().buscarDescripcionUsuario(usuario.NombreDeUsuario);
    }

    protected void BtnGuardarImagen_Click(object sender, EventArgs e)
    {
        string extension = System.IO.Path.GetExtension(subirImagen.PostedFile.FileName);
        string saveLocation = Constantes.LOCATION_IMAGEN_PERFIL + usuario.NombreDeUsuario + extension;
        MemoryStream str = new MemoryStream(subirImagen.FileBytes);
        System.Drawing.Image imagenDePerfilFileUpload = System.Drawing.Image.FromStream(str);
        if (imagenDePerfilFileUpload.Width >= 200 && imagenDePerfilFileUpload.Height >= 200)
        {
            subirImagen.PostedFile.SaveAs(Server.MapPath(saveLocation));
            new DaoUsuario().actualizarImagen(usuario.NombreDeUsuario, saveLocation);
            LB_subioImagen.CssClass = "alert alert-success";
            LB_subioImagen.Text = "Tus cambios han sido guardadados con exito.";
            LB_subioImagen.Visible = true;
        }
        else
        {
            LB_subioImagen.CssClass = "alertHome alert-danger fa fa-exclamation-triangle";
            LB_subioImagen.Text = "La imagen subida es demasiado pequeña. El tamaño de imagen mínimo es 200 x200 px. Sube una imagen más grande.";
            LB_subioImagen.Visible = true;
        }
    }
}