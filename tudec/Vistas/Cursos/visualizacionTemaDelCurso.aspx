<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/visualizacionTemaDelCurso.aspx.cs" Inherits="Vistas_Cursos_visualizacionTemaDelCurso" %>

<%@ Register Src="~/Controles/Examenes/CreacionExamen.ascx" TagPrefix="uc1" TagName="CreacionExamen" %>
<%@ Register Src="~/Controles/Examenes/ElaboracionExamen.ascx" TagPrefix="uc1" TagName="ElaboracionExamen" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <br />
    <br />
    <br />
    <br />
     <br />
     <br />

    <!--TAN SOLO ES LA PLANTILLA PARA AGREGAR EL EXAMEN, LA CAJA DE COMENTARIOS Y EL CONTENIDO DEL TEMA DEL CURSO-->

    <center>
            <table class="auto-style1" style="width: 100%">
        <tr>
            <td align="center"><asp:Label style="font-size: 50px"  Text="TÍTULO DEL TEMA" runat="server" /></td>
        </tr>

        <tr>
            <td align="center"><asp:Label Text="INFORMACIÓN DEL TEMA" runat="server" /></td>
        </tr>

        <tr>
            <td align="center">

                <uc1:ElaboracionExamen runat="server" id="ElaboracionExamen" />

            </td>
        </tr>
        
        <tr>
            <td align="center"><h4>ESPACIO PARA LA CAJA DE COMENTARIOS</h4></td>
        </tr>
    </table>
    </center>
    
    <br />
    <br />
    <br />
    <br />
</asp:Content>

