<%@ Page Title="Cuenta Activada" Language="C#" AutoEventWireup="true" CodeFile="~/Controladores/CuentaActivada.aspx.cs" Inherits="Vistas_Account_CuentaActivada" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Cuenta Activada</title>
    <link href="~/App_Themes/Estilos/EstilosCuentaActivada.css" rel="stylesheet" type="text/css" media="all" />
    <link href="~/App_Themes/Master/css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
        <!--LOGO WEB-->
    <link href="~/App_Themes/Master/img/LogoTudec.ico" rel="shortcut icon" type="image/x-icon" />
    <!-- Custom Theme files -->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
</head>
<body>
    <form id="form1" runat="server">
        <div class="element-main">
                <div class="form-group col-12">
                    <h1>Cuenta Activada</h1>
                    <br />
                    <p class="text-center"><strong>Su cuenta ha sido activada ya puede disfrutar de TUdeC.</strong></p>
                    <br />
                    <strong>
                        <asp:Button runat="server" OnClick="btnLogeo_Click" Text="Iniciar Sesión"
                            CssClass="btn btn-primary btn-lg btn-block" Style="font-size: medium;"/>
                    </strong>
                </div>
            </div>
    </form>
</body>
</html>
