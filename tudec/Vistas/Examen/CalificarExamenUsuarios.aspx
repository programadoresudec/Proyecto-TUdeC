<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="CalificarExamenUsuarios.aspx.cs" Inherits="Vistas_Examen_CalificarExamenUsuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <br />
    <br />
    <br />
    <br />
    <br />

    <center>


        <asp:GridView style="width: 60%;" CssClass="tablas" ID="tablaUsuarios" runat="server" AllowPaging="True" AutoGenerateColumns="False" DataSourceID="usuariosDataSource1" OnRowDataBound="tablaUsuarios_RowDataBound">
            <Columns>
                <asp:BoundField DataField="NombreDeUsuario" HeaderText="Usuarios" SortExpression="NombreDeUsuario" />
            </Columns>




        </asp:GridView>


        <asp:ObjectDataSource ID="usuariosDataSource1" runat="server" SelectMethod="GetUsuariosExamen" TypeName="DaoUsuario">
            <SelectParameters>
                <asp:SessionParameter Name="tema" SessionField="temaSeleccionado" Type="Object" />
            </SelectParameters>
        </asp:ObjectDataSource>


    </center>

    <br />

</asp:Content>

