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

    public List<ECurso> GetCursosCreados(EUsuario usuario, string nombre, DateTime fechaCreacion, string area, string estado)
    {
        if (nombre == null)
        {

            nombre = "";

        }

        string fecha = "";

        if(fechaCreacion.Year > 1)
        {

            fecha = fechaCreacion.ToString();

        }
;
        List<ECurso> cursos;

        if (nombre.Equals("") && fecha.Equals("") && (area == null || area.Equals("Área del conocimiento")) && (estado == null || estado.Equals("Estado")))
        {

            cursos = TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario)).ToList();

        }
        else
        {
            cursos = TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario) && (nombre.Equals("") || x.Nombre.Equals(nombre)) && (fecha.Equals("") || x.FechaCreacion.ToString().Equals(fecha)) && (area.Equals("Área del conocimiento") || x.Area.Equals(area)) && (estado.Equals("Estado") || x.Estado.Equals(estado))).ToList();
        }


        return cursos;

    }

    public List<ECurso> GetCursosInscritos(EUsuario usuario, string nombre, string tutor, DateTime fechaCreacion, string area)
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

        string fecha = "";

        if (fechaCreacion.Year > 1)
        {

            fecha = fechaCreacion.ToString();

        }

        if(!(nombre.Equals("") && fecha.Equals("") && (area == null || area.Equals("Área del conocimiento"))))
        {
            cursos = cursos.Where(x => (tutor.Equals("") || x.Creador.Equals(tutor)) && (nombre.Equals("") || x.Nombre.Equals(nombre)) && (fecha.Equals("") || x.FechaCreacion.ToString().Equals(fecha)) && (area.Equals("Área del conocimiento") || x.Area.Equals(area))).ToList();
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


}