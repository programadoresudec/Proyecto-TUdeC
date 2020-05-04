using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json.Linq;
using System.Drawing;

public partial class Controles_CalificacionExamen : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_SELECCIONADO];

        GestionExamen gestorExamenes = new GestionExamen();

        ETema tema = (ETema)Session[Constantes.TEMA_SELECCIONADO];

        EExamen examen = gestorExamenes.GetExamen(tema);

        EEjecucionExamen ejecucion = gestorExamenes.GetEjecucion(examen, usuario);

        JArray respuestasExamenJson = JArray.Parse(ejecucion.Respuestas);

        List<EPregunta> preguntas = gestorExamenes.GetPreguntas(examen);

        int minutos = examen.FechaFin.Minute;
        string textoMinutos = minutos.ToString();
        
        if(minutos < 10)
        {

            textoMinutos = textoMinutos.Insert(0, "0");

        }

        etiquetaFecha.Text = "Fecha límite " + examen.FechaFin.Day + "/" + examen.FechaFin.Month + "/" + examen.FechaFin.Year + " a las " + examen.FechaFin.Hour + ":" + textoMinutos;


        foreach (EPregunta pregunta in preguntas)
        {

            Panel panelPregunta = new Panel();
            Table tablaPregunta = new Table();

            tablaPregunta.BackColor = Color.FromArgb(195, 201, 209);
            tablaPregunta.Width = Unit.Percentage(60);
            tablaPregunta.Style.Add("border-radius", "10px");

            if (pregunta.TipoPregunta.Equals("Múltiple con única respuesta"))
            {

                List<ERespuesta> respuestas = gestorExamenes.GetRespuestas(pregunta);

                List<Button> botonesMarcarPregunta = new List<Button>();

                TableRow filaPregunta = new TableRow();
                TableCell celdaPregunta = new TableCell();

                Label textoPregunta = new Label();
                textoPregunta.Text = pregunta.Pregunta;

                celdaPregunta.Controls.Add(textoPregunta);
                celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                filaPregunta.Cells.Add(celdaPregunta);
                tablaPregunta.Rows.Add(filaPregunta);

                int indicePregunta = preguntas.IndexOf(pregunta);
                JToken respuestaPreguntaJson = respuestasExamenJson[indicePregunta]["Respuestas"];

                int indiceRespuestaMarcada;

                if (respuestaPreguntaJson[0].ToString() == "")
                {

                    indiceRespuestaMarcada = -1;

                }
                else
                {

                    indiceRespuestaMarcada = Int32.Parse(respuestaPreguntaJson[0].ToString());

                }


                ERespuesta respuestaCorrecta = respuestas.Where(x => x.Estado == true).First();

                int indiceRespuestaCorrecta = respuestas.IndexOf(respuestaCorrecta);

                foreach (ERespuesta respuesta in respuestas)
                {

                    TableRow fila = new TableRow();
                    TableCell celda = new TableCell();
                    Button botonMarcar = new Button();
                    botonMarcar.Width = 16;
                    botonMarcar.Height = 16;

                    botonMarcar.Enabled = false;

                    System.Web.UI.WebControls.Image indicadorCorrecto = null;

                    if (respuestas.IndexOf(respuesta) == indiceRespuestaMarcada)
                    {

                        botonMarcar.BackColor = Color.Black;

                        indicadorCorrecto = new System.Web.UI.WebControls.Image();
                        indicadorCorrecto.Width = 16;
                        indicadorCorrecto.Height = 16;

                        if (indiceRespuestaCorrecta == indiceRespuestaMarcada)
                        {

                            indicadorCorrecto.ImageUrl = "https://wisdom-trek.com/wp-content/uploads/2019/05/The-Correct-Answer-1.png";

                        }
                        else
                        {

                            indicadorCorrecto.ImageUrl = "https://cdn.clipart.email/e9c7c978dd890a610ef4b53eb7e78352_download-red-cross-clipart-wrong-answer-red-cross-clipart-png-_1600-1600.png";



                        }


                    }

                    Label textoRespuesta = new Label();
                    textoRespuesta.Text = respuesta.Respuesta;
                    
                    celda.Controls.Add(botonMarcar);
                    celda.Controls.Add(textoRespuesta);
                    if(indicadorCorrecto != null)
                    {

                        celda.Controls.Add(indicadorCorrecto);

                    }

                    celda.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                    celda.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                    celda.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                    fila.Cells.Add(celda);
                    tablaPregunta.Rows.Add(fila);

                }

                TableRow filaPorcentaje = new TableRow();
                TableCell celdaPorcentaje = new TableCell();

                Label textoPorcentaje = new Label();
                textoPorcentaje.Text = "Porcentaje: " + pregunta.Porcentaje + "%";
                
                celdaPorcentaje.Controls.Add(textoPorcentaje);
                celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                filaPorcentaje.Cells.Add(celdaPorcentaje);
                tablaPregunta.Rows.Add(filaPorcentaje);

                TableRow filaNota = new TableRow();
                TableCell celdaNota = new TableCell();

                Label textoNota = new Label();

                JArray notasJson = JArray.Parse(ejecucion.Calificacion);
                JToken notaJson = notasJson[indicePregunta];

                textoNota.Text = "Nota: " + notaJson.ToString();

                celdaNota.Controls.Add(textoNota);
                celdaNota.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaNota.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaNota.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                filaNota.Cells.Add(celdaNota);
                tablaPregunta.Rows.Add(filaNota);

            }
            else if (pregunta.TipoPregunta.Equals("Múltiple con múltiple respuesta"))
            {

                //List<ERespuesta> respuestas = gestorExamenes.GetRespuestas(pregunta);
                //List<CheckBox> botonesCheckboxPregunta = new List<CheckBox>();

                //TableRow filaPregunta = new TableRow();
                //TableCell celdaPregunta = new TableCell();

                //Label textoPregunta = new Label();
                //textoPregunta.Text = pregunta.Pregunta;

                //celdaPregunta.Controls.Add(textoPregunta);
                //celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                //celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                //celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                //filaPregunta.Cells.Add(celdaPregunta);
                //tablaPregunta.Rows.Add(filaPregunta);

                //foreach (ERespuesta respuesta in respuestas)
                //{

                //    TableRow fila = new TableRow();
                //    TableCell celda = new TableCell();
                //    CheckBox checker = new CheckBox();

                //    botonesCheckboxPregunta.Add(checker);

                //    Label textoRespuesta = new Label();
                //    textoRespuesta.Text = respuesta.Respuesta;

                //    celda.Controls.Add(checker);
                //    celda.Controls.Add(textoRespuesta);
                //    celda.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                //    celda.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                //    celda.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                //    fila.Cells.Add(celda);
                //    tablaPregunta.Rows.Add(fila);

                //}

                //TableRow filaPorcentaje = new TableRow();
                //TableCell celdaPorcentaje = new TableCell();

                //Label textoPorcentaje = new Label();
                //textoPorcentaje.Text = "Porcentaje: " + pregunta.Porcentaje + "%";

                //celdaPorcentaje.Controls.Add(textoPorcentaje);
                //celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                //celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                //celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                //filaPorcentaje.Cells.Add(celdaPorcentaje);
                //tablaPregunta.Rows.Add(filaPorcentaje);

                //botonesCheckbox.Add(botonesCheckboxPregunta);

                //RespuestasPreguntas respuestasPregunta = new RespuestasPreguntas();
                //respuestasPregunta.TipoPregunta = "Múltiple con múltiple respuesta";
                //respuestasExamen.Add(respuestasPregunta);

            }
            else if (pregunta.TipoPregunta.Equals("Abierta"))
            {

                //TableRow filaPregunta = new TableRow();
                //TableCell celdaPregunta = new TableCell();

                //Label textoPregunta = new Label();
                //textoPregunta.Text = pregunta.Pregunta;

                //celdaPregunta.Controls.Add(textoPregunta);
                //celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                //celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                //celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                //filaPregunta.Cells.Add(celdaPregunta);
                //tablaPregunta.Rows.Add(filaPregunta);


                //TextBox campoRespuesta = new TextBox();
                //campoRespuesta.TextMode = TextBoxMode.MultiLine;
                //campoRespuesta.Attributes.Add("placeholder", "Respuesta");
                //campoRespuesta.Style.Add(HtmlTextWriterStyle.Width, "95%");
                //campoRespuesta.Style.Add(HtmlTextWriterStyle.Height, "100px");

                //TableRow filaCampo = new TableRow();
                //TableCell celdaCampo = new TableCell();

                //celdaCampo.Controls.Add(campoRespuesta);
                //celdaCampo.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                //celdaCampo.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                //celdaCampo.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");
                //filaCampo.Controls.Add(celdaCampo);



                //tablaPregunta.Rows.Add(filaCampo);


                //TableRow filaPorcentaje = new TableRow();
                //TableCell celdaPorcentaje = new TableCell();

                //Label textoPorcentaje = new Label();
                //textoPorcentaje.Text = "Porcentaje: " + pregunta.Porcentaje + "%";

                //celdaPorcentaje.Controls.Add(textoPorcentaje);
                //celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                //celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                //celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                //filaPorcentaje.Cells.Add(celdaPorcentaje);
                //tablaPregunta.Rows.Add(filaPorcentaje);

                //camposAbierta.Add(campoRespuesta);

                //RespuestasPreguntas respuestaPreguntaAbierta = new RespuestasPreguntas();
                //respuestaPreguntaAbierta.TipoPregunta = "Abierta";
                //respuestasExamen.Add(respuestaPreguntaAbierta);

            }
            else
            {

                //TableRow filaPregunta = new TableRow();
                //TableCell celdaPregunta = new TableCell();

                //Label textoPregunta = new Label();
                //textoPregunta.Text = pregunta.Pregunta;

                //celdaPregunta.Controls.Add(textoPregunta);
                //celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                //celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                //celdaPregunta.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                //filaPregunta.Cells.Add(celdaPregunta);
                //tablaPregunta.Rows.Add(filaPregunta);

                //TableRow filaArchivo = new TableRow();
                //TableCell celdaArchivo = new TableCell();

                //FileUpload botonArchivo = new FileUpload();

                //celdaArchivo.Controls.Add(botonArchivo);
                //celdaArchivo.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                //celdaArchivo.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                //celdaArchivo.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                //filaArchivo.Cells.Add(celdaArchivo);

                //tablaPregunta.Rows.Add(filaArchivo);

                //TableRow filaPorcentaje = new TableRow();
                //TableCell celdaPorcentaje = new TableCell();

                //Label textoPorcentaje = new Label();
                //textoPorcentaje.Text = "Porcentaje: " + pregunta.Porcentaje + "%";

                //celdaPorcentaje.Controls.Add(textoPorcentaje);
                //celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                //celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                //celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                //botonesSubirArchivo.Add(botonArchivo);

                //filaPorcentaje.Cells.Add(celdaPorcentaje);
                //tablaPregunta.Rows.Add(filaPorcentaje);



                //RespuestasPreguntas respuestaPreguntaArchivo = new RespuestasPreguntas();
                //respuestaPreguntaArchivo.TipoPregunta = "Solicitud archivo";
                //respuestasExamen.Add(respuestaPreguntaArchivo);

            }

            panelPregunta.Controls.Add(tablaPregunta);

            Literal saltoDeLinea = new Literal();
            saltoDeLinea.Text = "<br>";

            panelContenido.Controls.Add(panelPregunta);
            panelContenido.Controls.Add(saltoDeLinea);

        }

    }
}