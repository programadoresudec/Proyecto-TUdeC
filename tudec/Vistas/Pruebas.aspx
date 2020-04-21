<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Pruebas.aspx.cs" Inherits="Vistas_Pruebas" %>

<!DOCTYPE html>
<script>


    function prueba() {


        alert("Funcionando");

    }


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="TextBox1"></asp:RequiredFieldValidator>

        </div>
        <asp:Button ID="Button1"  runat="server" Text="Button" OnClick="Button1_Click" />
    </form>
</body>
</html>
