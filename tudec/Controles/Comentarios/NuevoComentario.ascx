<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NuevoComentario.ascx.cs" Inherits="Controles_Comentarios_NuevoComentario" %>
<script>

        function enviarComentario(boton) {
            var paginaContenedora = "<%=Page.GetType().ToString()%>";
            var caja = <%=cajaComentarios.ClientID%>;

            
            var botones = document.getElementsByClassName("botones");
            botones = Array.from(botones);
            var indiceBoton = botones.indexOf(boton);

            var contenidoCaja;

            var idComentario;

            if (botones.length > 1 && indiceBoton == 0) {

                var cajas = document.getElementsByClassName("cajas");
                contenidoCaja = cajas[0].value;
        
                idComentario = 0;


            } else {


                contenidoCaja = caja.value;
                idComentario = <%=Session["idComentario"]%>

            }


            var datos = "{'paginaContenedora':'" + paginaContenedora + "','contenidoCaja':'" + contenidoCaja + "','idComentarioString':'" + idComentario + "" + "'}";

            $.ajax({

                type: "POST",
                url: '../../Controles/Comentarios/ComentariosService.asmx/SubirComentario',
                data: datos,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,

            });

            <% cajaComentarios.Text = "";%>;
            location.reload();

        }




</script>


<div class="row justify-content-center">


    <table style="width:90%">

        <tr>

            <td><asp:TextBox CssClass="cajas" ID="cajaComentarios" runat="server" TextMode="MultiLine" style="width:100%; height:150px" placeholder="Escribe aquí tu comentario"></asp:TextBox>


                <ajaxToolkit:HtmlEditorExtender 
    ID="cajaComentarios_HtmlEditorExtender" 
    runat="server" 
    TargetControlID="cajaComentarios"
                    >
                    

    <Toolbar>
        <ajaxToolkit:InsertImage />
    </Toolbar>

</ajaxToolkit:HtmlEditorExtender>

            </td>

        </tr>
        <tr>
            
            <td>
                

                        <input class="botones" style="width: 100%"  id="botonEnvio" type="button" onclick="enviarComentario(this)" value="Enviar" />
                    
                    </td>
            

        </tr>

       
    </table>

   
</div>

    

