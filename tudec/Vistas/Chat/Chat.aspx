<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Chat.aspx.cs" Inherits="Vistas_Chat_Chat" %>

<%@ Register Src="~/Controles/Chat/Mensaje.ascx" TagPrefix="uc1" TagName="Mensaje" %>
<%@ Register Src="~/Controles/InterfazSubirImagen/InterfazSubirImagen.ascx" TagPrefix="uc1" TagName="InterfazSubirImagen" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
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


<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">

    <asp:Panel ID="panelModal" runat="server" Width="0px" Height="0px"></asp:Panel>

    <br />
<br />
<br />
<br />
<br />




    <table class="auto-style1">
        <tr>
            <td>

         
                    <table class="auto-style1">
                        <tr>
                            <td>
                                <center>
                                    <asp:Label ID="etiquetaCurso" runat="server" Text="Nombre del curso"></asp:Label>
                                </center>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <center>

                                    <asp:Label ID="etiquetaNombre" runat="server" Text="Nombre del usuario"></asp:Label>

                                </center>
                            </td>
                        </tr>
                    </table>

            </td>
        </tr>
        <tr>
            <td>

                <table class="auto-style1">
                    <tr>
                        <td style="width: 20%">

                            <asp:Panel ID="panelChats" runat="server" Width="100%" Height="500"></asp:Panel>

                        </td>
                        <td style="width: 79%">

                            <asp:UpdatePanel ID="panelActualizar" runat="server">

                                <ContentTemplate>


                                    <asp:Panel ID="panelMensajes" runat="server" Width="100%" Height="500" ScrollBars="Vertical"></asp:Panel>
                                    <asp:Timer ID="temporizador" OnTick="temporizador_Tick" Interval="5000" runat="server"></asp:Timer>

                                </ContentTemplate>


                            </asp:UpdatePanel>

                        </td>
                    </tr>
                </table>

            </td>
        </tr>
        <tr>
            <td>



                <table class="auto-style1">
                    <tr>
                        <td style="width: 10%" >
                            <center>
                                <asp:ImageButton style="height: 50px" ID="botonEnviarImagen" runat="server" ImageUrl="https://lh3.googleusercontent.com/proxy/y0U0R7LQrvuFQhnyoqLT2r2pAyB8c69mGEl0Mvt_hzAKZnZS2PZx0aPPINORHvnr2I2FLs_5aWaYLaYq3R0sOFODVChWBaysMJDoWcDE6yXC5KNnj1IcK6ngQCP8VqDxCaSMCYxIxrWLukSaYlrYCHw" OnClick="botonEnviarImagen_Click"/>
                            </center>
                        </td>
                        <td style="width: 90%">

                            <asp:TextBox style="width:80%; height: 50px" ID="cajaMensaje" runat="server"></asp:TextBox>
                            <asp:Button style="width:19%; height: 50px" ID="botonEnviar" runat="server" Text="Enviar" OnClick="botonEnviar_Click" />

                        </td>
                    </tr>
                </table>

            </td>
        </tr>
    </table>




<br />


</asp:Content>

