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



                <asp:Table ID="Table2" Width="100%" runat="server">

                    <asp:TableRow>

                        <asp:TableCell Width="20%">

                        </asp:TableCell>
                        <asp:TableCell Width="79%">

                            <center>
                                    <asp:Label ID="etiquetaCurso" runat="server" Text="Nombre del curso"></asp:Label>
                                </center>

                        </asp:TableCell>

                    </asp:TableRow>
                    <asp:TableRow>

                        <asp:TableCell Width="20%">

                        </asp:TableCell>
                        <asp:TableCell Width="79%">

                            <center>

                                    <asp:Image ID="imagenPerfil" CssClass="card-img rounded-circle" runat="server" Width="64" Height="64"></asp:Image>
                                    <asp:Label ID="etiquetaNombre"  runat="server" Text="Nombre del usuario"></asp:Label>
                            </center>
                                

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
                        <asp:TableCell  Width="79%">

                            <asp:UpdatePanel ID="panelActualizarTabla" runat="server" UpdateMode="Conditional">


                                <ContentTemplate>

                                    <asp:Panel ID="panelMensajes" runat="server" Width="100%" Height="400" ScrollBars="Vertical"></asp:Panel>

                                </ContentTemplate>

                                 </asp:UpdatePanel>

                            <asp:UpdatePanel ID="panelActualizar" runat="server">

                                <ContentTemplate>

                                    <asp:Timer ID="temporizador" OnTick="temporizador_Tick" Interval="3000" runat="server"></asp:Timer>

                                </ContentTemplate>


                            </asp:UpdatePanel>


                        </asp:TableCell>

                    </asp:TableRow>

                </asp:Table>

                

            </td>
        </tr>
        <tr>
            <td>



                <table class="auto-style1">
                    <tr>
                        <td style="width: 10%" >
                            <center>
                                <asp:ImageButton style="height: 50px" ID="botonEnviarImagen" runat="server" ImageUrl="https://pngimage.net/wp-content/uploads/2018/06/upload-image-icon-png-8.png" OnClick="botonEnviarImagen_Click"/>
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

