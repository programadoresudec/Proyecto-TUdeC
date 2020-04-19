using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de GestionUsuario
/// </summary>
public class GestionUsuario
{
    private Base db = new Base();
    public GestionUsuario()
    {

    }

    public List<ECurso> GetCursos(EUsuario eUsuario){
        List<ECurso> cursos = db.TablaCursos.Where(x => x.Creador.Equals(eUsuario.nombreUsuario)).ToList();
        return cursos;
    }
}