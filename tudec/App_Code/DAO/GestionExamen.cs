﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de GestionExamen
/// </summary>
public class GestionExamen
{

    private Base db = new Base();


    public List<ERespuesta> GetRespuestas(EPregunta pregunta)
    {

        List<ERespuesta> respuestas = db.TablaRespuestas.Where(x => x.IdPregunta == pregunta.Id).OrderBy(x => x.Id).ToList();

        return respuestas;

    }

    public List<EPregunta> GetPreguntas(EExamen examen)
    {

        List<EPregunta> preguntas = db.TablaPreguntas.Where(x => x.IdExamen == examen.Id).ToList();

        return preguntas;

    }

    public List<ETiposPregunta> GetTiposPregunta()
    {

        List<ETiposPregunta> tipos = db.TablaTiposPregunta.ToList();
        ETiposPregunta tipoDefecto = new ETiposPregunta();
        tipoDefecto.Tipo = "Tipo de pregunta";

        tipos.Insert(0, tipoDefecto);

        return tipos;

    }

    public EExamen GetExamen(int id)
    {

        EExamen examen = db.TablaExamenes.Where(x => x.Id == id).First();

        return examen;

    }

    public void ResponderExamen(EExamen examen, EUsuario usuario, string respuestas)
    {

        EEjecucionExamen ejecucion = new EEjecucionExamen();
        ejecucion.NombreUsuario = usuario.NombreDeUsuario;
        ejecucion.IdExamen = examen.Id;
        ejecucion.FechaEjecucion = System.DateTime.Now;
        ejecucion.Respuestas = respuestas;

        Base.Insertar(ejecucion);

    }

    public EEjecucionExamen GetEjecucion(EExamen examen, EUsuario usuario)
    {

        EEjecucionExamen ejecucion = db.TablaEjecucionExamen.Where(x => x.IdExamen == examen.Id && x.NombreUsuario.Equals(usuario.NombreDeUsuario)).FirstOrDefault();

        return ejecucion;

    }

}