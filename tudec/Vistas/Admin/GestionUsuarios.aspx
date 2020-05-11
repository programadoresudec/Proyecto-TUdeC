<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/GestionUsuarios.aspx.cs" Inherits="Vistas_Admin_GestionUsuarios" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <div class="container">
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />

        <div class="form-group row justify-content-center">
            <h1>Gestión De Usuarios</h1>
        </div>
        <div class="form-group row justify-content-center">
            <div class="form-group col-md-auto">
                <div class="input-group mb-3">
                    <asp:TextBox  ID="cajaBuscador" AutoPostBack="true" CssClass="form-control" runat="server" placeHolder="Buscar Usuario" Width="200px">
                    </asp:TextBox>
                   <ajaxToolkit:AutoCompleteExtender
                       runat="server" ID="cajaBuscador_AutoCompleteExtender"
                       ServiceMethod="GetNombreUsuario"
                       MinimumPrefixLength="1"
                       CompletionInterval="10"
                       EnableCaching="false"
                        CompletionSetCount="1"
                        FirstRowSelected="false"
                        TargetControlID="cajaBuscador">
                   </ajaxToolkit:AutoCompleteExtender> 
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <asp:LinkButton ID="botonBuscar" runat="server">
							<i class="fa fa-search"></i></asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <asp:GridView ID="GridViewGestionUsuario" runat="server" CssClass="tablas" AutoGenerateColumns="False" AllowPaging="True" HorizontalAlign="Center" DataSourceID="ODS_DaoUsuario">
                        <Columns>
                            <asp:ImageField DataImageUrlField="ImagenPerfil" ControlStyle-Width="70px" ControlStyle-Height="70px" ControlStyle-CssClass="card-img rounded-circle" HeaderText="Imagen de perfil" SortExpression="ImagenPerfil">

                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:ImageField>
                            <asp:BoundField DataField="NombreDeUsuario" HeaderText="Nombre De Usuario" SortExpression="NombreDeUsuario">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>

                            <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha De Registro" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FechaDesbloqueo" HeaderText="Fecha de desbloqueo" SortExpression="FechaDesbloqueo">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="NumeroDeReportes" HeaderText="# de Reportes" SortExpression="NumeroDeReportes">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="NumCursos" HeaderText="# de Cursos" SortExpression="NumCursos">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="PuntuacionDeBloqueo" HeaderText="# de Puntos Para Bloquear Cuenta" SortExpression="PuntuacionDeBloqueo">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Ver Reportes">
                                <ItemTemplate>
                                    <asp:LinkButton ID="botonVerReportes" runat="server"
                                        OnClick="botonVerReportes_Click" CssClass="fa fa-eye" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="ODS_DaoUsuario" runat="server" SelectMethod="gestionDeUsuarioAdmin" TypeName="DaoUsuario"></asp:ObjectDataSource>
                </table>
            </div>
        </div>
    </div>
</asp:Content>


