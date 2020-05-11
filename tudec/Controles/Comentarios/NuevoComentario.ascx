<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NuevoComentario.ascx.cs" Inherits="Controles_Comentarios_NuevoComentario" %>


<script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>

<script>



        function enviarComentario() {

            var paginaContenedora = "<%=Page.GetType().ToString()%>";
            var caja = <%=cajaComentarios.ClientID%>;

            var contenidoCaja = caja.value;

            var datos = "{'paginaContenedora':'" + paginaContenedora + "','contenidoCaja':'" + contenidoCaja + "'}";

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

            <td><asp:TextBox ID="cajaComentarios" runat="server" TextMode="MultiLine" style="width:100%; height:150px" placeholder="Escribe aquí tu comentario"></asp:TextBox>


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
                

                        <input style="width: 100%"  id="botonEnvio" type="button" onclick="enviarComentario()" value="Enviar" />
                    
                    </td>
            

        </tr>

       
    </table>

   
</div>

    

