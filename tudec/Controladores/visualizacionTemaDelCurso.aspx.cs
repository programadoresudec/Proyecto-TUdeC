using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Vistas_Cursos_visualizacionTemaDelCurso : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        ETema tema = (ETema)Session[Constantes.TEMA_SELECCIONADO];

        etiquetaTitulo.Text = tema.Titulo;
        cajaInformacion.Text = tema.Informacion;


        GestionExamen gestorExamenes = new GestionExamen();

        EExamen examen = (EExamen)gestorExamenes.GetExamen(tema);

        Session[Constantes.EXAMEN_A_REALIZAR] = examen;


        if (examen != null)
        {

            if (gestorExamenes.GetEjecucion(examen, (EUsuario)Session[Constantes.USUARIO_LOGEADO]) != null)
            {

                Label etiquetaExamenRealizado = new Label();
                etiquetaExamenRealizado.Text = "Ya ha realizado el examen";

                panelExamen.Controls.Add(etiquetaExamenRealizado);

            }
            else
            {

                if (examen != null)
                {

                    ASP.controles_examenes_elaboracionexamen_ascx examenARealizar = new ASP.controles_examenes_elaboracionexamen_ascx();
                    panelExamen.Controls.Add(examenARealizar);

                }


            }
        }


    }
}