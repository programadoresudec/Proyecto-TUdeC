<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/InformacionDelCurso.aspx.cs" Inherits="Vistas_Cursos_InformacionDelCurso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 99%;
        }
        .auto-style2 {
            height: 9px;
        }
        .auto-style3 {
            width: 161px;
        }
        .auto-style4 {
            width: 136px;
        }
        .auto-style5 {
            height: 21px;
        }
        .auto-style6 {
            width: 110px;
        }
        .auto-style7 {
            width: 110px;
            height: 19px;
        }
        .auto-style8 {
            width: 161px;
            height: 19px;
        }
        .auto-style10 {
            width: 59px;
            height: 58px;
        }
        .auto-style11 {
            width: 110px;
            height: 58px;
        }
        .auto-style12 {
            width: 161px;
            height: 58px;
        }
        .auto-style13 {
            margin-right: 0;
            margin-left: 54;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <br />
    <br />
    <br />
    <br />
    <br />


    <table class="auto-style1">
        <tr>
            <td colspan="4">
                <center>
                    <asp:Label style="color: #2D732D; font-size: 40px" Text="TituloCurso" runat="server" ID="etiquetaTitulo" /></td>
                </center>
        </tr>

        <tr>
            <td colspan="4"></td>
        </tr>

        <tr>
            <td class="auto-style6" colspan="2">
                <h4 style="color: #2D732D">CREADO POR:</h4>

            </td>

            <td class="auto-style3">
                <asp:Label Text="NombreDeUsuario" runat="server" ID="etiquetaNombreUsuario" />
            </td>

            <td rowspan="4"><h3>ESPACIO PARA LISTA DE TEMAS</h3></td>
        </tr>

        <tr>
            <td class="auto-style6" colspan="2"><asp:Label Text="Nombre" runat="server" ID="etiquetaNombre" /></td>
            <td class="auto-style3"><asp:Label Text="Apellido" runat="server" ID="etiquetaApellido" /></td>
        </tr>
        <tr>
            <td class="auto-style6" colspan="2"><asp:Label Text="CorreoUsuario" runat="server" ID="etiquetaCorreo" /></td>
            <td class="auto-style3"></td>
        </tr>

        <tr>
            <td class="auto-style7" colspan="2"><asp:Button Text="¡Habla Conmigo!" runat="server" CssClass="auto-style13" BackColor="#666666" ForeColor="White" /></td>
            <td class="auto-style8"><asp:Button Text="Inscribirse" runat="server" BackColor="#003300" ForeColor="White" /></td>
        </tr>

        <tr>
            <td class="auto-style10"><asp:Image ImageUrl="Ícono" runat="server" /></td>
            <td class="auto-style11">
                <asp:Label Text="área" runat="server" /></td>
            <td class="auto-style12"></td>
                    
            <td>&nbsp; </td>
                            
        <tr>
            <td colspan="4" class="auto-style5"><h3>DESCRIPCIÓN DEL CURSO</h3>
            </td>
        </tr>

        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>

        <tr>
            <td colspan="4" class="auto-style2"><h3 class="auto-style4">COMENTARIOS</h3></td>
        </tr>

        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>

    </table>


    <br />
    <br />
    <br />
    <br />
    <br />
</asp:Content>

