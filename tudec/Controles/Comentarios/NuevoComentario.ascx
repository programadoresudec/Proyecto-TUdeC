<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NuevoComentario.ascx.cs" Inherits="Controles_Comentarios_NuevoComentario" %>



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

            <td><asp:Button style="width: 100%" ID="botonEnvio" runat="server" Text="Enviar" OnClick="botonEnvio_Click" /></td>

        </tr>

       
    </table>

   
</div>

