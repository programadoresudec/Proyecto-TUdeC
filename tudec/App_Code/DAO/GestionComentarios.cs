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
        List<EComentario> comentarios = db.TablaComentarios.Where(x => x.IdCurso == curso.Id).OrderBy(x => x.Id).ToList();

        return comentarios;

    }

    public List<EComentario> GetComentarios(ETema tema)
    {
        List<EComentario> comentarios = db.TablaComentarios.Where(x => x.IdTema == tema.Id).OrderBy(x => x.Id).ToList();

        return comentarios;

    }

    public EComentario GetComentario(int id)
    {
        EComentario comentario = db.TablaComentarios.Where(x => x.Id == id).FirstOrDefault();

        return comentario;


    }

    public List<EComentario> GetComentarios(EComentario comentario)
    {

        List<EComentario> comentarios = db.TablaComentarios.Where(x => x.IdComentario == comentario.Id).OrderBy(x => x.Id).ToList();

        return comentarios;

    }

}