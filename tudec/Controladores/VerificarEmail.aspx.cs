﻿using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Vistas_Account_VerificarEmail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void botonEnviarToken_Click(object sender, EventArgs e)
    {
        EUsuario usuarioCambioPass = new DaoLogin().buscarCorreo(campoCorreo.Text + Constantes.CORREO_INSTITUCIONAL);
        if (usuarioCambioPass != null)
        {
            usuarioCambioPass.Estado = Constantes.ESTADO_CAMBIO_PASS;
            usuarioCambioPass.Token = Reutilizables.encriptar(JsonConvert.SerializeObject(usuarioCambioPass));
            usuarioCambioPass.VencimientoToken = DateTime.Now.AddHours(8);
            usuarioCambioPass.Session = usuarioCambioPass.Session = "plataforma";
            new Correo().enviarCorreo(usuarioCambioPass.CorreoInstitucional, usuarioCambioPass.Token,
                Constantes.MENSAJE_CAMBIO_PASS, Constantes.URL_CAMBIO_PASS, usuarioCambioPass.Estado);
            Base.Actualizar(usuarioCambioPass);
            LB_Validacion.CssClass = "alert alert-success";
            LB_Validacion.Text = "Revise la bandeja de su Correo.";
            LB_Validacion.Visible = true;

        }
        else
        {
            LB_Validacion.CssClass = "alert alert-danger";
            LB_Validacion.Text = "El correo que has introducido es incorrecto.";
            LB_Validacion.Visible = true;
            return;
        }
        usuarioCambioPass = null;
    }
}