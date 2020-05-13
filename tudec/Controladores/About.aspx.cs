using System;
using System.Collections.Generic;
using System.Web.Services;

public partial class Views_About : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            return;
        }
    }
    [WebMethod]
    public static List<string> GetNombresCursos(string prefixText)
    {
        Buscador gestorBuscador = new Buscador();
        List<string> nombres = gestorBuscador.GetCursosSrc(prefixText);
        return nombres;
    }
}