<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CalificacionExamen.ascx.cs" Inherits="Controles_CalificacionExamen" %>


<center>


    <div style="width: 60%; text-align: left;">
    <asp:Label  ID="etiquetaFecha" runat="server" Text="Fecha límite xx/xx/xx a las xx:xx"></asp:Label>
        </div>

    <br />
    <br />

    <asp:Panel ID="panelContenido" runat="server">




    </asp:Panel>

    <asp:Button style="width: 60%" ID="botonCalificar" runat="server" Text="Calificar examen" OnClick="botonCalificar_Click"></asp:Button>

    <br />
    <br />

    <asp:Label ID="etiquetaNota" runat="server" Text="Nota: XX"></asp:Label>

</center>

