<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/GestionUsuarios.aspx.cs" Inherits="Vistas_Admin_GestionUsuarios" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <div class="container">
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <ajaxToolkit:AutoCompleteExtender
            MinimumPrefixLength="1"
            CompletionInterval="10"
            CompletionSetCount="1"
            FirstRowSelected="false"
            ID="cajaBuscador_AutoCompleteExtender"
            runat="server"
            ServiceMethod="GetNombreUsuario"
            TargetControlID="cajaBuscador">
        </ajaxToolkit:AutoCompleteExtender>
        <div class="form-group row justify-content-center">
            <h1>Gestión De Usuarios</h1>
        </div>
        <div class="form-group row justify-content-center">
            <div class="form-group col-md-auto">
                <div class="input-group mb-3">
                    <asp:TextBox AutoPostBack="true" ID="cajaBuscador" CssClass="form-control" runat="server" placeHolder="Texto de Busqueda" Width="200px">
                    </asp:TextBox>
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <asp:LinkButton ID="botonBuscar" runat="server">
							<i class="fa fa-search"></i></asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group col-md-auto">
                <asp:DropDownList ID="DDL_Estado" runat="server" DataTextField="Estado" placeHolder="Estado" CssClass="form-control" DataSourceID="ODS_EstadosUsuario" DataValueField="Estado">
                </asp:DropDownList>
                <asp:ObjectDataSource ID="ODS_EstadosUsuario" runat="server" SelectMethod="obtenerEstadosUsuario" TypeName="DaoUsuario"></asp:ObjectDataSource>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <asp:GridView ID="GridViewGestionUsuario" runat="server" CssClass="tablas" AutoGenerateColumns="False" AllowPaging="True" HorizontalAlign="Center" DataSourceID="ODS_DaoUsuario">
                        <Columns>
                            <asp:ImageField DataImageUrlField="ImagenPerfil" ControlStyle-Width="30%" HeaderText="Imagen de perfil" SortExpression="ImagenPerfil">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:ImageField>
                            <asp:BoundField DataField="NombreDeUsuario" HeaderText="Nombre De Usuario" SortExpression="NombreDeUsuario">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Estado" HeaderText="Estado" SortExpression="Estado">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha De Registro" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="NumCursos" HeaderText="# de Cursos" SortExpression="NumCursos">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Bloquear">
                                <ItemTemplate>
                                    <asp:LinkButton ID="botonBloquearUsuario" runat="server" OnClick="botonBloquearUsuario_Click"
                                        CssClass="fas fa-user-lock" Style="color: red"></asp:LinkButton>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Ver Reportes">
                                <ItemTemplate>
                                    <asp:LinkButton ID="botonVerReportes" runat="server" OnClick="botonVerReportes_Click"
                                        CssClass="btn btn-default"><i class="fa fa-eye" style="color:darkgreen"></i></asp:LinkButton>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="ODS_DaoUsuario" runat="server" SelectMethod="gestionDeUsuarioAdmin" TypeName="DaoUsuario"></asp:ObjectDataSource>
                </table>
            </div>
            <asp:Button ID="btnShowPopup" runat="server" Style="display: none" />

            <cc1:ModalPopupExtender ID="ModalBloquearUsuario" runat="server" TargetControlID="btnShowPopup" PopupControlID="PanelModalBloqueo"
                CancelControlID="btnCerrar"  BackgroundCssClass="modal fade" >
            </cc1:ModalPopupExtender>

            <asp:Panel ID="PanelModalBloqueo" runat="server">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="modal-header">
                                <h4 class="modal-title" style="color:black">Bloquear Usuario</h4>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="btnActualizar" CssClass="btn btn-primary" runat="server" Text="Actualizar" OnClick="btnActualizar_Click" />
                                <asp:Button ID="btnCerrar" CssClass="btn btn-secondary" runat="server" Text="Cancelar" />
                            </div>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>

