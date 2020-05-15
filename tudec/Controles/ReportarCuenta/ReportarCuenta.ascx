<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ReportarCuenta.ascx.cs" Inherits="Controles_ReportarCuenta_ReportarCuenta" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


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
                            <i class="fas fa-ban"></i>
                            <h4 class="text-dark"><strong>Reportar Cuenta</strong></h4>
                        </div>
                        <div class="row justify-content-center">
                            <asp:DropDownList ID="DDL_MotivoReporte" CssClass="form-control" runat="server" DataSourceID="ODS_Motivo" DataTextField="Motivo" DataValueField="Motivo"></asp:DropDownList>
                            <asp:ObjectDataSource ID="ODS_Motivo" runat="server" SelectMethod="getMotivoReporte" TypeName="DaoReporte"></asp:ObjectDataSource>
                        </div>
                        <div class="row justify-content-center">
                            <div class="md-form">
                                <i class="fas fa-pencil-alt prefix"></i>
                                <asp:TextBox ID="TB_Descripcion" runat="server" CssClass="md-textarea form-control" Rows="3"></asp:TextBox>
                                <label for="form10">Descripcion</label>
                            </div>

                        </div>
                        <div class="modal-footer row justify-content-center">
                            <div class="col">
                                <asp:LinkButton ID="btnCerrar" CssClass="btn btn-info btn-block" runat="server" Text="Cancelar" OnClick="btnCerrar_Click">
                                    <i class="fa fa-window-close"></i>
                                </asp:LinkButton>

                            </div>
                            <div class="col">
                                <asp:LinkButton ID="btnEnviar" CssClass="btn btn-success btn-block" runat="server" Text="Actualizar" OnClick="btnEnviar_Click">
                                      <i class="fa fa-share-square"></i>
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Panel>
