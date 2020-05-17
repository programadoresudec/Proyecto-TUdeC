<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ComentarioExistente.ascx.cs" Inherits="Controles_Comentarios_ComentarioExistente" %>
<%@ Register Src="~/Controles/Comentarios/NuevoComentario.ascx" TagPrefix="uc1" TagName="NuevoComentario" %>
<%@ Register Src="~/Controles/ReportarCuenta/ReportarCuenta.ascx" TagPrefix="uc1" TagName="ReportarCuenta" %>
<link rel="stylesheet" href="~/App_Themes/Master/css/bootstrap.css" type="text/css" media="all" />

<div class="container mb-4">
    <div class="form-group row justify-content-center">
        <div class="col-md-6 text-center mb-4">
            <div class="card">
                <div class="card-header">
                    <strong><asp:Label ID="etiquetaUsuario" runat="server" Text="Usuario"></asp:Label></strong>
                    <uc1:ReportarCuenta runat="server" ID="ReportarCuenta" />
                </div>
                <div class="card-footer">
                    <asp:TextBox ID="cajaComentarios" runat="server" TextMode="MultiLine" Enabled="false"></asp:TextBox>
                    <asp:Panel ID="panelOpcion" runat="server"></asp:Panel>
                    <asp:Panel ID="panelHilo" runat="server"></asp:Panel>
                </div>
            </div>
        </div>   
    </div>
</div>



