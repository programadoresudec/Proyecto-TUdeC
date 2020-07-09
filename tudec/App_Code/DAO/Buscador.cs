using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web.UI.WebControls;

/// <summary>
/// Descripción breve de Buscador
/// </summary>
public class Buscador
{
    private readonly Base db = new Base();
    public Buscador()
    {

    }
    public List<EArea> GetAreasSrc()
    {
        
        List<EArea> areas = db.TablaAreas.ToList();

        EArea areaPorDefecto = new EArea
        {
            Area = "Seleccionar"
        };
        areas.Insert(0, areaPorDefecto);
        return areas;
    }

    public List<ECurso> GetCursos(string curso, string tutor, string area, int puntuacion)
    {

        if (tutor is null) tutor = "";

        if (curso is null) curso = "";

        List<ECurso> cursos;

        if (curso == "" && tutor == "" && area == "Seleccionar" && puntuacion == 0)
        {
            cursos = db.TablaCursos.OrderBy(x => x.Id).ToList();

        }
        else
        {
            cursos = db.TablaCursos.Where(x => (curso == "" || x.Nombre.ToLower().Contains(curso.ToLower())) 
            && (tutor == "" || x.Creador.ToLower().Contains(tutor.ToLower()))
            && (area.Equals("Seleccionar") || x.Area.Equals(area))
            && (puntuacion == 0 || x.Puntuacion == puntuacion)).OrderBy(x => x.Id).ToList();
        }

        return cursos;

    }

    public List<string> GetCursosSrc(string nombre)
    {

        List<ECurso> cursos = db.TablaCursos.Where(x => x.Nombre.ToLower().Contains(nombre.ToLower())).ToList();

        List<string> nombresCursos = new List<string>();

        foreach (ECurso curso in cursos)
        {

            nombresCursos.Add(curso.Nombre);

        }

        return nombresCursos;

    }

    public List<EUsuario> GetTutores(string tutor, int puntuacion)
    {

        int prueba = puntuacion;

        List<EUsuario> tutores;

        if (tutor == null) tutor = "";

        if (tutor == "" && puntuacion == 0)
        {

            tutores = db.TablaUsuarios.Where(x => x.Rol.Equals(Constantes.ROL_USER) && x.Estado.Equals(Constantes.ESTADO_ACTIVO)).ToList();

        }
        else
        {

            tutores = db.TablaUsuarios.Where(x => x.Rol.Equals(Constantes.ROL_USER) && x.Estado.Equals(Constantes.ESTADO_ACTIVO)
            && (tutor == "" || x.NombreDeUsuario.ToLower().Contains(tutor.ToLower()))
            && (puntuacion == 0 || x.Puntuacion == puntuacion)).ToList();

        }

        foreach (EUsuario usuario in tutores)
        {

            int numCursos = db.TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario)).Count();
            usuario.NumCursos = numCursos;

        }

        return tutores;

    }

    public List<string> GetTutoresSrc(string nombre)
    {
        List<EUsuario> tutores = db.TablaUsuarios.Where(x => x.Rol.Equals(Constantes.ROL_USER) && x.Estado.Equals(Constantes.ESTADO_ACTIVO)
       && x.NombreDeUsuario.ToLower().Contains(nombre.ToLower())).ToList();
        List<string> nombresTutores = new List<string>();
        foreach (EUsuario tutor in tutores)
        {
            nombresTutores.Add(tutor.NombreDeUsuario);
        }
        return nombresTutores;
    }


    public List<string> GetUsuarios(string nombre)
    {
        List<EUsuario> usuarios = db.TablaUsuarios.Where(x => 
        x.NombreDeUsuario.ToLower().Contains(nombre.ToLower())).ToList();
        List<string> nombresUsuario = new List<string>();
        foreach (EUsuario usuario in usuarios)
        {
            nombresUsuario.Add(usuario.NombreDeUsuario);
        }
        return nombresUsuario;
    }
}