<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/visualizacionTemaDelCurso.aspx.cs" Inherits="Vistas_Cursos_visualizacionTemaDelCurso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <br />
    <br />
    <br />
    <br />

    <!--TAN SOLO ES LA PLANTILLA PARA AGREGAR EL EXAMEN, LA CAJA DE COMENTARIOS Y EL CONTENIDO DEL TEMA DEL CURSO-->

    <center>
            <table class="auto-style1">
        <tr>
            <td>&nbsp;<asp:Label Text="TITULO DEL TEMA" runat="server" /></td>
        </tr>

        <tr>
            <td>&nbsp;<asp:Label Text="INFORMACIÓN DEL CURSO" runat="server" /></td>
        </tr>

        <tr>
            <td>&nbsp;<h4>ESPACIO PARA EL EXAMEN</h4> </td>
        </tr>
        
        <tr>
            <td>&nbsp;<h4>ESPACIO PARA LA CAJA DE COMENTARIOS</h4></td>
        </tr>
    </table>
    </center>
    
    <br />
    <br />
    <br />
    <br />
</asp:Content>

