<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Chat.aspx.cs" Inherits="Vistas_Chat_Chat" %>

<%@ Register Src="~/Controles/Chat/Mensaje.ascx" TagPrefix="uc1" TagName="Mensaje" %>
<%@ Register Src="~/Controles/InterfazSubirImagen/InterfazSubirImagen.ascx" TagPrefix="uc1" TagName="InterfazSubirImagen" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 90%;
        }
    </style>
    <script>
        function bajarBarrita() {
            var panel = <%=panelMensajes.ClientID%>;
            panel.scrollTop = panel.scrollHeight;
        }
        window.onload = function () {
            bajarBarrita();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <asp:Panel ID="panelModal" runat="server" Width="0px" Height="0px"></asp:Panel>
    <br />
    <br />
    <br />
    <br />
    <br />
    <div class="container flex-md-row">
        <asp:HyperLink ID="Hyperlink_Devolver" CssClass="btn btn-info" runat="server" Style="font-size: medium;">
                      <i class="fas fa-arrow-alt-circle-left fa-lg"></i>
        </asp:HyperLink>
    </div>
    <div class="container-fluid">
        <div class="row justify-content-center">
            <table class="auto-style1">
                <tr>
                    <td>
                        <asp:Table ID="Table2" Width="100%" runat="server">
                            <asp:TableRow>
                                <asp:TableCell Width="20%">
                                </asp:TableCell>
                                <asp:TableCell Width="79%">
                                    <div class="row justify-content-center">
                                        <asp:Label ID="etiquetaCurso" CssClass="text-center" runat="server" Text="Nombre del curso"></asp:Label>
                                    </div>
                                </asp:TableCell>
                            </asp:TableRow>
                            <asp:TableRow>
                                <asp:TableCell Width="20%">
                                </asp:TableCell>
                                <asp:TableCell Width="79%">
                                    <div class="row justify-content-center">
                                        <asp:Image ID="imagenPerfil" CssClass="card-img rounded-circle" runat="server" Width="64" Height="64"></asp:Image>
                                        <asp:Label ID="etiquetaNombre" runat="server" Text="Nombre del usuario"></asp:Label>
                                    </div>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Table Width="100%" ID="Table1" runat="server">
                            <asp:TableRow>
                                <asp:TableCell Width="20%">
                                    <asp:Panel ID="panelChats" runat="server" Width="100%" Height="400" ScrollBars="Vertical"></asp:Panel>
                                </asp:TableCell>
                                <asp:TableCell Width="79%">
                                    <asp:UpdatePanel ID="panelActualizarTabla" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Panel ID="panelMensajes" runat="server" Width="100%" Height="400" ScrollBars="Vertical"></asp:Panel>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <asp:UpdatePanel ID="panelActualizar" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="temporizador" EventName="Tick" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <asp:Timer ID="temporizador" OnTick="temporizador_Tick" Interval="3000" runat="server"></asp:Timer>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <br />
                        <div class="row justify-content-center mt-5 mb-3">
                            <div class="justify-content-center input-group mb-3">
                                <div class="input-group-append">
                                    <div class="col-lg-auto mb-3">
                                        <asp:ImageButton Height="50px" ID="botonEnviarImagen" runat="server" ImageUrl="~/Recursos/Imagenes/Chat/upload/uploadImage.png" OnClick="botonEnviarImagen_Click" />
                                    </div>
                                </div>
                                <div class="col-lg-10 mb-3">
                                    <asp:TextBox Height="50px" Width="100%" ID="cajaMensaje" placeHolder="Escriba su mensaje" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                                <div class="input-group-append">
                                    <div class="col-lg-auto mb-3">
                                        <asp:LinkButton CssClass="btn btn-info btn-lg btn-block" ID="botonEnviar" runat="server" OnClick="botonEnviar_Click">
                                        Enviar<i class="ml-2 fa fa-paper-plane"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>
            </table>
        </div>
    </div>
</asp:Content>

