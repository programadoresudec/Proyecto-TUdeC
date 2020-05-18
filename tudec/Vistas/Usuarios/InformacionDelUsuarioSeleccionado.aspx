<%@ Page Title="Usuario" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/InformacionDelUsuarioSeleccionado.aspx.cs" Inherits="Vistas_InformacionDelUsuarioSeleccionado" %>

<%@ Register Src="~/Controles/Estrellas/Estrellas.ascx" TagPrefix="uc1" TagName="Estrellas" %>
<%@ Register Src="~/Controles/Estrellas/EstrellasPuntuacion.ascx" TagPrefix="uc1" TagName="EstrellasPuntuacion" %>
<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <br />
    <br />
    <br />
    <br />
    <br />
     <div class="container flex-md-row">
        <asp:HyperLink ID="BtnDevolver" CssClass="btn btn-info" runat="server"
            NavigateUrl="~/Vistas/Buscador/ListaDeResultadosDelBuscadorTutores.aspx" Style="font-size: medium;">
                <i class="fas fa-arrow-alt-circle-left mr-2"></i><strong>Devolver</strong> 
        </asp:HyperLink>
    </div>
    <div class="container-fluid mt-5 mb-5">
        <div class="row justify-content-around">
            <div class="col-lg-3 mb-5">
                <div class="card mt-4">
                    <div class="card-header text-center">
                        <asp:Image ID="imagenUsuario" CssClass="card-img rounded-circle" Style="width: 150px; height: 150px" runat="server" />
                    </div>
                    <div class="card-body text-center">
                        <p>Nombre de usuario:</p>
                        <asp:Label ID="etiquetaNombreUsuario" runat="server" Text="Nombre Usuario"></asp:Label>
                        <p>Nombres: </p>
                        <asp:Label Text="Nombre" runat="server" ID="etiquetaNombre" />
                        <p>Apellidos: </p>
                        <asp:Label Text="Apellido" runat="server" ID="etiquetaApellido" />
                        <p>Calificación:</p>
                        <asp:Panel ID="panelEstrellas" runat="server">
                            <asp:Label Text="Numero de estrellas" runat="server" ID="etiquetaPuntuacion" />
                        </asp:Panel>
                        <p>Descripción:</p>
                        <asp:Label ID="etiquetaDescripcion" runat="server" Text="Espacio para la descripción" />
                    </div>
                </div>
                <div class="card-footer text-center">
                    <asp:Label Text="CALIFICAR:" runat="server" />
                    <uc1:EstrellasPuntuacion runat="server" ID="EstrellasPuntuacion" />
                </div>
            </div>
            <div class="col-lg-auto">
                <h1 class="text-center"><strong>Cursos De <asp:Label ID="LB_NombreDeUsuario" runat="server" Text="Nombre Usuario"></asp:Label></strong></h1>
                <div class="table-responsive">
                    <table class="table">
                        <asp:GridView CssClass="tablas" ID="GridViewUsuSelec" runat="server" AutoGenerateColumns="False" DataSourceID="DatosUsuarioSeleccionadoDataSource" AllowPaging="True" Width="675px" OnRowDataBound="GridViewUsuSelec_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="Area" HeaderText="Área" SortExpression="Area" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Nombre" HeaderText="Curso " SortExpression="Nombre">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha de creación" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Estado" HeaderText="Estado" SortExpression="Estado">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Puntuacion" HeaderText="Puntuación" SortExpression="Puntuacion">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </table>
                </div>
                <asp:ObjectDataSource ID="DatosUsuarioSeleccionadoDataSource" runat="server" SelectMethod="GetCursos" TypeName="DaoUsuario">
                    <SelectParameters>
                        <asp:SessionParameter Name="eUsuario" SessionField="UsuarioSeleccionado" Type="Object" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div>
        </div>
    </div>












</asp:Content>

