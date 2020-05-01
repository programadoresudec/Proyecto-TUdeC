using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de GestionTemas
/// </summary>
public class GestionTemas
{

    private Base db = new Base();

    public GestionTemas()
    {
       
    }

    public List<ETema> GetTemas(ECurso curso)
    {

        List<ETema> temas = db.TablaTemas.Where(x => x.IdCurso == curso.Id).ToList();

        return temas;

    }

    public ETema GetTema(int id)
    {

        ETema tema = db.TablaTemas.Where(x => x.Id == id).FirstOrDefault();

        return tema;

    }

}