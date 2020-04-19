<%@ Title="Búsqueda Tutores" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeResultadosDelBuscadorTutores.aspx.cs" Inherits="Vistas_ListaDeResultadosDelBuscadorTutores" %>

<%@ Register Src="~/Controles/Estrellas/Estrellas.ascx" TagPrefix="uc1" TagName="Estrellas" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" Runat="Server">

    <link href="../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

        <br />
    <br />
    <br />
    <br />
    <br />

         <table class="auto-style1">
            <tr>
                
                <td>
                    <asp:Button CssClass="botones" ID="botonCurso" runat="server" Text="Buscar curso" OnClick="botonCurso_Click" />
                    <asp:Button CssClass="botonPulsado" ID="botonTutor" runat="server" Text="Buscar tutor" />
                </td>
            </tr>
            <tr>
                <td>
                    <table class="auto-style3">
                        <tr>
                            <td class="auto-style2">
                    <asp:TextBox ID="cajaBuscador" runat="server" placeHolder="Buscar tutor" Height="24px" Width="218px" OnTextChanged="cajaBuscador_TextChanged"></asp:TextBox>
                            </td>
                            <td>
                    <asp:ImageButton ID="botonBuscar" runat="server" ImageUrl="~/Recursos/Imagenes/Busqueda/Lupa.png" Width="30px" />
                            </td>
                        </tr>
                    </table>
                    <ajaxToolkit:AutoCompleteExtender 
                        ID="cajaBuscador_AutoCompleteExtender" 
                        runat="server" 
                        BehaviorID="cajaBuscador_AutoCompleteExtender" 
                        DelimiterCharacters="" 
                        ServicePath="" 
                        TargetControlID="cajaBuscador"
                        
                        MinimumPrefixLength="1"
                        CompletionInterval="10"
                        CompletionSetCount="1"
                        FirstRowSelected="false"
                        ServiceMethod="GetNombresTutores">
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
                 
                        
                    <table>   
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
                    
                        <asp:GridView ID="tablaTutores" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="TutoresSource" OnRowDataBound="tablaTutores_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="ImagenPerfil" HeaderText="Imagen de<br/>la cuenta" HtmlEncode="false" SortExpression="ImagenPerfil" >
                                <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NombreDeUsuario" HeaderText="Nombre del tutor" SortExpression="NombreDeUsuario" >
                                <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NumCursos" HeaderText="N° cursos" SortExpression="NumCursos" >
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
                    
                        <asp:ObjectDataSource ID="TutoresSource" runat="server" SelectMethod="GetTutores" TypeName="Buscador">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="cajaBuscador" Name="tutor" PropertyName="Text" Type="String" />
                                <asp:ControlParameter ControlID="estrellas" Name="puntuacion" PropertyName="Calificacion" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    
                </td>
            </tr>
        </table>

</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="head">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
        .auto-style2 {
            width: 233px;
        }
        .auto-style3 {
            width: 21%;
        }
    </style>
</asp:Content>
