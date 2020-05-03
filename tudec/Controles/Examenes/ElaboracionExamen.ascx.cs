using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

public partial class Controles_ElaboracionExamen : System.Web.UI.UserControl
{


    private GestionExamen gestorExamenes;
    private EExamen examen;
    private List<EPregunta> preguntas;

    private List<List<Button>> botonesMarcar;
    private List<List<CheckBox>> botonesCheckbox;
    private List<TextBox> camposAbierta;
    private List<FileUpload> botonesSubirArchivo;

    private List<RespuestasPreguntas> respuestasExamen;


    class RespuestasPreguntas
    {

        private string tipoPregunta;
        private List<string> respuestas;

        public string TipoPregunta { get => tipoPregunta; set => tipoPregunta = value; }
        public List<string> Respuestas { get => respuestas; set => respuestas = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        
        respuestasExamen = new List<RespuestasPreguntas>();

        botonesMarcar = new List<List<Button>>();
        botonesCheckbox = new List<List<CheckBox>>();
        camposAbierta = new List<TextBox>();
        botonesSubirArchivo = new List<FileUpload>();

        gestorExamenes = new GestionExamen();

        examen = (EExamen)Session[Constantes.EXAMEN_A_REALIZAR];

        preguntas = gestorExamenes.GetPreguntas(examen);

        foreach(EPregunta pregunta in preguntas)
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

                foreach(ERespuesta respuesta in respuestas)
                {

                    UpdatePanel zonaActualizar = new UpdatePanel();

                    TableRow fila = new TableRow();
                    TableCell celda = new TableCell();
                    Button botonMarcar = new Button();
                    botonMarcar.Width = 16;
                    botonMarcar.Height = 16;
                    botonMarcar.Click += new EventHandler(MarcarBoton);
                    botonesMarcarPregunta.Add(botonMarcar);

                    Label textoRespuesta = new Label();
                    textoRespuesta.Text = respuesta.Respuesta;


                    zonaActualizar.ContentTemplateContainer.Controls.Add(botonMarcar);
                    zonaActualizar.ContentTemplateContainer.Controls.Add(textoRespuesta);


                    celda.Controls.Add(zonaActualizar);
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

                botonesMarcar.Add(botonesMarcarPregunta);

                RespuestasPreguntas respuestaPreguntaUnica = new RespuestasPreguntas();
                respuestaPreguntaUnica.TipoPregunta = "Múltiple con única respuesta";
                respuestasExamen.Add(respuestaPreguntaUnica);

            }
            else if (pregunta.TipoPregunta.Equals("Múltiple con múltiple respuesta"))
            {

                List<ERespuesta> respuestas = gestorExamenes.GetRespuestas(pregunta);
                List<CheckBox> botonesCheckboxPregunta = new List<CheckBox>();

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

                foreach (ERespuesta respuesta in respuestas)
                {

                    TableRow fila = new TableRow();
                    TableCell celda = new TableCell();
                    CheckBox checker = new CheckBox();

                    botonesCheckboxPregunta.Add(checker);
                   
                    Label textoRespuesta = new Label();
                    textoRespuesta.Text = respuesta.Respuesta;

                    celda.Controls.Add(checker);
                    celda.Controls.Add(textoRespuesta);
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

                botonesCheckbox.Add(botonesCheckboxPregunta);

                RespuestasPreguntas respuestasPregunta = new RespuestasPreguntas();
                respuestasPregunta.TipoPregunta = "Múltiple con múltiple respuesta";
                respuestasExamen.Add(respuestasPregunta);

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
                campoRespuesta.Attributes.Add("placeholder", "Respuesta");
                campoRespuesta.Style.Add(HtmlTextWriterStyle.Width, "95%");
                campoRespuesta.Style.Add(HtmlTextWriterStyle.Height, "100px");

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

                camposAbierta.Add(campoRespuesta);

                RespuestasPreguntas respuestaPreguntaAbierta = new RespuestasPreguntas();
                respuestaPreguntaAbierta.TipoPregunta = "Abierta";
                respuestasExamen.Add(respuestaPreguntaAbierta);

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

                FileUpload botonArchivo = new FileUpload();

                celdaArchivo.Controls.Add(botonArchivo);
                celdaArchivo.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaArchivo.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaArchivo.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                filaArchivo.Cells.Add(celdaArchivo);

                tablaPregunta.Rows.Add(filaArchivo);

                TableRow filaPorcentaje = new TableRow();
                TableCell celdaPorcentaje = new TableCell();

                Label textoPorcentaje = new Label();
                textoPorcentaje.Text = "Porcentaje: " + pregunta.Porcentaje + "%";

                celdaPorcentaje.Controls.Add(textoPorcentaje);
                celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingLeft, "3%");
                celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingTop, "1%");
                celdaPorcentaje.Style.Add(HtmlTextWriterStyle.PaddingBottom, "1%");

                botonesSubirArchivo.Add(botonArchivo);

                filaPorcentaje.Cells.Add(celdaPorcentaje);
                tablaPregunta.Rows.Add(filaPorcentaje);

                

                RespuestasPreguntas respuestaPreguntaArchivo = new RespuestasPreguntas();
                respuestaPreguntaArchivo.TipoPregunta = "Solicitud archivo";
                respuestasExamen.Add(respuestaPreguntaArchivo);

            }

            panelPregunta.Controls.Add(tablaPregunta);

            Literal saltoDeLinea = new Literal();
            saltoDeLinea.Text = "<br>";

            panelContenido.Controls.Add(panelPregunta);
            panelContenido.Controls.Add(saltoDeLinea);

        }


    }

    public void MarcarBoton(object sender, EventArgs e)
    {

        Button botonMarcar = (Button)sender;
        List<Button> botonesMarcarPregunta = null;
        
        foreach(List<Button> lista in botonesMarcar)
        {

            if (lista.Contains(botonMarcar)){

                botonesMarcarPregunta = lista;
                break;

            }

        }

        foreach(Button boton in botonesMarcarPregunta)
        {

            if(boton == botonMarcar)
            {

                boton.BackColor = Color.Black;

            }
            else
            {

                boton.BackColor = Color.White;

            }

        }


    }


    protected void botonResponder_Click(object sender, EventArgs e)
    {


        foreach(EPregunta pregunta in preguntas)
        {

            if(pregunta.TipoPregunta.Equals("Múltiple con única respuesta"))
            {

                List<EPregunta> preguntasUnicas = preguntas.Where(x => x.TipoPregunta.Equals("Múltiple con única respuesta")).ToList();

                int indicePregunta = preguntasUnicas.IndexOf(pregunta);

                List<Button> botonesMarcarPregunta = botonesMarcar[indicePregunta];

                int indiceRespuesta = -1;

                foreach(Button botonMarcar in botonesMarcarPregunta)
                {

                    if(botonMarcar.BackColor == Color.Black)
                    {

                        indiceRespuesta = botonesMarcarPregunta.IndexOf(botonMarcar);
                        break;

                    }

                }

                int indicePreguntaEnExamen = preguntas.IndexOf(pregunta);

                respuestasExamen[indicePreguntaEnExamen].Respuestas = new List<string>();
                respuestasExamen[indicePreguntaEnExamen].Respuestas.Add(indiceRespuesta.ToString());

            }
            else if(pregunta.TipoPregunta.Equals("Múltiple con múltiple respuesta"))
            {

                List<EPregunta> preguntasMultiples = preguntas.Where(x => x.TipoPregunta.Equals("Múltiple con múltiple respuesta")).ToList();

                int indicePregunta = preguntasMultiples.IndexOf(pregunta);

                List<CheckBox> botonesCheckboxPregunta = botonesCheckbox[indicePregunta];

                List<int> indicesRespuestas = new List<int>();


                foreach (CheckBox checker in botonesCheckboxPregunta)
                {

                    if (checker.Checked)
                    {

                        int indicesito = botonesCheckboxPregunta.IndexOf(checker);
                        indicesRespuestas.Add(botonesCheckboxPregunta.IndexOf(checker));

                    }

                }

                int indicePreguntaEnExamen = preguntas.IndexOf(pregunta);

                respuestasExamen[indicePreguntaEnExamen].Respuestas = new List<string>();

                foreach(int indice in indicesRespuestas)
                {

                    respuestasExamen[indicePreguntaEnExamen].Respuestas.Add(indice.ToString());

                }

            }
            else if(pregunta.TipoPregunta.Equals("Abierta"))
            {

                List<EPregunta> preguntasAbiertas = preguntas.Where(x => x.TipoPregunta.Equals("Abierta")).ToList();

                int indicePregunta = preguntasAbiertas.IndexOf(pregunta);

                string respuesta = camposAbierta[indicePregunta].Text;

                int indicePreguntaEnExamen = preguntas.IndexOf(pregunta);

                respuestasExamen[indicePreguntaEnExamen].Respuestas = new List<string>();
                respuestasExamen[indicePreguntaEnExamen].Respuestas.Add(respuesta);

            }
            else
            {

                List<EPregunta> preguntasArchivos = preguntas.Where(x => x.TipoPregunta.Equals("Solicitud archivo")).ToList();

                int indicePregunta = preguntasArchivos.IndexOf(pregunta);

                string respuesta = botonesSubirArchivo[indicePregunta].FileName;

                int indicePreguntaEnExamen = preguntas.IndexOf(pregunta);

                respuestasExamen[indicePreguntaEnExamen].Respuestas = new List<string>();
                respuestasExamen[indicePreguntaEnExamen].Respuestas.Add(respuesta);


            }
            


        }


        string respuestasExamenJson = JsonConvert.SerializeObject(respuestasExamen);


        //EUsuario usuario = (EUsuario)Session[Constantes.USUARIO_LOGEADO];

        DaoUsuario gestorUsuarios = new DaoUsuario();

        EUsuario usuario = gestorUsuarios.GetUsuario("Frand");

        gestorExamenes.ResponderExamen(examen, usuario, respuestasExamenJson);


    }
}