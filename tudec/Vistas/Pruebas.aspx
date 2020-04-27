<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Pruebas.aspx.cs" Inherits="Vistas_Pruebas" %>

<%@ Register Src="~/Controles/Examenes/CreacionExamen.ascx" TagPrefix="uc1" TagName="CreacionExamen" %>
<%@ Register Src="~/Controles/Examenes/ElaboracionExamen.ascx" TagPrefix="uc1" TagName="ElaboracionExamen" %>



<script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
 

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

  
</head>

<body>
    
    

    <form id="form1" runat="server">
       
        <asp:ScriptManager runat="server"></asp:ScriptManager>

        <%--<uc1:CreacionExamen runat="server" ID="CreacionExamen" />--%>


        <uc1:ElaboracionExamen runat="server" ID="ElaboracionExamen" />

        </form>
</body>
</html>
