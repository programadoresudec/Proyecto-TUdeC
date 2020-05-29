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
    private EUsuario usuario;
    private ETema tema;
    private List<DropDownList> desplegablesNotas = new List<DropDownList>();
    private EEjecucionExamen ejecucion;
    List<EPregunta> preguntas;

    protected void Page_Load(object sender, EventArgs e)
    {

        bool isCalificando = (bool)Session[Constantes.CALIFICACION_EXAMEN];


        usuario = (EUsuario)Session[Constantes.USUARIO_SELECCIONADO];

        GestionExamen gestorExamenes = new GestionExamen();

        tema = (ETema)Session[Constantes.TEMA_SELECCIONADO_PARA_CALIFICAR_EXAMEN];

        EExamen examen = gestorExamenes.GetExamen(tema);

        ejecucion = gestorExamenes.GetEjecucion(examen, usuario);

        bool isExamenCalificado = gestorExamenes.IsExamenCalificado(ejecucion);

        if (!isCalificando || isExamenCalificado)
        {

            botonCalificar.Visible = false;

        }

        JArray respuestasExamenJson = JArray.Parse(ejecucion.Respuestas);

        preguntas = gestorExamenes.GetPreguntas(examen);

        int minutos = examen.FechaFin.Minute;
        string textoMinutos = minutos.ToString();

        if (minutos < 10)
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

                            indicadorCorrecto.ImageUrl = "Correcto.png";

                        }
                        else
                        {

                            indicadorCorrecto.ImageUrl = "Incorrecto.png";



                        }


                    }

                    Label textoRespuesta = new Label();
                    textoRespuesta.Text = respuesta.Respuesta;

                    celda.Controls.Add(botonMarcar);
                    celda.Controls.Add(textoRespuesta);
                    if (indicadorCorrecto != null)
                    {

                        celda.Controls.Add(indicadorCorrecto);

                    }

                    celda.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                    celda.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                    celda.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                    fila.Cells.Add(celda);
                    tablaPregunta.Rows.Add(fila);

                }


                TableRow filaRespuestaCorrecta = new TableRow();
                TableCell celdaRespuestaCorrecta = new TableCell();

                Label textoRespuestaCorrecta = new Label();
                textoRespuestaCorrecta.Text = "Respuesta correcta: " + respuestaCorrecta.Respuesta;

                celdaRespuestaCorrecta.Controls.Add(textoRespuestaCorrecta);

                celdaRespuestaCorrecta.Controls.Add(textoRespuestaCorrecta);
                celdaRespuestaCorrecta.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaRespuestaCorrecta.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaRespuestaCorrecta.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                filaRespuestaCorrecta.Cells.Add(celdaRespuestaCorrecta);
                tablaPregunta.Rows.Add(filaRespuestaCorrecta);



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

                List<ERespuesta> respuestas = gestorExamenes.GetRespuestas(pregunta);

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
                JToken respuestasPreguntasJson = respuestasExamenJson[indicePregunta]["Respuestas"];

                List<int> indicesRespuestasMarcadas = new List<int>();

                foreach (JToken respuestaPreguntaJson in respuestasPreguntasJson)
                {

                    indicesRespuestasMarcadas.Add(Int32.Parse(respuestaPreguntaJson.ToString()));

                }

                List<ERespuesta> respuestasCorrectas = respuestas.Where(x => x.Estado == true).ToList();

                List<int> indicesRespuestasCorrectas = new List<int>();

                foreach (ERespuesta respuesta in respuestasCorrectas)
                {

                    indicesRespuestasCorrectas.Add(respuestas.IndexOf(respuesta));

                }

                foreach (ERespuesta respuesta in respuestas)
                {

                    TableRow fila = new TableRow();
                    TableCell celda = new TableCell();
                    CheckBox checkBox = new CheckBox();

                    checkBox.Enabled = false;

                    System.Web.UI.WebControls.Image indicadorCorrecto = null;

                    if (indicesRespuestasMarcadas.Contains(respuestas.IndexOf(respuesta)))
                    {

                        checkBox.Checked = true;

                        indicadorCorrecto = new System.Web.UI.WebControls.Image();
                        indicadorCorrecto.Width = 16;
                        indicadorCorrecto.Height = 16;

                        if (indicesRespuestasCorrectas.Contains(respuestas.IndexOf(respuesta)))
                        {

                            indicadorCorrecto.ImageUrl = "Correcto.png";

                        }
                        else
                        {

                            indicadorCorrecto.ImageUrl = "Incorrecto.png";



                        }


                    }

                    Label textoRespuesta = new Label();
                    textoRespuesta.Text = respuesta.Respuesta;

                    celda.Controls.Add(checkBox);
                    celda.Controls.Add(textoRespuesta);
                    if (indicadorCorrecto != null)
                    {

                        celda.Controls.Add(indicadorCorrecto);

                    }

                    celda.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                    celda.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                    celda.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                    fila.Cells.Add(celda);
                    tablaPregunta.Rows.Add(fila);

                }


                TableRow filaRespuestasCorrectas = new TableRow();
                TableCell celdaRespuestasCorrectas = new TableCell();

                Label textoRespuestasCorrectas = new Label();

                string respuestasCorrectasString = "";

                foreach (ERespuesta respuesta in respuestasCorrectas)
                {

                    respuestasCorrectasString += respuesta.Respuesta + ", ";

                }

                respuestasCorrectasString = respuestasCorrectasString.Substring(0, respuestasCorrectasString.Length - 2);

                textoRespuestasCorrectas.Text = "Respuestas correctas: " + respuestasCorrectasString;

                celdaRespuestasCorrectas.Controls.Add(textoRespuestasCorrectas);

                celdaRespuestasCorrectas.Controls.Add(textoRespuestasCorrectas);
                celdaRespuestasCorrectas.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaRespuestasCorrectas.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaRespuestasCorrectas.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                filaRespuestasCorrectas.Cells.Add(celdaRespuestasCorrectas);
                tablaPregunta.Rows.Add(filaRespuestasCorrectas);

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
            else if (pregunta.TipoPregunta.Equals("Abierta"))
            {

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


                TextBox campoRespuesta = new TextBox();
                campoRespuesta.TextMode = TextBoxMode.MultiLine;
                campoRespuesta.Style.Add(HtmlTextWriterStyle.Width, "95%");
                campoRespuesta.Style.Add(HtmlTextWriterStyle.Height, "100px");
                campoRespuesta.Enabled = false;

                JArray respuestasJsonExamen = JArray.Parse(ejecucion.Respuestas);
                JToken respuestasJsonPregunta = respuestasJsonExamen[preguntas.IndexOf(pregunta)];

                campoRespuesta.Text = respuestasJsonPregunta["Respuestas"][0].ToString();

                TableRow filaCampo = new TableRow();
                TableCell celdaCampo = new TableCell();

                celdaCampo.Controls.Add(campoRespuesta);
                celdaCampo.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaCampo.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaCampo.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");
                filaCampo.Controls.Add(celdaCampo);



                tablaPregunta.Rows.Add(filaCampo);


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

                DropDownList desplegableNota = new DropDownList();

                ListItem itemInicial = new ListItem();
                itemInicial.Value = "Nota";
                itemInicial.Text = itemInicial.Value;

                desplegableNota.Items.Add(itemInicial);

                for (int nota = 0; nota <= 50; nota++)
                {

                    ListItem item = new ListItem();
                    item.Value = nota.ToString();
                    item.Text = item.Value;

                    desplegableNota.Items.Add(item);

                }

                JArray notasJson = JArray.Parse(ejecucion.Calificacion);
                JToken notaJson = notasJson[preguntas.IndexOf(pregunta)];

                int notaPregunta = Int32.Parse(notaJson.ToString());

                Label textoNota = new Label();
                textoNota.Text = "Nota: " + notaJson.ToString();

                if (notaPregunta == -1)
                {

                    celdaNota.Controls.Add(desplegableNota);
                    desplegablesNotas.Add(desplegableNota);

                }
                else
                {

                    celdaNota.Controls.Add(textoNota);


                }

                celdaNota.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaNota.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaNota.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                filaNota.Cells.Add(celdaNota);

                if (isCalificando && !isExamenCalificado)
                {

                    tablaPregunta.Rows.Add(filaNota);

                }

            }
            else
            {

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

                TableRow filaArchivo = new TableRow();
                TableCell celdaArchivo = new TableCell();

                LinkButton hiperEnlaceArchivo = new LinkButton();

                JArray respuestasJsonExamen = JArray.Parse(ejecucion.Respuestas);
                JToken respuestasJsonPregunta = respuestasJsonExamen[preguntas.IndexOf(pregunta)];

                JArray notasJson = JArray.Parse(ejecucion.Calificacion);
                JToken notaJson = notasJson[preguntas.IndexOf(pregunta)];

                int notaPregunta = Int32.Parse(notaJson.ToString());


                if (notaPregunta == -1)
                {

                    hiperEnlaceArchivo.Text = respuestasJsonPregunta["Respuestas"][0].ToString();
                    hiperEnlaceArchivo.Click += new EventHandler(VerArchivo);

                    celdaArchivo.Controls.Add(hiperEnlaceArchivo);
                    celdaArchivo.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                    celdaArchivo.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                    celdaArchivo.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                    filaArchivo.Cells.Add(celdaArchivo);

                    tablaPregunta.Rows.Add(filaArchivo);

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

                DropDownList desplegableNota = new DropDownList();

                ListItem itemInicial = new ListItem();
                itemInicial.Value = "Nota";
                itemInicial.Text = itemInicial.Value;

                desplegableNota.Items.Add(itemInicial);

                for (int nota = 0; nota <= 50; nota++)
                {

                    ListItem item = new ListItem();
                    item.Value = nota.ToString();
                    item.Text = item.Value;

                    desplegableNota.Items.Add(item);

                }


                Label textoNota = new Label();
                textoNota.Text = "Nota: " + notaJson.ToString();

                if (notaPregunta == -1)
                {

                    celdaNota.Controls.Add(desplegableNota);
                    desplegablesNotas.Add(desplegableNota);

                }
                else
                {

                    celdaNota.Controls.Add(textoNota);


                }

                celdaNota.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaNota.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaNota.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                filaNota.Cells.Add(celdaNota);

                if (isCalificando && !isExamenCalificado)
                {

                    tablaPregunta.Rows.Add(filaNota);

                }


            }

            panelPregunta.Controls.Add(tablaPregunta);

            Literal saltoDeLinea = new Literal();
            saltoDeLinea.Text = "<br>";

            panelContenido.Controls.Add(panelPregunta);
            panelContenido.Controls.Add(saltoDeLinea);

        }

        etiquetaNota.Text = "Nota: " + GetNotaPonderada();

    }

    public void VerArchivo(object sender, EventArgs e)
    {

        LinkButton hiperEnlace = (LinkButton)sender;

        Response.Redirect(hiperEnlace.Text);

    }


    protected void botonCalificar_Click(object sender, EventArgs e)
    {

        bool notasAsignadas = true;


        foreach (DropDownList desplegable in desplegablesNotas)
        {

            if (desplegable.Text == "Nota")
            {

                notasAsignadas = false;
                break;

            }

        }

        if (notasAsignadas)
        {

            JArray notasJson = JArray.Parse(ejecucion.Calificacion);

            int contadorNota = 0;

            for (int conteo = 0; conteo < notasJson.Count; conteo++)
            {

                int nota = Int32.Parse(notasJson[conteo].ToString());

                if (nota == -1)
                {

                    notasJson[conteo] = JToken.Parse(desplegablesNotas[contadorNota].Text);
                    contadorNota++;

                }

            }


            ejecucion.Calificacion = notasJson.ToString();

            Base.Actualizar(ejecucion);

            etiquetaNota.Text = "Nota: " + GetNotaPonderada();


            string nombreCurso = new DaoNotificacion().buscarCurso(tema.IdCurso);
            ENotificacion notificacionDeMensajes = new ENotificacion();
            notificacionDeMensajes.Estado = true;
            notificacionDeMensajes.Fecha = DateTime.Now;
            notificacionDeMensajes.NombreDeUsuario = usuario.NombreDeUsuario;
            notificacionDeMensajes.Mensaje = "se ha calificado su examen. <br> Curso: <strong>"
                + nombreCurso + "</strong>" + "  Tema: <strong>" + tema.Titulo + "</strong>";
            Base.Insertar(notificacionDeMensajes);
            Response.Redirect("~/Vistas/Examen/CalificarExamen.aspx");

        }
        else
        {
            Response.Write("<script>alert('No ha calificado todas las preguntas');</script>");
        }

    }

    public int GetNotaPonderada()
    {

        JArray notasJson = JArray.Parse(ejecucion.Calificacion);

        List<int> porcentajes = new List<int>();

        foreach (EPregunta pregunta in preguntas)
        {

            porcentajes.Add(pregunta.Porcentaje);

        }

        double notaAcumulada = 0;

        foreach (JToken nota in notasJson)
        {

            double notaReemplazo = double.Parse(nota.ToString());

            if (notaReemplazo == -1)
            {

                notaReemplazo = 0;

            }

            notaAcumulada += notaReemplazo * porcentajes[notasJson.IndexOf(nota)] / 100.0;

        }

        int notaTotal = (int)notaAcumulada;

        return notaTotal;

    }



}