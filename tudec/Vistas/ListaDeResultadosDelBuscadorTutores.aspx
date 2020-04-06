<%@ Page Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeResultadosDelBuscadorTutores.aspx.cs" Inherits="Vistas_ListaDeResultadosDelBuscadorTutores" %>

<%@ Register Src="~/Controles/Estrellas/Estrellas.ascx" TagPrefix="uc1" TagName="Estrellas" %>

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
                    <asp:TextBox ID="cajaBuscador" runat="server"></asp:TextBox>
                    <asp:Button ID="botonBuscar" runat="server" OnClick="botonBuscar_Click" Text="Buscar" />
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
                    
                        <asp:GridView ID="tablaTutores" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="TutoresSource" OnRowDataBound="tablaTutores_RowCreated">
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