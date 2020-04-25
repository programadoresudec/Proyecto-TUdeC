<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/GestionUsuarios.aspx.cs" Inherits="Vistas_Admin_GestionUsuarios" %>


<asp:Content ID="contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <div class="container">
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="ODS_DaoUsuario">
            <Columns>
                <asp:BoundField DataField="NombreDeUsuario" HeaderText="NombreDeUsuario" SortExpression="NombreDeUsuario" />
                <asp:BoundField DataField="FechaCreacion" HeaderText="FechaCreacion" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:ImageField DataImageUrlField="ImagenPerfil" HeaderText="ImagenPerfil" SortExpression="ImagenPerfil" />
                <asp:BoundField DataField="NumCursos" HeaderText="NumCursos" SortExpression="NumCursos" />
            </Columns>
        </asp:GridView>
        <asp:ObjectDataSource ID="ODS_DaoUsuario" runat="server" SelectMethod="gestionDeUsuarioAdmin" TypeName="DaoUsuario">
            <SelectParameters>
                <asp:Parameter Name="usuarios" Type="Object" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <br />
        <br />
        <br />
    </div>

</asp:Content>

