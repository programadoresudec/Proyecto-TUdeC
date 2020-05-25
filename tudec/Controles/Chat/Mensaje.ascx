<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Mensaje.ascx.cs" Inherits="Controles_Chat_Mensaje" %>

<%@ Register Src="~/Controles/ReportarCuenta/ReportarCuenta.ascx" TagPrefix="uc1" TagName="ReportarCuenta" %>

<div class="row ml-4">
    
    <i class="fa fa-sm"> <uc1:ReportarCuenta  runat="server" ID="ReportarCuenta"/></i>
    
</div>
 
<asp:Panel style="background-color:cadetblue; padding: 20px; border-radius: 20px" ID="panelMensaje" runat="server">
 
</asp:Panel>
    