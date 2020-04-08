using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web.UI.WebControls;

/// <summary>
/// Descripción breve de Buscador
/// </summary>
public class Buscador:Base
{
    public Buscador()
    {
        
    }

    public DbSet<EUsuario> TablaUsuarios { get; set; }
    public DbSet<EArea> TablaAreas { get; set; }
    public DbSet<ECurso> TablaCursos { get; set; }

    public List<EArea> GetAreasSrc()
    {

        List<EArea> areas = TablaAreas.ToList();

        EArea areaPorDefecto = new EArea();
        areaPorDefecto.Area = "Seleccionar";

        areas.Insert(0, areaPorDefecto);

        return areas;

    }

    public List<ECurso> GetCursos(string curso, string tutor, string area, int puntuacion)
    {

        if(tutor == null) tutor = "";

        if(curso == null) curso = "";

        List<ECurso> cursos;

        if (curso == "" && tutor == "" && area == "Seleccionar" && puntuacion == 0)
        {
            cursos = TablaCursos.ToList();

        }
        else
        {
            cursos = TablaCursos.Where(x => (curso == "" || x.Nombre.ToLower().Contains(curso.ToLower())) && (tutor == "" || x.Creador.ToLower().Contains(tutor.ToLower())) && (area.Equals("Seleccionar") || x.Area.Equals(area)) && (puntuacion == 0 || x.Puntuacion == puntuacion)).ToList();
        }

        return cursos;

    }

    public List<string> GetCursosSrc(string nombre)
    {
        
        List<ECurso> cursos = TablaCursos.Where(x => x.Nombre.ToLower().Contains(nombre.ToLower())).ToList();

        List<string> nombresCursos = new List<string>();

        foreach(ECurso curso in cursos)
        {

            nombresCursos.Add(curso.Nombre);

        }

        return nombresCursos;

    }

    public List<EUsuario> GetTutores(string tutor, int puntuacion)
    {

        int prueba = puntuacion;
  
        List<EUsuario> tutores;

        if(tutor == null) tutor = "";

        if(tutor == "" && puntuacion == 0)
        {

            tutores = TablaUsuarios.Where(x => x.Rol.Equals("usuario")).ToList();

        }
        else
        {

            tutores = TablaUsuarios.Where(x => x.Rol.Equals("usuario") && (tutor == "" || x.NombreDeUsuario.ToLower().Contains(tutor.ToLower())) && (puntuacion == 0 || x.Puntuacion == puntuacion)).ToList();

        }

        foreach (EUsuario usuario in tutores)
        {

            int numCursos = TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario)).Count();
            usuario.NumCursos = numCursos;

        }

        return tutores;

    }

    public List<string> GetTutoresSrc(string nombre)
    {

        List<EUsuario> tutores = TablaUsuarios.Where(x => x.Rol.Equals("usuario") &&  x.NombreDeUsuario.ToLower().Contains(nombre.ToLower())).ToList();

        List<string> nombresTutores = new List<string>();

        foreach (EUsuario tutor in tutores)
        {

            nombresTutores.Add(tutor.NombreDeUsuario);

        }

        return nombresTutores;

    }

    public EUsuario GetUsuario(string nombreUsuario)
    {

        EUsuario usuario = TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).FirstOrDefault();

        return usuario;
        
    }
}