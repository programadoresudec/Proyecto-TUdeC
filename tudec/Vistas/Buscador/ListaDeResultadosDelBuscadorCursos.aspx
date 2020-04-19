<%@ Page Title="Búsqueda Cursos" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeResultadosDelBuscadorCursos.aspx.cs" Inherits="ListaDeResultadosDelBuscador" %>

<%@ Register Src="~/Controles/Estrellas/Estrellas.ascx" TagPrefix="uc1" TagName="Estrellas" %>


<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>




<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" Runat="Server">

    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

        <br />
    <br />
    <br />
    <br />
    <br />

        <table class="auto-style1">
            <tr>
                
                <td>
                    <asp:Button CssClass="botonPulsado" ID="botonCurso" runat="server" Text="Buscar curso" />
                    <asp:Button  CssClass="botones" ID="botonTutor" runat="server" OnClick="botonTutor_Click" Text="Buscar tutor" />
                </td>
            </tr>
            <tr>
                <td>
                    
                    <table class="auto-style3">
                        <tr>
                            <td class="auto-style2">
                    <asp:TextBox ID="cajaBuscador" runat="server" placeHolder="Buscar curso" Width="217px"></asp:TextBox>
                            </td>
                            <td>
                    <asp:ImageButton ID="botonBuscar" runat="server" ImageUrl="~/Recursos/Imagenes/Busqueda/Lupa.png" Width="30px" />
                            </td>
                        </tr>
                    </table>
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
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server" Text="Filtros" Font-Bold="True"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                        

                        <table class="auto-style1">
                            <tr>
                                <td>

                                    <asp:Label ID="Label5" runat="server" Text="Tutor"></asp:Label>
                                    <asp:TextBox ID="cajaTutor" runat="server"></asp:TextBox>
                                    <ajaxToolkit:AutoCompleteExtender 
                                        ID="cajaTutor_AutoCompleteExtender" 
                                        runat="server" 
                                        BehaviorID="cajaTutor_AutoCompleteExtender" 
                                        DelimiterCharacters="" 
                                        ServicePath="" 
                                        TargetControlID="cajaTutor"
                                        
                                        MinimumPrefixLength="1"
                                        CompletionInterval="10"
                                        CompletionSetCount="1"
                                        FirstRowSelected="false"
                                        ServiceMethod="GetNombresTutores">
                                    </ajaxToolkit:AutoCompleteExtender>
                                    <asp:Label ID="Label6" runat="server" Text="Área"></asp:Label>
                                    <asp:DropDownList ID="desplegableArea" runat="server" DataSourceID="AreasSource" DataTextField="Area" DataValueField="Area">
                                    </asp:DropDownList>

                                    <asp:ObjectDataSource ID="AreasSource" runat="server" SelectMethod="GetAreasSrc" TypeName="Buscador"></asp:ObjectDataSource>

                                </td>
                            </tr>
                            <tr>
                                <td>

                                    <asp:Label ID="Label3" runat="server" Text="Calificación"></asp:Label>
                                    <uc1:Estrellas runat="server" ID="Estrellas" />

                                </td>
                            </tr>
                        </table>

                </td>
            </tr>
            <tr>
                <td>
                    
                    <asp:GridView ID="tablaCursos" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="CursosSource" OnRowDataBound="tablaCursos_RowDataBound" AllowPaging="True">
                        <Columns>
                            <asp:BoundField DataField="Area" HeaderText="Área" SortExpression="Area" HtmlEncode="False" >
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Nombre" HeaderText="Curso" SortExpression="Nombre" >
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Creador" HeaderText="Usuario" SortExpression="Creador" >
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha de creación" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}" >
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Puntuacion" HeaderText="Calificación" SortExpression="Puntuacion" >
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                    
                    <asp:ObjectDataSource ID="CursosSource" runat="server" SelectMethod="GetCursos" TypeName="Buscador">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="cajaBuscador" Name="curso" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="cajaTutor" Name="tutor" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="desplegableArea" DefaultValue="Seleccionar" Name="area" PropertyName="SelectedValue" Type="String" />
                            <asp:ControlParameter ControlID="estrellas" Name="puntuacion" PropertyName="Calificacion" Type="Int32" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    
                </td>
            </tr>
        </table>

    <br />
 

</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="head">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
        .auto-style2 {
            width: 231px;
        }
        .auto-style3 {
            width: 21%;
        }
    </style>
</asp:Content>
