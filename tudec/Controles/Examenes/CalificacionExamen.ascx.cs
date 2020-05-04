using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json.Linq;

public partial class Controles_CalificacionExamen : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_SELECCIONADO];

        GestionExamen gestorExamenes = new GestionExamen();

        ETema tema = (ETema)Session[Constantes.TEMA_SELECCIONADO];

        EExamen examen = gestorExamenes.GetExamen(tema);

        EEjecucionExamen ejecucion = gestorExamenes.GetEjecucion(examen, usuario);

        JArray respuestas = JArray.Parse(ejecucion.Respuestas);

        List<EPregunta> preguntas = gestorExamenes.GetPreguntas(examen);


    }
}