<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Chat.aspx.cs" Inherits="Vistas_Chat_Chat" %>

<%@ Register Src="~/Controles/Chat/Mensaje.ascx" TagPrefix="uc1" TagName="Mensaje" %>


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

    



    <br />
<br />
<br />
<br />
<br />




    <table class="auto-style1">
        <tr>
            <td>

                <center>

                    <asp:Label ID="etiquetaNombre" runat="server" Text="Nombre del usuario"></asp:Label>

                </center>
               
            </td>
        </tr>
        <tr>
            <td>

                <asp:UpdatePanel ID="panelActualizar" runat="server">

                    <ContentTemplate>


                        <asp:Panel ID="panelMensajes" runat="server" Width="100%" Height="500" ScrollBars="Vertical"></asp:Panel>
                        <asp:Timer ID="temporizador" OnTick="temporizador_Tick" Interval="5000" runat="server"></asp:Timer>

                    </ContentTemplate>


                </asp:UpdatePanel>

                

            </td>
        </tr>
        <tr>
            <td>

                <asp:TextBox style="width:80%" ID="cajaMensaje" runat="server"></asp:TextBox>
                <asp:Button style="width:19%" ID="botonEnviar" runat="server" Text="Enviar" OnClick="botonEnviar_Click" />

            </td>
        </tr>
    </table>




<br />


</asp:Content>

