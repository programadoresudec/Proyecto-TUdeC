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

        DaoUsuario gestorUsuarios = new DaoUsuario();
        EUsuario usuario = gestorUsuarios.GetUsuario("Frand");

        GestionExamen gestorExamenes = new GestionExamen();
        EExamen examen = gestorExamenes.GetExamen(0);

        EEjecucionExamen ejecucion = gestorExamenes.GetEjecucion(examen, usuario);

        JArray respuestas = JArray.Parse(ejecucion.Respuestas);

        List<EPregunta> preguntas = gestorExamenes.GetPreguntas(examen);

        Console.WriteLine("");

    }
}