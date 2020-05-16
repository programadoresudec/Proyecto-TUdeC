<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ComentarioExistente.ascx.cs" Inherits="Controles_Comentarios_ComentarioExistente" %>
<%@ Register Src="~/Controles/Comentarios/NuevoComentario.ascx" TagPrefix="uc1" TagName="NuevoComentario" %>
<%@ Register Src="~/Controles/ReportarCuenta/ReportarCuenta.ascx" TagPrefix="uc1" TagName="ReportarCuenta" %>
<link rel="stylesheet" href="~/App_Themes/Master/css/bootstrap.css" type="text/css" media="all" />

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card mt-5">
            <div class="card-header">
                <div class="row justify-content-between">
                    <div class="col">
                        <asp:Label ID="etiquetaUsuario" runat="server" Text="Usuario"></asp:Label>

                    </div>
                    <div class="col">
                        <uc1:ReportarCuenta runat="server" ID="ReportarCuenta" />
                    </div>
                </div>
            </div>
            <div class="card-body">
                <asp:TextBox ID="cajaComentarios" runat="server" TextMode="MultiLine" CssClass="form-control" Enabled="false"></asp:TextBox>
                <asp:Panel ID="panelOpcion" runat="server"></asp:Panel>
                <asp:Panel ID="panelHilo" runat="server"></asp:Panel>
            </div>
        </div>
    </div>
</div>


