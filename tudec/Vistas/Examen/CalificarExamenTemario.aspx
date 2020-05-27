<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/CalificarExamenTemario.aspx.cs" Inherits="Vistas_CalificarExamenTemario" %>

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

        <asp:GridView style=" width: 60%" CssClass="tablas" ID="tablaTemario" runat="server" AutoGenerateColumns="False" DataSourceID="temarioDataSource" AllowPaging="True" OnRowDataBound="tablaTemario_RowDataBound" DataKeyNames="Id">
            <Columns>
                <asp:BoundField DataField="Titulo" HeaderText="Temas" SortExpression="Titulo" />
            </Columns>
        </asp:GridView>

    </center>

    <asp:ObjectDataSource ID="temarioDataSource" runat="server" SelectMethod="GetTemasConExamen" TypeName="GestionTemas">
        <SelectParameters>
            <asp:SessionParameter Name="curso" SessionField="cursoSeleccionadoParaCalificarExamen" Type="Object" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <br />

</asp:Content>

