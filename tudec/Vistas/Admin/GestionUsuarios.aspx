<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/GestionUsuarios.aspx.cs" Inherits="Vistas_Admin_GestionUsuarios" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <br />
    <br />
    <div class="container mt-5">
        <div class="row justify-content-center mt-5">
            <h1 class="w3l_header text-center mb-4 mt-5"><strong>Gestión De Usuarios</strong></h1>
        </div>
        <div class="form-row justify-content-center">
            <div class="col-mb-6 text-center mb-4">
                <div class="input-group">
                    <asp:TextBox ID="cajaBuscador" CssClass="fa fa-search form-control" runat="server" placeHolder="Nombre De Usuario" Width="200px" Height="38px">
                        </asp:TextBox>
                    <ajaxToolkit:AutoCompleteExtender
                        MinimumPrefixLength="1"
                        CompletionInterval="10"
                        CompletionSetCount="1"
                        FirstRowSelected="false"
                        ID="cajaBuscador_AutoCompleteExtender"
                        runat="server"
                        ServiceMethod="GetNombreUsuario"
                        TargetControlID="cajaBuscador" />
                    <div class="input-group-append">
                        <asp:LinkButton CssClass="btn btn-info" runat="server"> <i class="fa fa-search"></i></asp:LinkButton>
                    </div>
                </div>
            </div>
            <div class="col-mb-6">
                <asp:DropDownList ID="DDL_Estado" runat="server" DataTextField="Estado" OnSelectedIndexChanged="DDL_Estado_SelectedIndexChanged" AutoPostBack="True" CssClass="fa fa-filter form-control" DataSourceID="ODS_EstadosUsuario" DataValueField="Estado">
                </asp:DropDownList>
                <asp:ObjectDataSource ID="ODS_EstadosUsuario" runat="server" SelectMethod="obtenerEstadosUsuario" TypeName="DaoUsuario"></asp:ObjectDataSource>
            </div>
        </div>
        <div class="row justify-content-center">
            <div class="table-responsive">
                <table class="table">
                    <asp:GridView ID="GridViewGestionUsuario" runat="server" PagerStyle-HorizontalAlign="Center" HorizontalAlign="Center" CssClass="tablas" AutoGenerateColumns="False" AllowPaging="True" DataSourceID="ODS_DaoUsuario">
                        <Columns>
                            <asp:ImageField DataImageUrlField="ImagenPerfil" ControlStyle-Width="70px" ControlStyle-Height="70px" ControlStyle-CssClass="card-img rounded-circle" HeaderText="Imagen de perfil" SortExpression="ImagenPerfil">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:ImageField>
                            <asp:BoundField DataField="NombreDeUsuario" HeaderText="Nombre De Usuario" SortExpression="NombreDeUsuario">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Estado" HeaderText="Estado Del Usuario" SortExpression="Estado">
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
                                        OnClick="botonVerReportes_Click" CssClass="fa fa-eye fa-lg" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="ODS_DaoUsuario" runat="server" SelectMethod="gestionDeUsuarioAdmin" TypeName="DaoUsuario">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="cajaBuscador" Name="nombre" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="DDL_Estado" DefaultValue="Estado" Name="estado" PropertyName="SelectedValue" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </table>
            </div>
        </div>
    </div>
</asp:Content>


