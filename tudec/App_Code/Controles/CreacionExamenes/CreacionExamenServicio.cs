using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Descripción breve de WebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente. 
// [System.Web.Script.Services.ScriptService]

[System.Web.Script.Services.ScriptService]
public class CreacionExamenServicio : System.Web.Services.WebService
{

    public CreacionExamenServicio()
    {

        //Elimine la marca de comentario de la línea siguiente si utiliza los componentes diseñados 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void EnviarExamen(string examen, string fecha, string hora, string minuto, string tituloTema, string contenidoTema, int idCurso)
    {

        ETema tema = new ETema();

        tema.IdCurso = idCurso;
        tema.Titulo = tituloTema;
        tema.Informacion = contenidoTema;

        Base.Insertar(tema);

        EExamen examenCreado = new EExamen();
        examenCreado.IdTema = tema.Id;

        int dia = Int32.Parse(fecha.Split('/')[0]);
        int mes = Int32.Parse(fecha.Split('/')[1]);
        int anio = Int32.Parse(fecha.Split('/')[2]);

        DateTime fechaFinalizacion = new DateTime(anio, mes, dia, Int32.Parse(hora), Int32.Parse(minuto), 0);

        examenCreado.FechaFin = fechaFinalizacion;

        Base.Insertar(examenCreado);

        JArray preguntasJson = JArray.Parse(examen);
        foreach(JToken preguntaJson in preguntasJson)
        {

            EPregunta pregunta = new EPregunta();
            pregunta.IdExamen = examenCreado.Id;
            pregunta.TipoPregunta = preguntaJson["tipoPregunta"].ToString();
            pregunta.Pregunta = preguntaJson["pregunta"].ToString();
            pregunta.Porcentaje = Int32.Parse(preguntaJson["porcentaje"].ToString());

            Base.Insertar(pregunta);

            if (pregunta.TipoPregunta.Equals("Múltiple con única respuesta"))
            {

                List<JToken> respuestasJson = preguntaJson["respuestas"].ToList();
                int indiceRespuestaCorrecta = Int32.Parse(preguntaJson["respuestaMarcada"].ToString());

                foreach(JToken respuestaJson in respuestasJson)
                {

                    ERespuesta respuesta = new ERespuesta();
                    respuesta.IdPregunta = pregunta.Id;
                    respuesta.Respuesta = respuestaJson.ToString();

                    if(respuestasJson.IndexOf(respuestaJson) == indiceRespuestaCorrecta)
                    {

                        respuesta.Estado = true;

                    }
                    else
                    {

                        respuesta.Estado = false;

                    }

                    Base.Insertar(respuesta);

                }


            }

            if (pregunta.TipoPregunta.Equals("Múltiple con múltiple respuesta"))
            {

                List<JToken> respuestasJson = preguntaJson["respuestas"].ToList();
                List<JToken> indicesRespuestasMarcadasJson = preguntaJson["respuestasMarcadas"].ToList();
                List<int> indicesRespuestasMarcadas = new List<int>();

                foreach(JToken indiceRespuestaMarcadaJson in indicesRespuestasMarcadasJson)
                {
                    indicesRespuestasMarcadas.Add(Int32.Parse(indiceRespuestaMarcadaJson.ToString()));
                }

                foreach (JToken respuestaJson in respuestasJson)
                {

                    ERespuesta respuesta = new ERespuesta();
                    respuesta.IdPregunta = pregunta.Id;
                    respuesta.Respuesta = respuestaJson.ToString();

                    if (indicesRespuestasMarcadas.Contains(respuestasJson.IndexOf(respuestaJson)))
                    {
                        respuesta.Estado = true;
                    }
                    else
                    {
                        respuesta.Estado = false;
                    }

                    Base.Insertar(respuesta);

                }


            }

        }

    }

 
}
