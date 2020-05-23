﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Hosting;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_CreacionYEdicionTema : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        ETema tema = (ETema)Session[Constantes.TEMA_SELECCIONADO];

        if (tema != null)
        {

            etiquetaCrearTema.Text = "Editar tema";
            cajaTitulo.Text = tema.Titulo;
         

        }

    }

 
    [WebMethod]
    public static void CrearTema(string titulo, string contenido, bool existeExamen)
    {

        ETema tema = new ETema();

        tema.Titulo = titulo;
        tema.Informacion = contenido;


        ECurso curso = (ECurso)HttpContext.Current.Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR_TEMAS];

        tema.IdCurso = curso.Id;
        if (!existeExamen)
        {

            Base.Insertar(tema);
            

        }
        
    }

}