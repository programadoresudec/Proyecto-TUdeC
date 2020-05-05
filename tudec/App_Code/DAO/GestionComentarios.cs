using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de GestionComentarios
/// </summary>
public class GestionComentarios
{

    private Base db = new Base();

    public GestionComentarios()
    {
       
    }

    public List<EComentario> GetComentarios(ECurso curso)
    {
        List<EComentario> comentarios = db.TablaComentarios.Where(x => x.IdCurso == curso.Id).ToList();

        return comentarios;

    }

    public List<EComentario> GetComentarios(ETema tema)
    {
        List<EComentario> comentarios = db.TablaComentarios.Where(x => x.IdTema == tema.Id).ToList();

        return comentarios;

    }

}