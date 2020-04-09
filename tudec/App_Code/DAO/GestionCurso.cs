using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de GestionCurso
/// </summary>
public class GestionCurso: Base
{
    public GestionCurso()
    {
      
    }

    public DbSet<ECurso> TablaCursos { get; set; }
    public DbSet<EExamen> TablaExamenes { get; set; }
    public DbSet<ETema> TablaTemas { get; set; }
    public DbSet<EUsuario> TablaUsuarios { get; set; }
    public DbSet<EArea> TablaAreas { get; set; }
    public DbSet<EEstadosCurso> TablaEstados { get; set; }
    public DbSet<EInscripcionesCursos> TablaInscripciones { get; set; }

    public EUsuario GetUsuario(string nombreUsuario)
    {

        EUsuario usuario = TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).FirstOrDefault();
        return usuario;

    }

    public List<ECurso> GetCursosCreados(EUsuario usuario, string nombre, string fechaCreacion, string area, string estado)
    {
        if (nombre == null)
        {

            nombre = "";

        }
        

        if(fechaCreacion == null)
        {

            fechaCreacion = "";

        }
;
        List<ECurso> cursos;

        if (nombre.Equals("") && fechaCreacion.Equals("") && (area == null || area.Equals("Área del conocimiento")) && (estado == null || estado.Equals("Estado")))
        {

            cursos = TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario)).ToList();

        }
        else
        {

            DateTime fecha = new DateTime();

            if(fechaCreacion != "") {

                string dia = fechaCreacion.Split('/')[1];
                string mes = fechaCreacion.Split('/')[0];
                string anio = fechaCreacion.Split('/')[2];
                fecha = new DateTime(Int32.Parse(anio), Int32.Parse(mes), Int32.Parse(dia));

            }
            
            cursos = TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario) && (nombre.Equals("") || x.Nombre.Equals(nombre)) && (fechaCreacion.Equals("") || x.FechaCreacion.Equals(fecha)) && (area.Equals("Área del conocimiento") || x.Area.Equals(area)) && (estado.Equals("Estado") || x.Estado.Equals(estado))).ToList();
        }


        return cursos;

    }

    public List<ECurso> GetCursosInscritos(EUsuario usuario, string nombre, string tutor, string fechaCreacion, string area)
    {

        List<ECurso> cursos = new List<ECurso>();

        List<EInscripcionesCursos> inscripciones = TablaInscripciones.Where(x => x.NombreUsuario.Equals(usuario.NombreDeUsuario)).ToList();

        foreach(EInscripcionesCursos inscripcion in inscripciones)
        {

            ECurso curso = TablaCursos.Where(x => x.Id == inscripcion.IdCurso).FirstOrDefault();

            cursos.Add(curso);

        }

        //Filtro

        if (nombre == null)
        {

            nombre = "";

        }

        if(tutor == null)
        {

            tutor = "";

        }

        if (fechaCreacion == null)
        {

            fechaCreacion = "";

        }

        if(!(nombre.Equals("") && fechaCreacion.Equals("") && (area == null || area.Equals("Área del conocimiento"))))
        {
            DateTime fecha = new DateTime();

            if (fechaCreacion != "")
            {

                string dia = fechaCreacion.Split('/')[1];
                string mes = fechaCreacion.Split('/')[0];
                string anio = fechaCreacion.Split('/')[2];
                fecha = new DateTime(Int32.Parse(anio), Int32.Parse(mes), Int32.Parse(dia));

            }
            cursos = cursos.Where(x => (tutor.Equals("") || x.Creador.Equals(tutor)) && (nombre.Equals("") || x.Nombre.Equals(nombre)) && (fechaCreacion.Equals("") || x.FechaCreacion.Equals(fecha)) && (area.Equals("Área del conocimiento") || x.Area.Equals(area))).ToList();
        }


        return cursos;

    }

    public List<EArea> GetAreasSrc()
    {

        List<EArea> areas =  TablaAreas.ToList();

        EArea areaPorDefecto = new EArea();
        areaPorDefecto.Area = "Área del conocimiento";

        areas.Insert(0, areaPorDefecto);

        return areas;

    }

    public List<EEstadosCurso> GetEstadosSrc()
    {

        List<EEstadosCurso> estados = TablaEstados.ToList();

        EEstadosCurso estadoPorDefecto = new EEstadosCurso();
        estadoPorDefecto.Estado = "Estado";

        estados.Insert(0, estadoPorDefecto);

        return estados;

    }

    public List<string> GetCursosCreadosSrc(EUsuario usuario, string nombre)
    {

        List<ECurso> cursos = TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario) && x.Nombre.ToLower().Contains(nombre.ToLower())).ToList();

        List<string> nombresCursos = new List<string>();

        foreach(ECurso curso in cursos)
        {

            nombresCursos.Add(curso.Nombre);

        }

        return nombresCursos;

    }

    public List<string> GetCursosInscritosSrc(EUsuario usuario, string nombre)
    {

        List<ECurso> cursos = new List<ECurso>();
        List<string> nombresCursos = new List<string>();

        List<EInscripcionesCursos> inscripciones = TablaInscripciones.Where(x => x.NombreUsuario.Equals(usuario.NombreDeUsuario)).ToList();

        foreach (EInscripcionesCursos inscripcion in inscripciones)
        {

            ECurso curso = TablaCursos.Where(x => x.Id == inscripcion.IdCurso && x.Nombre.ToLower().Contains(nombre.ToLower())).FirstOrDefault();

            if(curso != null) cursos.Add(curso);

        }

        foreach (ECurso curso in cursos)
        {

            nombresCursos.Add(curso.Nombre);

        }

        return nombresCursos;

    }

    public List<string> GetTutoresSrc(EUsuario usuario, string nombre)
    {

        List<ECurso> cursos = new List<ECurso>();
        List<string> nombresTutores = new List<string>();

        List<EInscripcionesCursos> inscripciones = TablaInscripciones.Where(x => x.NombreUsuario.Equals(usuario.NombreDeUsuario)).ToList();

        foreach (EInscripcionesCursos inscripcion in inscripciones)
        {

            ECurso curso = TablaCursos.Where(x => x.Id == inscripcion.IdCurso).FirstOrDefault();

            cursos.Add(curso);

        }

        foreach(ECurso curso in cursos)
        {

            nombresTutores.Add(curso.Creador);

        }

        nombresTutores = nombresTutores.Distinct().ToList();

        return nombresTutores;

    }

}