<%@ Page Title="Cursos Creados" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeCursosCreadosDeLaCuenta.aspx.cs" Inherits="Vistas_ListaDeCursosDeLaCuenta" %>

<%@ Register Src="~/Controles/Estrellas/Estrellas.ascx" TagPrefix="uc1" TagName="Estrellas" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

    <br />
    <br />
    <br />
    <br />
    <br />

    <center><h1>Cursos Creados</h1></center>
    <table class="auto-style1">
        <tr>
            <td class="auto-style3">
                
                <table id="filtrosCursos">
                    <tr>
                        <td>
                            <asp:Button CssClass="botonPulsado" ID="botonCreados" runat="server" Text="Creados" />
                            <asp:Button CssClass="botones" ID="botonInscritos" runat="server" Text="Inscritos" OnClick="botonInscritos_Click"/>
                        </td>
                        
                    </tr>
                    <tr>
                        <td>
                <asp:TextBox ID="cajaBuscador" runat="server" placeHolder="Nombre del curso"></asp:TextBox>
                <ajaxToolkit:AutoCompleteExtender 
                    MinimumPrefixLength="1"
                    CompletionInterval="10"
                    CompletionSetCount="1"
                    FirstRowSelected="false"
                    ID="cajaBuscador_AutoCompleteExtender" 
                    runat="server" 
                    ServiceMethod="GetNombresCursos"
                    TargetControlID="cajaBuscador">
                </ajaxToolkit:AutoCompleteExtender>
                            <asp:TextBox ID="cajaFechaCreacion" runat="server" placeHolder="Fecha de creación"></asp:TextBox>
                            <ajaxToolkit:CalendarExtender ID="cajaFechaCreacion_CalendarExtender" runat="server" BehaviorID="cajaFechaCreacion_CalendarExtender" TargetControlID="cajaFechaCreacion" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:DropDownList ID="desplegableArea" runat="server" DataSourceID="AreasSource" DataTextField="Area" DataValueField="Area">
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="AreasSource" runat="server" SelectMethod="GetAreasSrc" TypeName="GestionCurso"></asp:ObjectDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:DropDownList ID="desplegableEstado" runat="server" DataSourceID="EstadosCursoSource" DataTextField="Estado" DataValueField="Estado">
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="EstadosCursoSource" runat="server" SelectMethod="GetEstadosSrc" TypeName="GestionCurso"></asp:ObjectDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img class="auto-style2" src="../../Recursos/Imagenes/ListaDeCursos/Filtro.png" /><asp:Button CssClass="botones" ID="botonFiltrar" runat="server" Text="Filtrar" />
                        </td>
                    </tr>
                </table>
                  
                    </td>
            <td rowspan="2">
                <asp:GridView ID="tablaCursos" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="CursosSource" OnRowDataBound="tablaCursos_RowCreated" AllowPaging="True">
                    <Columns>
                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" SortExpression="Nombre">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Area" HeaderText="Área del<br/>conocimiento" SortExpression="Area" HtmlEncode="False">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha de<br/>Creación" SortExpression="FechaCreacion" HtmlEncode="False" DataFormatString="{0:dd/MM/yyyy}">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Estado" HeaderText="Estado" SortExpression="Estado">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Puntuacion" HeaderText="Calificación" SortExpression="Puntuacion">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Editar Curso">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expulsar<br/>Alumnos">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Calificar<br/>Exámenes">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:ObjectDataSource ID="CursosSource" runat="server" SelectMethod="GetCursosCreados" TypeName="GestionCurso">
                    <SelectParameters>
                        <asp:SessionParameter Name="usuario" SessionField="Usuario" Type="Object" />
                        <asp:ControlParameter ControlID="cajaBuscador" Name="nombre" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="cajaFechaCreacion" Name="fechaCreacion" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="desplegableArea" Name="area" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="desplegableEstado" Name="estado" PropertyName="SelectedValue" Type="String" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </td>
        </tr>
        
    </table>

    <br />

</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="head">
    <style type="text/css">
        .auto-style1 {
            width: 64px;
        }

        .auto-style2 {
            width: 64px;
            height: 64px;
        }
        .auto-style3 {
            height: 35px;
        }
    </style>
</asp:Content>
