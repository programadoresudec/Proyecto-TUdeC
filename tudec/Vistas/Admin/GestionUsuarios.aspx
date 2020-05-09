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
            <asp:Button ID="btnShowPopup" runat="server" Style="display: none" />

            <cc1:ModalPopupExtender ID="ModalBloquearUsuario" runat="server" TargetControlID="btnShowPopup" PopupControlID="PanelModalBloqueo"
                CancelControlID="btnCerrar" BackgroundCssClass="modal fade modal-lg">
            </cc1:ModalPopupExtender>

            <asp:Panel ID="PanelModalBloqueo" runat="server">
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="modal-body">
                                    <div class="modal-header row justify-content-center">
                                        <h4 class="fa fa-info-circle text-dark"><strong>Reportes</strong></h4>
                                    </div>
                                    <div class="row justify-content-center">
                                        <asp:ListView ID="LV_Reportes" runat="server" DataSourceID="ODS_Reportes">

                                            <AlternatingItemTemplate>
                                                <li style="">Id:
                                                    <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciante:
                                                    <asp:Label ID="NombreDeUsuarioDenuncianteLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciante") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciado:
                                                    <asp:Label ID="NombreDeUsuarioDenunciadoLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciado") %>' />
                                                    <br />
                                                    MotivoDelReporte:
                                                    <asp:Label ID="MotivoDelReporteLabel" runat="server" Text='<%# Eval("MotivoDelReporte") %>' />
                                                    <br />
                                                    IdComentario:
                                                    <asp:Label ID="IdComentarioLabel" runat="server" Text='<%# Eval("IdComentario") %>' />
                                                    <br />
                                                    IdMensaje:
                                                    <asp:Label ID="IdMensajeLabel" runat="server" Text='<%# Eval("IdMensaje") %>' />
                                                    <br />
                                                    Descripcion:
                                                    <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
                                                    <br />
                                                    <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Eval("Estado") %>' Enabled="false" Text="Estado" />
                                                    <br />
                                                    Fecha:
                                                    <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha") %>' />
                                                    <br />
                                                    Comentario:
                                                    <asp:Label ID="ComentarioLabel" runat="server" Text='<%# Eval("Comentario") %>' />
                                                    <br />
                                                    Mensaje:
                                                    <asp:Label ID="MensajeLabel" runat="server" Text='<%# Eval("Mensaje") %>' />
                                                    <br />
                                                    ImagenesComentario:
                                                    <asp:Label ID="ImagenesComentarioLabel" runat="server" Text='<%# Eval("ImagenesComentario") %>' />
                                                    <br />
                                                    ImagenesMensaje:
                                                    <asp:Label ID="ImagenesMensajeLabel" runat="server" Text='<%# Eval("ImagenesMensaje") %>' />
                                                    <br />
                                                    <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
                                                </li>
                                            </AlternatingItemTemplate>
                                            <EditItemTemplate>
                                                <li style="">Id:
                                                    <asp:TextBox ID="IdTextBox" runat="server" Text='<%# Bind("Id") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciante:
                                                    <asp:TextBox ID="NombreDeUsuarioDenuncianteTextBox" runat="server" Text='<%# Bind("NombreDeUsuarioDenunciante") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciado:
                                                    <asp:TextBox ID="NombreDeUsuarioDenunciadoTextBox" runat="server" Text='<%# Bind("NombreDeUsuarioDenunciado") %>' />
                                                    <br />
                                                    MotivoDelReporte:
                                                    <asp:TextBox ID="MotivoDelReporteTextBox" runat="server" Text='<%# Bind("MotivoDelReporte") %>' />
                                                    <br />
                                                    IdComentario:
                                                    <asp:TextBox ID="IdComentarioTextBox" runat="server" Text='<%# Bind("IdComentario") %>' />
                                                    <br />
                                                    IdMensaje:
                                                    <asp:TextBox ID="IdMensajeTextBox" runat="server" Text='<%# Bind("IdMensaje") %>' />
                                                    <br />
                                                    Descripcion:
                                                    <asp:TextBox ID="DescripcionTextBox" runat="server" Text='<%# Bind("Descripcion") %>' />
                                                    <br />
                                                    <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Bind("Estado") %>' Text="Estado" />
                                                    <br />
                                                    Fecha:
                                                    <asp:TextBox ID="FechaTextBox" runat="server" Text='<%# Bind("Fecha") %>' />
                                                    <br />
                                                    Comentario:
                                                    <asp:TextBox ID="ComentarioTextBox" runat="server" Text='<%# Bind("Comentario") %>' />
                                                    <br />
                                                    Mensaje:
                                                    <asp:TextBox ID="MensajeTextBox" runat="server" Text='<%# Bind("Mensaje") %>' />
                                                    <br />
                                                    ImagenesComentario:
                                                    <asp:TextBox ID="ImagenesComentarioTextBox" runat="server" Text='<%# Bind("ImagenesComentario") %>' />
                                                    <br />
                                                    ImagenesMensaje:
                                                    <asp:TextBox ID="ImagenesMensajeTextBox" runat="server" Text='<%# Bind("ImagenesMensaje") %>' />
                                                    <br />
                                                    <asp:Button ID="UpdateButton" runat="server" CommandName="Update"  Text="Update" />
                                                    <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
                                                </li>
                                            </EditItemTemplate>
                                            <EmptyDataTemplate>
                                                No data was returned.
                                            </EmptyDataTemplate>
                                            <InsertItemTemplate>
                                                <li style="">Id:
                                                    <asp:TextBox ID="IdTextBox" runat="server" Text='<%# Bind("Id") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciante:
                                                    <asp:TextBox ID="NombreDeUsuarioDenuncianteTextBox" runat="server" Text='<%# Bind("NombreDeUsuarioDenunciante") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciado:
                                                    <asp:TextBox ID="NombreDeUsuarioDenunciadoTextBox" runat="server" Text='<%# Bind("NombreDeUsuarioDenunciado") %>' />
                                                    <br />
                                                    MotivoDelReporte:
                                                    <asp:TextBox ID="MotivoDelReporteTextBox" runat="server" Text='<%# Bind("MotivoDelReporte") %>' />
                                                    <br />
                                                    IdComentario:
                                                    <asp:TextBox ID="IdComentarioTextBox" runat="server" Text='<%# Bind("IdComentario") %>' />
                                                    <br />
                                                    IdMensaje:
                                                    <asp:TextBox ID="IdMensajeTextBox" runat="server" Text='<%# Bind("IdMensaje") %>' />
                                                    <br />
                                                    Descripcion:
                                                    <asp:TextBox ID="DescripcionTextBox" runat="server" Text='<%# Bind("Descripcion") %>' />
                                                    <br />
                                                    <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Bind("Estado") %>' Text="Estado" />
                                                    <br />
                                                    Fecha:
                                                    <asp:TextBox ID="FechaTextBox" runat="server" Text='<%# Bind("Fecha") %>' />
                                                    <br />
                                                    Comentario:
                                                    <asp:TextBox ID="ComentarioTextBox" runat="server" Text='<%# Bind("Comentario") %>' />
                                                    <br />
                                                    Mensaje:
                                                    <asp:TextBox ID="MensajeTextBox" runat="server" Text='<%# Bind("Mensaje") %>' />
                                                    <br />
                                                    ImagenesComentario:
                                                    <asp:TextBox ID="ImagenesComentarioTextBox" runat="server" Text='<%# Bind("ImagenesComentario") %>' />
                                                    <br />
                                                    ImagenesMensaje:
                                                    <asp:TextBox ID="ImagenesMensajeTextBox" runat="server" Text='<%# Bind("ImagenesMensaje") %>' />
                                                    <br />
                                                    <asp:Button ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" />
                                                    <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Clear" />
                                                </li>
                                            </InsertItemTemplate>
                                            <ItemSeparatorTemplate>
                                                <br />
                                            </ItemSeparatorTemplate>
                                            <ItemTemplate>
                                                <li style="">Id:
                                                    <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciante:
                                                    <asp:Label ID="NombreDeUsuarioDenuncianteLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciante") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciado:
                                                    <asp:Label ID="NombreDeUsuarioDenunciadoLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciado") %>' />
                                                    <br />
                                                    MotivoDelReporte:
                                                    <asp:Label ID="MotivoDelReporteLabel" runat="server" Text='<%# Eval("MotivoDelReporte") %>' />
                                                    <br />
                                                    IdComentario:
                                                    <asp:Label ID="IdComentarioLabel" runat="server" Text='<%# Eval("IdComentario") %>' />
                                                    <br />
                                                    IdMensaje:
                                                    <asp:Label ID="IdMensajeLabel" runat="server" Text='<%# Eval("IdMensaje") %>' />
                                                    <br />
                                                    Descripcion:
                                                    <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
                                                    <br />
                                                    <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Eval("Estado") %>' Enabled="false" Text="Estado" />
                                                    <br />
                                                    Fecha:
                                                    <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha") %>' />
                                                    <br />
                                                    Comentario:
                                                    <asp:Label ID="ComentarioLabel" runat="server" Text='<%# Eval("Comentario") %>' />
                                                    <br />
                                                    Mensaje:
                                                    <asp:Label ID="MensajeLabel" runat="server" Text='<%# Eval("Mensaje") %>' />
                                                    <br />
                                                    ImagenesComentario:
                                                    <asp:Label ID="ImagenesComentarioLabel" runat="server" Text='<%# Eval("ImagenesComentario") %>' />
                                                    <br />
                                                    ImagenesMensaje:
                                                    <asp:Label ID="ImagenesMensajeLabel" runat="server" Text='<%# Eval("ImagenesMensaje") %>' />
                                                    <br />
                                                    <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
                                                </li>
                                            </ItemTemplate>
                                            <LayoutTemplate>
                                                <ul id="itemPlaceholderContainer" runat="server" style="">
                                                    <li runat="server" id="itemPlaceholder" />
                                                </ul>
                                                <div style="">
                                                    <asp:DataPager ID="DataPager1" runat="server">
                                                        <Fields>
                                                            <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="False" />
                                                            <asp:NumericPagerField />
                                                            <asp:NextPreviousPagerField ButtonType="Button" ShowLastPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="False" />
                                                        </Fields>
                                                    </asp:DataPager>
                                                </div>
                                            </LayoutTemplate>
                                            <SelectedItemTemplate>
                                                <li style="">Id:
                                                    <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciante:
                                                    <asp:Label ID="NombreDeUsuarioDenuncianteLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciante") %>' />
                                                    <br />
                                                    NombreDeUsuarioDenunciado:
                                                    <asp:Label ID="NombreDeUsuarioDenunciadoLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciado") %>' />
                                                    <br />
                                                    MotivoDelReporte:
                                                    <asp:Label ID="MotivoDelReporteLabel" runat="server" Text='<%# Eval("MotivoDelReporte") %>' />
                                                    <br />
                                                    IdComentario:
                                                    <asp:Label ID="IdComentarioLabel" runat="server" Text='<%# Eval("IdComentario") %>' />
                                                    <br />
                                                    IdMensaje:
                                                    <asp:Label ID="IdMensajeLabel" runat="server" Text='<%# Eval("IdMensaje") %>' />
                                                    <br />
                                                    Descripcion:
                                                    <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
                                                    <br />
                                                    <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Eval("Estado") %>' Enabled="false" Text="Estado" />
                                                    <br />
                                                    Fecha:
                                                    <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha") %>' />
                                                    <br />
                                                    Comentario:
                                                    <asp:Label ID="ComentarioLabel" runat="server" Text='<%# Eval("Comentario") %>' />
                                                    <br />
                                                    Mensaje:
                                                    <asp:Label ID="MensajeLabel" runat="server" Text='<%# Eval("Mensaje") %>' />
                                                    <br />
                                                    ImagenesComentario:
                                                    <asp:Label ID="ImagenesComentarioLabel" runat="server" Text='<%# Eval("ImagenesComentario") %>' />
                                                    <br />
                                                    ImagenesMensaje:
                                                    <asp:Label ID="ImagenesMensajeLabel" runat="server" Text='<%# Eval("ImagenesMensaje") %>' />
                                                    <br />
                                                    <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
                                                </li>
                                            </SelectedItemTemplate>

                                        </asp:ListView>
                                        <asp:ObjectDataSource ID="ODS_Reportes" runat="server" DataObjectTypeName="EReporte" SelectMethod="reportesDelUsuario" TypeName="DaoReporte" UpdateMethod="bloquearUsuario">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="nombreDeUsuarioDenunciado" SessionField="usuarioConReportes" Type="String" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                    </div>
                                    <div class="modal-footer row justify-content-center">
                                        <asp:Button ID="btnCerrar" CssClass="btn btn-danger" runat="server" Text="Cancelar" OnClick="btnCerrar_Click" />
                                        <asp:Button ID="btnActualizar" CssClass="btn btn-info" runat="server" Text="Actualizar" OnClick="btnActualizar_Click" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
        </div>
    </div>
</asp:Content>


