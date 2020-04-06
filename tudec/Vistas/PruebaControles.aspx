<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PruebaControles.aspx.cs" Inherits="Vistas_PruebaControles" %>

<%@ Register Src="~/Controles/Buzon/Buzon.ascx" TagPrefix="uc1" TagName="Buzon" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <uc1:Buzon runat="server" ID="Buzon" />
        </div>
    </form>
</body>
</html>
