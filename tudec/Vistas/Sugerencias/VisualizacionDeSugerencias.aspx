<%@ Page Title="Sugerencias" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/VisualizacionDeSugerencias.aspx.cs" Inherits="Vistas_VisualizacionDeSugerencias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style2 {
            width: 32px;
            height: 32px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

    <br />
    <br />
    <br />
    <br />
    <br />


    <center>
    <table class="w-100">

        
        <tr>
            <td>
                <img alt ="" class="auto-style2" src="../../Recursos/Imagenes/ListaDeCursos/Filtro.png" /><asp:DropDownList ID="desplegableLectura" runat="server" AutoPostBack="True" OnSelectedIndexChanged="desplegableLectura_SelectedIndexChanged">
                    <asp:ListItem>Estado de lectura</asp:ListItem>
                    <asp:ListItem>Leídos</asp:ListItem>
                    <asp:ListItem>No leídos</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right">
                <img alt="" class="auto-style2" src="../../Recursos/Imagenes/Busqueda/Lupa.png" /><asp:TextBox ID="cajaBuscador" runat="server" placeHolder="Buscar"></asp:TextBox>
                <ajaxToolkit:AutoCompleteExtender 
                     
                    MinimumPrefixLength="1"
                    CompletionInterval="10"
                    CompletionSetCount="1"
                    FirstRowSelected="false"
                    ID="cajaBuscador_AutoCompleteExtender" 
                    runat="server" 
                    ServiceMethod="GetTitulosSugerencias"
                    TargetControlID="cajaBuscador"
                    
                 >
        
                </ajaxToolkit:AutoCompleteExtender>
            </td>
        </tr>
        
        <tr>
            <td colspan="5">
           
                <asp:GridView ID="tablaSugerencias" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="SugerenciasSource" OnRowDataBound="tablaSugerencias_RowDataBound" AllowPaging="True">
                    <PagerStyle HorizontalAlign="Center" />
                    <Columns>
                        <asp:BoundField DataField="Emisor" HeaderText="Emisor" SortExpression="Emisor">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Titulo" HeaderText="Título" SortExpression="Titulo">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:CheckBoxField DataField="Estado" HeaderText="Estado de lectura" SortExpression="Estado">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:CheckBoxField>
                        <asp:BoundField DataField="Fecha" HeaderText="Fecha" SortExpression="Fecha">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Ver detalles">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                

                <asp:ObjectDataSource ID="SugerenciasSource" runat="server" SelectMethod="GetSugerencias" TypeName="Sugerencia">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="desplegableLectura" Name="filtro" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="cajaBuscador" Name="titulo" PropertyName="Text" Type="String" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </td>
        </tr>
    </table>
    </center>

    <br />


</asp:Content>

