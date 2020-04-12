<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/DetallesSugerencia.aspx.cs" Inherits="Vistas_DetallesSugerencia" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">

    <br />
    <br />
    <br />
    <br />
    <br />


    <center>
        <asp:Label ID="titulo" runat="server" Text="Título de sugerencia"></asp:Label>
        <br />
        <br />
        <asp:TextBox ID="cajaSugerencia" runat="server" Height="300px" Width="300px"></asp:TextBox>
    </center>

    <ajaxToolkit:HtmlEditorExtender ID="cajaSugerencia_HtmlEditorExtender" runat="server" TargetControlID="cajaSugerencia">

        <Toolbar>

            <ajaxToolkit:InsertImage />

        </Toolbar>

        </ajaxToolkit:HtmlEditorExtender>


    <br />

</asp:Content>

