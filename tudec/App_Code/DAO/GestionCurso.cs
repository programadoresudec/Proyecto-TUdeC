﻿using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Clase GestionCurso
/// </summary>
public class GestionCurso
{
    private Base db = new Base();
    public GestionCurso()
    {

    }

    public EInscripcionesCursos GetInscripcion(EUsuario usuario, ECurso curso)
    {
        return db.TablaInscripciones.Where(x => x.NombreUsuario.Equals(usuario.NombreDeUsuario) && x.IdCurso == curso.Id).First();
    }

    public EUsuario GetUsuario(string nombreUsuario)
    {
        return db.TablaUsuarios.Where(x => x.NombreDeUsuario.Equals(nombreUsuario)).FirstOrDefault();
    }

    public ECurso GetCurso(int id)
    {
        return db.TablaCursos.Where(x => x.Id == id).FirstOrDefault();
    }


    public List<ECurso> GetCursosCreados(EUsuario usuario, string nombre, string fechaCreacion, string area, string estado)
    {

        List<ECurso> cursos;

        if (string.IsNullOrEmpty(nombre) && string.IsNullOrEmpty(fechaCreacion) && (area == null || area.Equals("Área del conocimiento")) && (estado == null || estado.Equals("Estado")))
        {
            cursos = db.TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario)).ToList();
        }
        else
        {
            DateTime fecha = new DateTime();
            if (!string.IsNullOrEmpty(fechaCreacion))
            {
                fecha = DateTime.Parse(fechaCreacion);
            }
            else
            {
                fechaCreacion = "";
            }
            nombre = nombre == null ? "" : nombre;

            cursos = db.TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario)
                && (nombre.Equals("") || x.Nombre.Equals(nombre)) && (fechaCreacion.Equals("")
                || x.FechaCreacion.Equals(fecha)) && (area.Equals("Área del conocimiento")
                || x.Area.Equals(area)) && (estado.Equals("Estado") || x.Estado.Equals(estado))).ToList();
        }
        return cursos;

    }

    public List<ECurso> GetCursosInscritos(EUsuario usuario, string nombre, string tutor, string fechaCreacion, string area)
    {

        List<ECurso> cursos = new List<ECurso>();

        List<EInscripcionesCursos> inscripciones = db.TablaInscripciones.Where(x => x.NombreUsuario.Equals(usuario.NombreDeUsuario)).ToList();

        foreach (EInscripcionesCursos inscripcion in inscripciones)
        {
            ECurso curso = db.TablaCursos.Where(x => x.Id == inscripcion.IdCurso).FirstOrDefault();
            cursos.Add(curso);
        }
        //Filtro
        if (!(string.IsNullOrEmpty(nombre) && string.IsNullOrEmpty(fechaCreacion) && (area == null || area.Equals("Área del conocimiento"))))
        {
            DateTime fecha = new DateTime();
            if (!string.IsNullOrEmpty(fechaCreacion))
            {
                fecha = DateTime.Parse(fechaCreacion);

            }
            else
            {
                fechaCreacion = "";
            }
            nombre = nombre == null ? "" : nombre;
            tutor = tutor == null ? "" : tutor;
            cursos = cursos.Where(x => (tutor.Equals("") || x.Creador.Equals(tutor)) && (nombre.Equals("") 
            || x.Nombre.Equals(nombre)) && (fechaCreacion.Equals("") || x.FechaCreacion.Equals(fecha))
                && (area.Equals("Área del conocimiento") || x.Area.Equals(area))).ToList();
        }
        return cursos;
    }

    public List<EArea> GetAreasSrc()
    {

        List<EArea> areas = db.TablaAreas.ToList();

        EArea areaPorDefecto = new EArea();
        areaPorDefecto.Area = "Área del conocimiento";

        areas.Insert(0, areaPorDefecto);

        return areas;

    }

    public List<EEstadosCurso> GetEstadosSrc()
    {

        List<EEstadosCurso> estados = db.TablaEstados.ToList();

        EEstadosCurso estadoPorDefecto = new EEstadosCurso();
        estadoPorDefecto.Estado = "Estado";

        estados.Insert(0, estadoPorDefecto);

        return estados;

    }

    public List<string> GetCursosCreadosSrc(EUsuario usuario, string nombre)
    {

        List<ECurso> cursos = db.TablaCursos.Where(x => x.Creador.Equals(usuario.NombreDeUsuario) && x.Nombre.ToLower().Contains(nombre.ToLower())).ToList();

        List<string> nombresCursos = new List<string>();

        foreach (ECurso curso in cursos)
        {

            nombresCursos.Add(curso.Nombre);

        }

        return nombresCursos;

    }

    public List<string> GetCursosInscritosSrc(EUsuario usuario, string nombre)
    {
        List<ECurso> cursos = new List<ECurso>();
        List<string> nombresCursos = new List<string>();

        List<EInscripcionesCursos> inscripciones = db.TablaInscripciones.Where(x => x.NombreUsuario.Equals(usuario.NombreDeUsuario)).ToList();

        foreach (EInscripcionesCursos inscripcion in inscripciones)
        {

            ECurso curso = db.TablaCursos.Where(x => x.Id == inscripcion.IdCurso && x.Nombre.ToLower().Contains(nombre.ToLower())).FirstOrDefault();

            if (curso != null) cursos.Add(curso);

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

        List<EInscripcionesCursos> inscripciones = db.TablaInscripciones.Where(x => x.NombreUsuario.Equals(usuario.NombreDeUsuario)).ToList();

        foreach (EInscripcionesCursos inscripcion in inscripciones)
        {

            ECurso curso = db.TablaCursos.Where(x => x.Id == inscripcion.IdCurso).FirstOrDefault();

            cursos.Add(curso);

        }

        foreach (ECurso curso in cursos)
        {

            nombresTutores.Add(curso.Creador);

        }

        nombresTutores = nombresTutores.Distinct().ToList();

        return nombresTutores;

    }


    public bool IsInscrito(EUsuario usuario, ECurso curso)
    {

        bool retorno = true;

        EInscripcionesCursos inscripcion = db.TablaInscripciones.Where(x => x.NombreUsuario.Equals(usuario.NombreDeUsuario) && x.IdCurso == curso.Id).FirstOrDefault();

        if (inscripcion == null)
        {

            retorno = false;

        }

        return retorno;

    }

    /// <summary>
    /// Metodo que verifica si existe el codigo del curso en la base.
    /// </summary>
    /// <param name="codigo"></param>
    /// <returns></returns>
    public bool existeCodigoCurso(string codigo)
    {
        return db.TablaCursos.Any(x => x.CodigoInscripcion.Equals(codigo));
    }
}