using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_ElaboracionExamen : System.Web.UI.UserControl
{

    private List<List<Button>> botonesMarcar;

    protected void Page_Load(object sender, EventArgs e)
    {

        botonesMarcar = new List<List<Button>>();

        GestionExamen gestorExamenes = new GestionExamen();

        EExamen examen = gestorExamenes.GetExamen(0);

        List<EPregunta> preguntas = gestorExamenes.GetPreguntas(examen);

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

                foreach (ERespuesta respuesta in respuestas)
                {

                    TableRow fila = new TableRow();
                    TableCell celda = new TableCell();
                    CheckBox checker = new CheckBox();

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

                filaPorcentaje.Cells.Add(celdaPorcentaje);
                tablaPregunta.Rows.Add(filaPorcentaje);

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

}