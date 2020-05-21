<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ComentarioExistente.ascx.cs" Inherits="Controles_Comentarios_ComentarioExistente" %>
<%@ Register Src="~/Controles/Comentarios/NuevoComentario.ascx" TagPrefix="uc1" TagName="NuevoComentario" %>
<%@ Register Src="~/Controles/ReportarCuenta/ReportarCuenta.ascx" TagPrefix="uc1" TagName="ReportarCuenta" %>

<div class="container">
    <div class="row justify-content-center mt-4">
        <div class="col-lg-8 text-center mb-4">
            <div class="card">
                <div class="card-header">
                    <asp:Image ID="imagenUsuario" Width="32" Height="32" runat="server" />
                    <strong>
                        <asp:Label ID="etiquetaUsuario" runat="server" Text="Usuario"></asp:Label>
                        <asp:Label ID="etiquetaFecha" runat="server" Text="<br>Fecha de envío: "></asp:Label>
                    </strong>
                    <uc1:ReportarCuenta runat="server" ID="ReportarCuenta" />
                </div>
                <div class="card-header">
                    <asp:TextBox ID="cajaComentarios" runat="server" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                    <asp:Panel ID="panelOpcion" runat="server"></asp:Panel>
                    <asp:Panel Width="100%" ID="panelHilo" runat="server"></asp:Panel>
                </div>
            </div>
        </div>
    </div>
</div>



