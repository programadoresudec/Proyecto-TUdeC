<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/visualizacionTemaDelCurso.aspx.cs" Inherits="Vistas_Cursos_visualizacionTemaDelCurso" %>

<%@ Register Src="~/Controles/Examenes/CreacionExamen.ascx" TagPrefix="uc1" TagName="CreacionExamen" %>
<%@ Register Src="~/Controles/Examenes/ElaboracionExamen.ascx" TagPrefix="uc1" TagName="ElaboracionExamen" %>
<%@ Register Src="~/Controles/Comentarios/CajaComentarios.ascx" TagPrefix="uc1" TagName="CajaComentarios" %>




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
            <td align="center"><asp:Label style="font-size: 50px"  Text="TÍTULO DEL TEMA" runat="server" ID="etiquetaTitulo" /></td>
        </tr>

        <tr>
            <td align="center">
                

                   
                    <asp:Panel style="text-align:left" ID="panelContenido" Width="60%" Height="500px" runat="server" BorderStyle="Solid" ScrollBars="Vertical"></asp:Panel>

                    
    
                    
            </td>
        </tr>

        <tr>
            <td align="center">

            <asp:Panel ID="panelExamen" runat="server">





            </asp:Panel>

                <%--<uc1:ElaboracionExamen runat="server" id="ElaboracionExamen" />--%>

            </td>
        </tr>
        
        <tr>
            <td align="center"><h4>COMENTARIOS&nbsp;</h4></td>
        </tr>

                <tr>


                    <td>

<uc1:CajaComentarios runat="server" id="CajaComentarios" />

                    </td>

                </tr>
    </table>
    </center>
    
    <br />
    <br />
    <br />
    <br />
</asp:Content>

