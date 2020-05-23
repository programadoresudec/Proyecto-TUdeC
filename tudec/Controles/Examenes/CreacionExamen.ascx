<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CreacionExamen.ascx.cs" Inherits="Controles_CreacionExamen" %>
<ajaxToolkit:CalendarExtender ID="cajaFecha_CalendarExtender" runat="server" BehaviorID="cajaFecha_CalendarExtender" Format="dd/MM/yyyy" TargetControlID="cajaFecha" />
<asp:ObjectDataSource ID="sourceTipos" runat="server" SelectMethod="GetTiposPregunta" TypeName="GestionExamen"></asp:ObjectDataSource>
            
 
 <script type="text/javascript" src="../../Controles/Examenes/JS/CreacionExamen.js"></script>


<script>


    function enviarExamen(tituloTema, contenidoTema, idCurso) {

        var fecha = <%=cajaFecha.ClientID%>;
        var hora = <%=desplegableHora.ClientID%>;
        var minuto = <%=desplegableMinuto.ClientID%>;


        if (Examen.camposVacios() == false && fecha.value != "" && hora.value != "Hora" && minuto.value != "Minuto") {

            if (Examen.preguntas.length == 0) {

                alert("No hay preguntas en el examen");

            } else {

                if (Examen.porcentajeCompleto() == false) {

                    alert("La suma de los porcentajes no da 100%");

                }
                else {

                    var datos = "{'examen':'" + Examen.getJSON() + "','fecha':'" + fecha.value + "','hora':'" + hora.value + "','minuto':'" + minuto.value + "','tituloTema':'" + tituloTema + "','contenidoTema':'" + contenidoTema + "','idCurso':'"  + idCurso +  "'} ";

                    $.ajax({

                        type: "POST",
                        url: '../../Controles/Examenes/CreacionExamenServicio.asmx/EnviarExamen',
                        data: datos,

                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,

                    });

                    alert("Se ha creado el tema");
                    window.location.href = "ListaDeTemasDelCurso.aspx"

                }

            }

        } else {

            alert("Hay campos sin llenar");

        }

    }

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
            <asp:TextBox placeHolder="Fecha de finalización" ID="cajaFecha" runat="server" ReadOnly="true"></asp:TextBox>
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


&nbsp;</center>