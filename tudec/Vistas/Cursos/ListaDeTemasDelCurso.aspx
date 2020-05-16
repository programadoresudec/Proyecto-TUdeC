<%@ Page Title="Calificación de Exámenes" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeTemasDelCurso.aspx.cs" Inherits="Vistas_Cursos_ListaDeTemasDelCurso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">

    <br />
    <br />
    <br />
    <br />
    <br />

    <center>

        <asp:GridView style=" width: 60%" CssClass="tablas" ID="tablaTemario" runat="server" AutoGenerateColumns="False" DataSourceID="temarioDataSource" AllowPaging="True" OnRowDataBound="tablaTemario_RowDataBound" DataKeyNames="Id">
            <Columns>
                <asp:BoundField DataField="Titulo" HeaderText="Temas" SortExpression="Titulo" />
            </Columns>
        </asp:GridView>
        <asp:Button ID="botonAgregarTema" runat="server" Text="Añadir tema" OnClick="botonAgregarTema_Click"></asp:Button>

    </center>

    <asp:ObjectDataSource ID="temarioDataSource" runat="server" SelectMethod="GetTemas" TypeName="GestionTemas">
        <SelectParameters>
            <asp:SessionParameter Name="curso" SessionField="cursoSeleccionado" Type="Object" />
        </SelectParameters>
    </asp:ObjectDataSource>


    <br />

</asp:Content>

