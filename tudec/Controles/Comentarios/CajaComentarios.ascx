<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CajaComentarios.ascx.cs" Inherits="Controles_CajaComentarios" %>
<%@ Register Src="~/Controles/Comentarios/NuevoComentario.ascx" TagPrefix="uc1" TagName="NuevoComentario" %>
<%@ Register Src="~/Controles/Comentarios/ComentarioExistente.ascx" TagPrefix="uc1" TagName="ComentarioExistente" %>

<asp:Panel ID="panelComentarios" runat="server">

<uc1:NuevoComentario runat="server" ID="NuevoComentario" />

</asp:Panel>


