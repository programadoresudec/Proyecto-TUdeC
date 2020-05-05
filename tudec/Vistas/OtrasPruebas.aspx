<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OtrasPruebas.aspx.cs" Inherits="Vistas_OtrasPruebas" %>

<%@ Register Src="~/Controles/Comentarios/NuevoComentario.ascx" TagPrefix="uc1" TagName="NuevoComentario" %>
<%@ Register Src="~/Controles/Comentarios/CajaComentarios.ascx" TagPrefix="uc1" TagName="CajaComentarios" %>



<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>

    
    <form id="form1" runat="server">
        
        <asp:ScriptManager runat="server"></asp:ScriptManager>
       

        <uc1:CajaComentarios runat="server" ID="CajaComentarios" />


    </form>
</body>
</html>
