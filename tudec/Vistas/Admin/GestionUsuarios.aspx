<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/GestionUsuarios.aspx.cs" Inherits="Vistas_Admin_GestionUsuarios" %>


<asp:Content ID="contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">

    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

    <div class="container">
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />

        <center>
        <asp:GridView ID="GridView1" runat="server" CssClass="tablas" AutoGenerateColumns="False" DataSourceID="ODS_DaoUsuario">
            <Columns>
                <asp:BoundField DataField="NombreDeUsuario" HeaderText="NombreDeUsuario" SortExpression="NombreDeUsuario" >
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="FechaCreacion" HeaderText="FechaCreacion" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}" >
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:ImageField DataImageUrlField="ImagenPerfil" HeaderText="ImagenPerfil" SortExpression="ImagenPerfil" >
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                </asp:ImageField>
                <asp:BoundField DataField="NumCursos" HeaderText="NumCursos" SortExpression="NumCursos" >
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
            </Columns>
        </asp:GridView>

        </center>
        <asp:ObjectDataSource ID="ODS_DaoUsuario" runat="server" SelectMethod="gestionDeUsuarioAdmin" TypeName="DaoUsuario">
        </asp:ObjectDataSource>
        <br />
        <br />
        <br />
    </div>

</asp:Content>

