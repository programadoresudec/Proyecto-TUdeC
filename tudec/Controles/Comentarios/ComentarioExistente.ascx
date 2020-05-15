<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ComentarioExistente.ascx.cs" Inherits="Controles_Comentarios_ComentarioExistente" %>
<%@ Register Src="~/Controles/Comentarios/NuevoComentario.ascx" TagPrefix="uc1" TagName="NuevoComentario" %>
<%@ Register Src="~/Controles/ReportarCuenta/ReportarCuenta.ascx" TagPrefix="uc1" TagName="ReportarCuenta" %>

<div class="row justify-content-center">
    <div class="row justify-content-end">
        <div class="col-md-4">
            <uc1:ReportarCuenta runat="server" ID="ReportarCuenta" />
        </div>
    </div>
    <table style="width: 90%">

        <tr>

            <td>

                <asp:Label ID="etiquetaUsuario" runat="server" Text="Usuario"></asp:Label>

            </td>

        </tr>
        <tr>

            <td>

                <asp:TextBox ID="cajaComentarios" runat="server" TextMode="MultiLine" Style="width: 100%; height: 150px" Enabled="false"></asp:TextBox>

            </td>

        </tr>
        <tr>

            <td>
                <asp:Panel ID="panelOpcion" runat="server"></asp:Panel>
            </td>
        </tr>

        <tr>

            <td>

                <asp:Panel ID="panelHilo" runat="server"></asp:Panel>

            </td>

        </tr>

    </table>


</div>


