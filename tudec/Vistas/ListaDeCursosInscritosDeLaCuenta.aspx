﻿<%@ Page Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeCursosInscritosDeLaCuenta.aspx.cs" Inherits="Vistas_ListaDeCursosInscritosDeLaCuenta" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" Runat="Server">

    <link href="../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

    <br />
    <br />
    <br />
    <br />
    <br />

        <center>
            <h1>Cursos Inscritos</h1>
        </center>

        <table class="auto-style1">
            <tr>
                <td>
                    <asp:TextBox ID="cajaBuscador" runat="server"></asp:TextBox>
                    <asp:Button ID="botonBuscar" runat="server" Text="Buscar" />
                    </td>
                <td rowspan="2">
                    <asp:GridView ID="tablaCursos" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="CursosSource" OnRowDataBound="tablaCursos_RowCreated" Width="853px">
                        <Columns>
                            <asp:BoundField DataField="Nombre" HeaderText="Curso" SortExpression="Nombre">
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Area" HeaderText="Área del<br/>conocimiento" SortExpression="Area"  HtmlEncode="false">
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Fecha de<br/>Creación" SortExpression="FechaCreacion" HtmlEncode="false">
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Creador" HeaderText="Tutor" SortExpression="Creador">
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Puntuacion" HeaderText="Puntuación" SortExpression="Puntuacion">
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Boleta de<br/>Calificaciones">
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Cancelar<br/>Inscripción">
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="CursosSource" runat="server" SelectMethod="GetCursosInscritos" TypeName="GestionCurso">
                        <SelectParameters>
                            <asp:SessionParameter Name="usuario" SessionField="Usuario" Type="Object" />
                            <asp:ControlParameter ControlID="cajaBuscador" Name="nombre" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="cajaTutor" Name="tutor" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="cajaFechaCreacion" Name="fechaCreacion" PropertyName="Text" Type="DateTime" />
                            <asp:ControlParameter ControlID="desplegableArea" Name="area" PropertyName="SelectedValue" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </td>
            </tr>
            <tr>
                <td>
                    <table class="auto-style1">
                        <tr>
                            <td>
                                    <asp:TextBox ID="cajaFechaCreacion" runat="server"></asp:TextBox>
                                </td>
                        </tr>
                        <tr>
                            <td>
                                    <asp:DropDownList ID="desplegableArea" runat="server" DataTextField="Area" DataValueField="Area" DataSourceID="AreasSource">
                                    </asp:DropDownList>
                                    <asp:ObjectDataSource ID="AreasSource" runat="server" SelectMethod="GetAreasSrc" TypeName="GestionCurso"></asp:ObjectDataSource>
                                    </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="cajaTutor" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="auto-style2">
                                    <img class="auto-style2" src="../Recursos/Imagenes/ListaDeCursos/Filtro.png" /><asp:Button ID="botonFiltrar" CssClass="botones" runat="server" Text="Filtrar" />
                                </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

    <br />

</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="head">
    <style type="text/css">
        .auto-style1 {
            width: 64px;
        }
        .auto-style2 {
            width: 64px;
            height: 64px;
        }
    </style>
</asp:Content>