<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ComentarioExistente.ascx.cs" Inherits="Controles_Comentarios_ComentarioExistente" %>
<%@ Register Src="~/Controles/Comentarios/NuevoComentario.ascx" TagPrefix="uc1" TagName="NuevoComentario" %>




<div class="row justify-content-center">

    <table style="width: 90%">

        <tr>

            <td>

                <asp:Label ID="etiquetaUsuario" runat="server" Text="Usuario"></asp:Label>

            </td>

        </tr>
        <tr>

            <td >

                <asp:TextBox ID="cajaComentarios" runat="server" TextMode="MultiLine" style="width:100%; height:150px" Enabled="false"></asp:TextBox>

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
    
 
