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
                            <asp:BoundField DataField="FechaDesbloqueo" HeaderText="Fecha de desbloqueo" SortExpression="FechaDesbloqueo" />
                            <asp:BoundField DataField="NumCursos" HeaderText="# de Cursos" SortExpression="NumCursos">
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
            <asp:Button ID="btnShowPopup" runat="server" Style="display: none" />

            <cc1:ModalPopupExtender ID="ModalBloquearUsuario" runat="server" TargetControlID="btnShowPopup" PopupControlID="PanelModalBloqueo"
                CancelControlID="btnCerrar" BackgroundCssClass="modal fade modal-lg">
            </cc1:ModalPopupExtender>

            <asp:Panel ID="PanelModalBloqueo" runat="server">
                <div class="modal-dialog modal-lg" role="dialog">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="modal-header">
                                <h4 class="modal-title" style="color: black">Bloquear Usuario</h4>
                            </div>
                            <div class="row justify-content-center">
                                <div class="col-4">
                                </div>
                                <div class="col-6">
                                    <a class="btn btn-primary" data-toggle="collapse" href="#multiCollapseExample1" role="button" aria-expanded="false"
                                        aria-controls="multiCollapseExample1"></a>
                                    <div class="collapse multi-collapse" id="multiCollapseExample1">
                                        <div class="card card-body">
                                            <asp:TextBox runat="server" />
                                        </div>
                                    </div>
                                    <asp:GridView ID="DataListReportes" OnItemCommand="DataListReportes_ItemCommand" runat="server" DataSourceID="ODS_reportes" AutoGenerateColumns="False" AllowPaging="True" PageSize="2">

                                        <Columns>
                                            <asp:TemplateField></asp:TemplateField>
                                            <asp:BoundField DataField="NombreDeUsuarioDenunciante" HeaderText="NombreDeUsuarioDenunciante" SortExpression="NombreDeUsuarioDenunciante" />
                                            <asp:BoundField DataField="MotivoDelReporte" HeaderText="MotivoDelReporte" SortExpression="MotivoDelReporte" />
                                            <asp:BoundField DataField="Descripcion" HeaderText="Descripcion" SortExpression="Descripcion" />
                                            <asp:BoundField DataField="Fecha" HeaderText="Fecha" SortExpression="Fecha" />
                                            <asp:BoundField DataField="Comentario" ControlStyle-CssClass="collapse multi-collapse" HeaderText="Comentario" SortExpression="Comentario" />
                                            <asp:BoundField DataField="Mensaje" HeaderText="Mensaje" SortExpression="Mensaje" />
                                        </Columns>

                                    </asp:GridView>
                                    <asp:ObjectDataSource ID="ODS_reportes" runat="server" SelectMethod="reportesDelUsuario" TypeName="DaoReporte">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="nombreDeUsuarioDenunciado" SessionField="usuarioConReportes" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                </div>
                                <div class="col-2">
                                </div>
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

