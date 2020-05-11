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
                           <i class="fas fa-ban"></i> <h4 class="text-dark"><strong>Reportar Cuenta</strong></h4>
                        </div>
                        <div class="row justify-content-center">
                        </div>
                        <div class="modal-footer row justify-content-center">
                            <asp:Button ID="btnCerrar" CssClass="btn btn-info" runat="server" Text="Cancelar"  OnClick="btnCerrar_Click" />
                            <asp:LinkButton ID="btnEnviar" CssClass="btn btn" runat="server" Text="Actualizar" OnClick="btnEnviar_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Panel>
