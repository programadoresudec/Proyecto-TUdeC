<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NuevoComentario.ascx.cs" Inherits="Controles_Comentarios_NuevoComentario" %>


<div class="row justify-content-center">

<asp:TextBox ID="cajaComentarios" runat="server" TextMode="MultiLine" style="width:60%; height:150px" placeholder="Escribe aquí tu comentario"></asp:TextBox>

<asp:Button style="width: 60%" ID="botonEnvio" runat="server" Text="Enviar" OnClick="botonEnvio_Click" />

</div>

<ajaxToolkit:HtmlEditorExtender 
    ID="cajaComentarios_HtmlEditorExtender" 
    runat="server" 
    TargetControlID="cajaComentarios">

    <Toolbar>
        <ajaxToolkit:InsertImage />
    </Toolbar>

</ajaxToolkit:HtmlEditorExtender>