using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controles_CreacionExamen : System.Web.UI.UserControl
{

    private static Panel panelPreguntas;

    protected void Page_Load(object sender, EventArgs e)
    {

        

        if (!IsPostBack)
        {

            panelPreguntas = new Panel();

        }
        else
        {


            panelContenido.Controls.Add(panelPreguntas);

        }

        for(int hora=0; hora<24; hora++)
        {
            ListItem item = new ListItem();
            item.Text = hora.ToString();
            item.Value = hora.ToString();
            desplegableHora.Items.Add(item);

        }

        for(int minuto = 0; minuto<60; minuto++)
        {

            ListItem item = new ListItem();
            string minutoTexto = minuto.ToString();

            if(minutoTexto.Length == 1)
            {

                minutoTexto =  minutoTexto.Insert(0, "0");

            }

            item.Text = minutoTexto;
            item.Value = minutoTexto;
            desplegableMinuto.Items.Add(item);

        }

    }

    protected void botonCrear_Click(object sender, EventArgs e)
    {

        Table pregunta = GetPreguntaMultipleUnicaRespuesta();

        panelPreguntas.Controls.Add(pregunta);
        panelContenido.Controls.Add(panelPreguntas);

    }


    private Table GetPreguntaMultipleUnicaRespuesta()
    {

        Table pregunta = new Table();
        int filas = 5;

        for(int fila=0; fila<filas; fila++)
        {

            TableRow filaTabla = new TableRow();
            TableCell celdaTabla = new TableCell();
            filaTabla.Cells.Add(celdaTabla);
            pregunta.Rows.Add(filaTabla);

        }


        //Fila 1

        TextBox cajaPregunta = new TextBox();
        cajaPregunta.Text = "Test";
        Button botonInsertarRespuesta = new Button();

        botonInsertarRespuesta.Text = "Insertar respuesta";
        TableCell celda = pregunta.Rows[0].Cells[0];
        celda.Controls.Add(cajaPregunta);
        celda.Controls.Add(botonInsertarRespuesta);

        //Fila 2

        
        //Fila 3


        //Fila 4

        
        //Fila 5

        
        return pregunta;

    }

}