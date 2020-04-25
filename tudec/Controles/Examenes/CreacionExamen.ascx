<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CreacionExamen.ascx.cs" Inherits="Controles_CreacionExamen" %>
<style type="text/css">
    .auto-style1 {
        width: 100%;
    }
</style>
<ajaxToolkit:CalendarExtender ID="cajaFecha_CalendarExtender" runat="server" BehaviorID="cajaFecha_CalendarExtender" TargetControlID="cajaFecha" />
<asp:ObjectDataSource ID="sourceTipos" runat="server" SelectMethod="GetTiposPregunta" TypeName="GestionExamen"></asp:ObjectDataSource>
            

<script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
 
 <script type="text/javascript" src="../Controles/Examenes/JS/CreacionExamen.js"></script>


<script>

    $(document).ready(function () {


        $("#botonCrear").click(function () {

            var desplegableTipo = <%=desplegableTipo.ClientID%>;
            var valor = desplegableTipo.options[desplegableTipo.selectedIndex].value;
            
            var pregunta;

            if (valor != "Tipo de pregunta") {

                if (valor == "Múltiple con única respuesta") {

                    pregunta = new PreguntaMultipleUnicaRespuesta();

                }
                else if (valor == "Múltiple con múltiple respuesta") {

                    pregunta = new PreguntaMultipleMultipleRespuesta();

                }
                else if (valor == "Abierta") {

                    pregunta = new PreguntaAbierta();

                }
                else {

                    pregunta = new PreguntaArchivo();

                }

                Examen.preguntas.push(pregunta);
            
                var contenedor = document.getElementById("contenedor");
                contenedor.append(pregunta.getPregunta());
                contenedor.append(document.createElement("br"));


            }

        });

        $('#botonEnviar').click(function () {


            var datos = "{'examen':'" + Examen.getJSON() + "'}";

            $.ajax({

                type: "POST",
                url: '../Controles/Examenes/CreacionExamenServicio.asmx/EnviarExamen',
                data: datos,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,

            });

            alert("Se ha subido el examen");
            

        })

    });
  
</script>



<center>

<table style="width:60%">
    <tr>
        <td>
            <asp:DropDownList ID="desplegableTipo" runat="server" DataSourceID="sourceTipos" DataTextField="Tipo" DataValueField="Tipo" >
            </asp:DropDownList>

            <input id="botonCrear" type="button" value="Crear" />
        
        </td>
        <td align="right">
            <asp:TextBox placeHolder="Fecha de finalización" ID="cajaFecha" runat="server"></asp:TextBox>
            <asp:DropDownList ID="desplegableHora" runat="server">
                <asp:ListItem>Hora</asp:ListItem>
            </asp:DropDownList>
            <asp:DropDownList ID="desplegableMinuto" runat="server" >
                <asp:ListItem>Minuto</asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
</table>

<br />

<div id="contenedor">



</div>


<input id="botonEnviar" type="button" style="width: 60%" value="Crear examen" />

</center>