<%@ Page Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeResultadosDelBuscadorCursos.aspx.cs" Inherits="ListaDeResultadosDelBuscador" %>

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
                    <asp:Button CssClass="botonPulsado" ID="botonCurso" runat="server" Text="Buscar curso" />
                    <asp:Button  CssClass="botones" ID="botonTutor" runat="server" OnClick="botonTutor_Click" Text="Buscar tutor" />
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
                        

                        <table class="auto-style1">
                            <tr>
                                <td>

                                    <asp:Label ID="Label5" runat="server" Text="Tutor"></asp:Label>
                                    <asp:TextBox ID="cajaTutor" runat="server"></asp:TextBox>
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
                    
                    <asp:GridView ID="tablaCursos" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="CursosSource" OnRowDataBound="tablaCursos_RowCreated">
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