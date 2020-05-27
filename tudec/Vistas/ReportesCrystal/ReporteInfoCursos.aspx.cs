using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_ReportesCrystal_ReporteInfoCursos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        sourceReporte.ReportDocument.SetDataSource(informacionReporte());
        viewerReporte.ReportSource = sourceReporte;

    }


    protected DataSet informacionReporte()
    {

        DataSet esquema = new DataSet();
        GestionCurso gestorCursos = new GestionCurso();
        List<ECurso> cursos = gestorCursos.GetCursos();

        DataTable tablaCursos = esquema.Cursos;
        DataRow fila;



        foreach (ECurso curso in cursos)
        {

           fila = tablaCursos.NewRow();

            fila["nombre"] = curso.Nombre;
            fila["area"] = File.ReadAllBytes(Server.MapPath("~/Recursos/Imagenes/IconosAreas/" + curso.Area  + ".jpg"));
            fila["fechaCreacion"] = curso.FechaCreacion;
            fila["fechaInicio"] = curso.FechaInicio;
            fila["puntuacion"] = File.ReadAllBytes(Server.MapPath("~/Recursos/Imagenes/Estrellas/Estrellas" + curso.Puntuacion + ".jpg"));
            fila["nEstudiantes"] = gestorCursos.GetNumEstudiantes(curso);
          
            tablaCursos.Rows.Add(fila);

        }

        return esquema;

    }

}