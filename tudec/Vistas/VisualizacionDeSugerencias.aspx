<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/VisualizacionDeSugerencias.aspx.cs" Inherits="Vistas_VisualizacionDeSugerencias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style2 {
            width: 32px;
            height: 32px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">


    <br />
    <br />
    <br />
    <br />
    <br />


    <table class="w-100">
        <tr>
            <td>
                <img alt ="" class="auto-style2" src="../Recursos/Imagenes/ListaDeCursos/Filtro.png" /><asp:DropDownList ID="desplegableLectura" runat="server">
                    <asp:ListItem>Estado de lectura</asp:ListItem>
                    <asp:ListItem>Leídos</asp:ListItem>
                    <asp:ListItem>No leídos</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>
                <img alt="" class="auto-style2" src="../Recursos/Imagenes/Busqueda/Lupa.png" /><asp:TextBox ID="cajaBuscador" runat="server" placeHolder="Buscar"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="5">
                <asp:GridView ID="GridView1" runat="server">
                </asp:GridView>
            </td>
        </tr>
    </table>


    <br />


</asp:Content>

