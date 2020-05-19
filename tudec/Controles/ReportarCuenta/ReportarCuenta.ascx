<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ReportarCuenta.ascx.cs" Inherits="Controles_ReportarCuenta_ReportarCuenta" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:LinkButton ID="BtnMostrarModal" CssClass="btn btn-danger" runat="server"><i class="fas fa-ban mr-2"></i>Reportar</asp:LinkButton>
<cc1:ModalPopupExtender ID="ModalBloquearUsuario" runat="server" TargetControlID="BtnMostrarModal" PopupControlID="PanelModalBloqueo"
    CancelControlID="btnCerrar" BackgroundCssClass="modalBackground">
</cc1:ModalPopupExtender>
<asp:Panel ID="PanelModalBloqueo" runat="server" Style="display: none">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="modal-header text-center">
                            <i class="fas fa-ban fa-2x"><strong>Reportar Cuenta</strong></i>
                        </div>
                        <div class="modal-header text-center">
                            <asp:Label ID="LB_validar" Visible="false" runat="server" />
                        </div>
                        <div class="row justify-content-center">
                            <div class="col">
                                <asp:DropDownList ID="DDL_MotivoReporte" CssClass="form-control" runat="server" DataSourceID="ODS_Motivo" DataTextField="Motivo" DataValueField="Motivo"></asp:DropDownList>
                                <asp:ObjectDataSource ID="ODS_Motivo" runat="server" SelectMethod="getMotivoReporte" TypeName="DaoReporte"></asp:ObjectDataSource>
                            </div>
                        </div>
                        <div class="row justify-content-center mt-4">
                            <div class="col">
                                <i class="fas fa-pencil-alt prefix mr-2">Descripción Detallada</i>
                                <br />
                                <asp:TextBox ID="TB_Descripcion" runat="server" Height="150px" TextMode="MultiLine" CssClass="form-control"></asp:TextBox>

                            </div>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <asp:LinkButton ID="btnCerrar" CssClass="btn btn-info btn-block" runat="server" OnClick="btnCerrar_Click">
                                    <strong>Cerrar</strong><i class="fa fa-window-close ml-2"></i>
                        </asp:LinkButton>

                        <asp:LinkButton ID="btnEnviar" CssClass="btn btn-success btn-block" runat="server" OnClick="btnEnviar_Click">
                                     <strong>Enviar</strong><i class="fa fa-share-square ml-2"></i>
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Panel>

