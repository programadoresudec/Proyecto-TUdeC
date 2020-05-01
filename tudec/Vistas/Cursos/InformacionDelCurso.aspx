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

    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

    <table  class="auto-style1">
        <tr>
            <td colspan="3">
                <center>
                    <asp:Label style="color: #2D732D; font-size: 40px" Text="TituloCurso" runat="server" ID="etiquetaTitulo" /></td>
                </center>
        </tr>

        <tr>
            <td colspan="3"></td>
        </tr>

        <tr>
            <td class="auto-style6">
                <h4 style="color: #2D732D">CREADO POR: <asp:Label Text="NombreDeUsuario" runat="server" ID="etiquetaNombreUsuario" />
                </h4>

            </td>

            <td style="width:60%" rowspan="4">
                <asp:GridView style="width:100%" ID="tablaTemas" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="TemasDataSource" OnRowDataBound="tablaTemas_RowDataBound" AllowPaging="True" DataKeyNames="Id">
                    <Columns>
                        <asp:BoundField DataField="Titulo" HeaderText="Titulo" SortExpression="Titulo" />
                    </Columns>
                </asp:GridView>
                <asp:ObjectDataSource ID="TemasDataSource" runat="server" SelectMethod="GetTemas" TypeName="GestionTemas">
                    <SelectParameters>
                        <asp:SessionParameter Name="curso" SessionField="cursoSeleccionado" Type="Object" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </td>
        </tr>

        <tr>
            <td colspan="2"><asp:Label Text="Nombre" runat="server" ID="etiquetaNombre" /></td>
        </tr>
        <tr>
            <td class="auto-style6"><asp:Label Text="CorreoUsuario" runat="server" ID="etiquetaCorreo" /></td>
            <td class="auto-style3"></td>
        </tr>

        <tr>
            <td class="auto-style7"><asp:Button Text="¡Habla Conmigo!" runat="server" CssClass="auto-style13" BackColor="#666666" ForeColor="White" ID="botonInbox" /><asp:Button Text="Inscribirse" runat="server" BackColor="#003300" ForeColor="White" ID="botonInscribirse" /></td>
          
        </tr>

        <tr>
            <td class="auto-style10"><asp:Image ImageUrl="Ícono" runat="server" ID="imagenArea" />
                <asp:Label Text="área" runat="server" ID="etiquetaArea" /></td>
            <td class="auto-style12"></td>
                    
            <td>&nbsp; </td>
                            
        <tr>
            <td colspan="3"><center><h3>DESCRIPCIÓN DEL CURSO</h3></center>
            </td>
        </tr>

        <tr>
            <td colspan="3">
                <center>
                <div  style="width:60%; text-align:left">
                    <asp:Label ID="etiquetaDescripcion" runat="server" Text="Contenido descripción"></asp:Label>

                </div>
                    </center></td>
        </tr>

        <tr>
            <td colspan="3"><center><h3>COMENTARIOS</h3></center></td>
        </tr>

        <tr>
            <td colspan="3">&nbsp;</td>
        </tr>

    </table>


    <br />
    <br />
    <br />
    <br />
    <br />
</asp:Content>

