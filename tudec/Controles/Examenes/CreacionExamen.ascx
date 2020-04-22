<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CreacionExamen.ascx.cs" Inherits="Controles_CreacionExamen" %>
<style type="text/css">
    .auto-style1 {
        width: 100%;
    }
</style>
<ajaxToolkit:CalendarExtender ID="cajaFecha_CalendarExtender" runat="server" BehaviorID="cajaFecha_CalendarExtender" TargetControlID="cajaFecha" />
<asp:ObjectDataSource ID="sourceTipos" runat="server" SelectMethod="GetTiposPregunta" TypeName="GestionExamen"></asp:ObjectDataSource>
            

<table class="auto-style1">
    <tr>
        <td>
            <asp:DropDownList ID="desplegableTipo" runat="server" DataSourceID="sourceTipos" DataTextField="Tipo" DataValueField="Tipo" >
            </asp:DropDownList>
            <asp:Button ID="botonCrear" runat="server" Text="Crear" OnClick="botonCrear_Click" />
        </td>
        <td align="center">
            <asp:TextBox placeHolder="Fecha de finalización" ID="cajaFecha" runat="server"></asp:TextBox>
            <asp:DropDownList ID="desplegableHora" runat="server">
                <asp:ListItem>Hora</asp:ListItem>
            </asp:DropDownList>
            <asp:DropDownList ID="desplegableMinuto" runat="server" >
                <asp:ListItem>Minuto</asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
</table>


<asp:Panel ID="panelContenido" runat="server">
</asp:Panel>



