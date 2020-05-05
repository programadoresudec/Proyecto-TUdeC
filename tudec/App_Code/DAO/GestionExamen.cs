using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
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

        List<EPregunta> preguntas = db.TablaPreguntas.Where(x => x.IdExamen == examen.Id).OrderBy(x => x.Id).ToList();

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

    public EExamen GetExamen(ETema tema)
    {

        EExamen examen = db.TablaExamenes.Where(x => x.IdTema == tema.Id).FirstOrDefault();

        return examen;

    }

    public void ResponderExamen(EExamen examen, EUsuario usuario, string respuestas)
    {

        EEjecucionExamen ejecucion = new EEjecucionExamen();
        ejecucion.NombreUsuario = usuario.NombreDeUsuario;
        ejecucion.IdExamen = examen.Id;
        ejecucion.FechaEjecucion = System.DateTime.Now;
        ejecucion.Respuestas = respuestas;

        List<int> notas = new List<int>();

        List<EPregunta> preguntas = GetPreguntas(examen);


        JArray respuestasExamenJson = JArray.Parse(respuestas);

        foreach(EPregunta pregunta in preguntas)
        {

            JArray respuestasPreguntaJson = (JArray)respuestasExamenJson[preguntas.IndexOf(pregunta)]["Respuestas"];

            if (respuestasPreguntaJson.Count == 0)
            {

                notas.Add(0);

            }
            else
            {

                if (pregunta.TipoPregunta.Equals("Múltiple con única respuesta"))
                {

                    int indiceRespuesta = Int32.Parse(respuestasPreguntaJson[0].ToString());

                    List<ERespuesta> respuestasPregunta = GetRespuestas(pregunta);
                    ERespuesta respuestaCorrecta = respuestasPregunta.Where(x => x.Estado == true).First();

                    int indiceRespuestaCorrecta = respuestasPregunta.IndexOf(respuestaCorrecta);

                    if(indiceRespuesta == indiceRespuestaCorrecta)
                    {

                        notas.Add(50);

                    }
                    else
                    {

                        notas.Add(0);

                    }

                }
                else if (pregunta.TipoPregunta.Equals("Múltiple con múltiple respuesta"))
                {

                    List<int> indicesRespuestas = new List<int>();

                    foreach(JToken respuesta in respuestasPreguntaJson)
                    {

                        indicesRespuestas.Add(Int32.Parse(respuesta.ToString()));

                    }

                    List<ERespuesta> respuestasPregunta = GetRespuestas(pregunta);
                    List<ERespuesta> respuestasCorrectas = respuestasPregunta.Where(x => x.Estado == true).ToList();

                    List<int> indicesRespuestasCorrectas = new List<int>();

                    foreach(ERespuesta respuesta in respuestasCorrectas)
                    {

                        if (respuesta.Estado)
                        {

                            indicesRespuestasCorrectas.Add(respuestasCorrectas.IndexOf(respuesta));

                        }

                    }

                    List<int> subNotas = new List<int>();

                    foreach(ERespuesta respuesta in respuestasCorrectas)
                    {

                        subNotas.Add(0);

                    }


                    foreach(int indice in indicesRespuestas)
                    {

                        if (indicesRespuestasCorrectas.Contains(indice))
                        {

                            int posicionIndice = indicesRespuestasCorrectas.IndexOf(indice);

                            subNotas[posicionIndice] = 50;

                        }

                    }


                    int nota = (int)subNotas.Average();

                    notas.Add(nota);


                }
                else
                {

                    notas.Add(-1);


                }

            }


        }

        string notasJson = JsonConvert.SerializeObject(notas);

        ejecucion.Calificacion = notasJson;

        Base.Insertar(ejecucion);

    }

    public EEjecucionExamen GetEjecucion(EExamen examen, EUsuario usuario)
    {

        EEjecucionExamen ejecucion = db.TablaEjecucionExamen.Where(x => x.IdExamen == examen.Id && x.NombreUsuario.Equals(usuario.NombreDeUsuario)).FirstOrDefault();

        return ejecucion;

    }

}