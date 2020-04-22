<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Pruebas.aspx.cs" Inherits="Vistas_Pruebas" %>

<%@ Register Src="~/Controles/Examenes/CreacionExamen.ascx" TagPrefix="uc1" TagName="CreacionExamen" %>


<!DOCTYPE html>
<script>





</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    

    <form id="form1" runat="server">

        <asp:ScriptManager runat="server"></asp:ScriptManager>

        <uc1:CreacionExamen runat="server" ID="CreacionExamen" />
    </form>
</body>
</html>
