<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/CreacionYEdicionCurso.aspx.cs" Inherits="Vistas_Cursos_CreacionYEdicionCurso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }

        td{

            text-align:center;

        }

        .cajaDescripcion, .cajaTitulo, .botonAgregarTema, .botonCrearCurso{

            width: 60%;

        }

        .desplegableArea{

            width: 100%;
        }

        .cajaFechaInicio{

            width: 100%;

        }

        .cajaTitulo{

            height: 30px;
            text-align:center;
        }

        .etiquetaCrearCurso{

            font-size: 50px;

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
                <asp:Label CssClass="etiquetaCrearCurso" ID="etiquetaCrearCurso" runat="server" Text="Crear curso"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:TextBox CssClass="cajaTitulo" ID="cajaTitulo" placeholder="Título" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <center>
                <table style="width: 60%">
                    <tr>
                        <td style="width: 50%">
                <asp:DropDownList CssClass="desplegableArea" ID="desplegableArea" runat="server" DataSourceID="AreasDataSource" DataTextField="Area" DataValueField="Area">
                </asp:DropDownList>
                            <asp:ObjectDataSource ID="AreasDataSource" runat="server" SelectMethod="GetAreasSrc" TypeName="GestionCurso"></asp:ObjectDataSource>
                        </td>
                        <td style="width: 10%">
                <asp:TextBox ID="cajaFechaInicio" placeholder="Fecha inicio" runat="server"></asp:TextBox>
                <ajaxToolkit:CalendarExtender ID="cajaFechaInicio_CalendarExtender" runat="server" BehaviorID="cajaFechaInicio_CalendarExtender" TargetControlID="cajaFechaInicio" />
                        </td>
                    </tr>
                </table>
                    </center>
            </td>
           

        </tr>
        <tr>
            <td>
                <asp:Label ID="etiquetaDescripcion"  runat="server" Text="Descripción"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:TextBox ID="cajaDescripcion" CssClass="cajaDescripcion" runat="server" TextMode="MultiLine"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Button ID="botonCrearCurso" CssClass="botonCrearCurso" runat="server" Text="Crear curso" OnClick="botonCrearCurso_Click" />
            </td>
        </tr>
    </table>



    <br />
</asp:Content>

