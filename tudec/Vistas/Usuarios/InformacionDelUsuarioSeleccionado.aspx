<%@ Page Title="Usuario" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/InformacionDelUsuarioSeleccionado.aspx.cs" Inherits="Vistas_InformacionDelUsuarioSeleccionado" %>

<%@ Register Src="~/Controles/Estrellas/Estrellas.ascx" TagPrefix="uc1" TagName="Estrellas" %>
<%@ Register Src="~/Controles/Estrellas/EstrellasPuntuacion.ascx" TagPrefix="uc1" TagName="EstrellasPuntuacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">



    <style type="text/css">
        .auto-style1 {
            width: 99px;
        }
        .auto-style2 {
            width: 145px;
            height: 143px;
        }
        .auto-style3 {
            width: 90px;
        }
        .auto-style4 {
            width: 956px;
            height: 217px;
        }
        .auto-style5 {
            width: 75px;
        }
        .auto-style13 {
            width: 144px;
        }
        .auto-style14 {
            width: 150px;
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

        <table class="auto-style4">
        <tr>
            <td class="auto-style3" rowspan="9">&nbsp;</td>
            <td class="auto-style13">&nbsp;</td>
            <td class="auto-style14">&nbsp;</td>
            <td class="auto-style5" rowspan="9">&nbsp;</td>
            <td style="padding-left: 200px" rowspan="9">&nbsp;         
                
              

                <asp:GridView CssClass="tablas"  ID ="GridViewUsuSelec" runat="server" AutoGenerateColumns="False" DataSourceID="DatosUsuarioSeleccionadoDataSource" AllowPaging="True" Width="675px" OnRowDataBound="GridViewUsuSelec_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Area" HeaderText="Área" SortExpression="Area" HtmlEncode="False" >
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Nombre" HeaderText="Curso " SortExpression="Nombre" >
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha de creación" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}" >
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Estado" HeaderText="Estado" SortExpression="Estado" >
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Puntuacion" HeaderText="Puntuación" SortExpression="Puntuacion" >
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>

            <asp:ObjectDataSource ID="DatosUsuarioSeleccionadoDataSource" runat="server" SelectMethod="GetCursos" TypeName="DaoUsuario">
                <SelectParameters>
                    <asp:SessionParameter Name="eUsuario" SessionField="UsuarioSeleccionado" Type="Object" />
                </SelectParameters>
            </asp:ObjectDataSource></td>
        </tr>

        <tr>
            <td class="auto-style1" colspan="2">

                <asp:Image ID="imagenUsuario" CssClass="card-img rounded-circle" style="width: 150px; height:150px" runat="server" />

                </td>
            

        </tr>

        <tr>
            <td>
                <p>Nombre de usuario:</p>
            </td>
            <td class="auto-style14">
               <asp:Label ID="etiquetaNombreUsuario" runat="server" Text="Nombre Usuario"></asp:Label>
            </td>

        </tr>

        <tr>
            <td class="auto-style13"><p>Nombres: </p></td>
            <td ><asp:Label Text="Nombre" runat="server" ID="etiquetaNombre" /> </td>
        </tr>

        <tr>
            <td class="auto-style13"><p>Apellidos: </p></td>
            <td class="auto-style14" ><asp:Label Text="Apellido" runat="server" ID="etiquetaApellido" /></td>
        </tr>

        <tr>
            <td class="auto-style13" > <p>Calificación:</p>
                
            </td>
            <td class="auto-style14">
                
                <asp:Panel ID="panelEstrellas" runat="server">

                    <asp:Label Text="Numero de estrellas" runat="server" ID="etiquetaPuntuacion" />  

                </asp:Panel>
                

            </td>
        </tr>

        <tr>
            <td colspan="2"><p>Descripción:</p>
            </td>
        </tr>

        <tr>
            <td colspan="2">
                <asp:Label ID="etiquetaDescripcion" runat="server" Text="Espacio para la descripción" />
            </td>
        </tr>

        <tr>
            <td class="auto-style13" ><asp:Label Text="CALIFICAR:" runat="server" /></td>
            <td class="auto-style14">
                <uc1:EstrellasPuntuacion runat="server" id="EstrellasPuntuacion" />
            </td>
        </tr>
    </table>
</asp:Content>

