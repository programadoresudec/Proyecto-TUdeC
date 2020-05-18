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

    public List<ETema> GetTemasExamenResueltos(EUsuario usuario, ECurso curso)
    {

        List<ETema> temasConExamen = GetTemasConExamen(curso);

        List<ETema> temas = new List<ETema>();

        foreach(ETema tema in temasConExamen)
        {
            GestionExamen gestorExamenes = new GestionExamen();

            EExamen examen = gestorExamenes.GetExamen(tema);

            EEjecucionExamen ejecucion = db.TablaEjecucionExamen.Where(x => x.IdExamen == examen.Id && x.NombreUsuario.Equals(usuario.NombreDeUsuario)).FirstOrDefault();

            if(ejecucion != null)
            {

                temas.Add(tema);

            }

        }

        return temas;

    }

    public List<ETema> GetTemas(ECurso curso)
    {

        List<ETema> temas = db.TablaTemas.Where(x => x.IdCurso == curso.Id).OrderBy(x => x.Id).ToList();

        return temas;

    }

    public List<ETema> GetTemasConExamen(ECurso curso)
    {

        List<ETema> temas = db.TablaTemas.Where(x => x.IdCurso == curso.Id).OrderBy(x => x.Id).ToList();

        List<ETema> temasConExamen = new List<ETema>();

        foreach(ETema tema in temas)
        {

            EExamen examen = db.TablaExamenes.Where(x => x.IdTema == tema.Id).FirstOrDefault();

            if(examen != null)
            {

                temasConExamen.Add(tema);

            }

        }

        return temasConExamen;

    }

    public ETema GetTema(int id)
    {

        ETema tema = db.TablaTemas.Where(x => x.Id == id).FirstOrDefault();

        return tema;

    }

}