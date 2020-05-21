<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Notificaciones.aspx.cs" Inherits="Vistas_Notificaciones_Notificaciones" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <div class="container mt-5">
        <br />
        <br />
        <asp:DataList ID="DataList1" runat="server" DataSourceID="ODS_Notificaciones">
            <ItemTemplate>
                Id:
                <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                <br />
                Mensaje:
                <asp:Label ID="MensajeLabel" runat="server" Text='<%# Eval("Mensaje") %>' />
                <br />
                Estado:
                <asp:Label ID="EstadoLabel" runat="server" Text='<%# Eval("Estado") %>' />
                <br />
                NombreDeUsuario:
                <asp:Label ID="NombreDeUsuarioLabel" runat="server" Text='<%# Eval("NombreDeUsuario") %>' />
                <br />
                <br />
            </ItemTemplate>
        </asp:DataList>
        <asp:ObjectDataSource ID="ODS_Notificaciones" runat="server" SelectMethod="notificacionesDelUsuario" TypeName="DaoNotificacion">
            <SelectParameters>
                <asp:SessionParameter Name="nombreUsuario" SessionField="notificacionesUsuario" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <br />
        <br />
    </div>
</asp:Content>

