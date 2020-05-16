<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/CreacionYEdicionTema.aspx.cs" Inherits="Vistas_Cursos_CreacionYEdicionTema" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }

        td{

            text-align: center;

        }


        .etiquetaCrearTema{

            font-size: 50px;

        }

        .cajaTitulo, .editor, .botonCrearExamen, .botonCrearTema{

            width: 60%;

        }

        .cajaTitulo{

            height: 30px;
            text-align: center;

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
            <td>
                <asp:Label CssClass="etiquetaCrearTema" ID="etiquetaCrearTema" runat="server" Text="Crear tema"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:TextBox CssClass="cajaTitulo" placeholder="Título" ID="cajaTitulo" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:TextBox CssClass="editor" ID="editor" runat="server" TextMode="MultiLine" ></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Button CssClass="botonCrearExamen" ID="botonCrearExamen" runat="server" Text="Crear examen" />
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <asp:Label  ID="etiquetaComentarios" runat="server" Text="Sección de comentarios"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Button CssClass="botonCrearTema" ID="botonCrearTema" runat="server" Text="Crear tema" />
            </td>
        </tr>
    </table>



    <br />

</asp:Content>

