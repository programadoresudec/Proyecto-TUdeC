<%@ Page Title="Detalles Sugerencia" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/DetallesSugerencia.aspx.cs" Inherits="Vistas_DetallesSugerencia" %>
<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">

    <script>
        window.onload = function () {
            var buzon = $find("<%= cajaSugerencia_HtmlEditorExtender.ClientID %>");
            <%
        
        ESugerencia sugerencia = (ESugerencia)Session["Sugerencia"];
        string imagenesJson = sugerencia.ImagenesJson;
        List<string> imagenes = Newtonsoft.Json.JsonConvert.DeserializeObject<List<string>>(imagenesJson);
        string contenido = sugerencia.Contenido.Replace('"', '\'');

        int contador = 0;

        for (int indice = 0; indice < contenido.Length; indice++)
        {

            char caracter = contenido[indice];

            if (caracter == '&')
            {

                contenido = contenido.Substring(0, indice) + imagenes[contador] + contenido.Substring(indice + 1);
                contador++;

            }

        }

            %>;

            var contenido = "<%= contenido %>";


            buzon._editableDiv.innerHTML = contenido;

            buzon._editableDiv.setAttribute("contenteditable", "false");

            $(".ajax__html_editor_extender_buttoncontainer").hide();

        }
    </script>
    <br />
    <br />
    <br />
    <br />
    <br />
         <div class="container flex-md-row">
            <asp:HyperLink ID="BtnDevolver" CssClass="btn btn-info" runat="server"
                NavigateUrl="~/Vistas/Sugerencias/VisualizacionDeSugerencias.aspx" Style="font-size: medium;">
                    <i class="fas fa-arrow-alt-circle-left fa-lg"></i>
            </asp:HyperLink>
        </div>
    <div class="container">
        <div class="row justify-content-center">
            <div class="card text-center">
                <div class="card-header">
                    <asp:Image ID="imagenUsuario" CssClass="img-user-avatar rounded-circle" Width="80px" Height="70px" runat="server"></asp:Image>
                    <br />
                    <strong>
                        <asp:Label ID="emisor" runat="server" Text="Usuario"></asp:Label>
                    </strong>
                    <h5 class="text-info">
                        <asp:Label ID="titulo" runat="server" Text="Título de sugerencia"></asp:Label>
                    </h5>
                </div>
                <div class="card-body">
                    <h5 class="text-dark mb-4"><strong>Descripción De La Sugerencia</strong></h5>
                    <div class="row">
                        <asp:TextBox ID="cajaSugerencia" runat="server" Height="500px" Width="100%"></asp:TextBox>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <ajaxToolkit:HtmlEditorExtender ID="cajaSugerencia_HtmlEditorExtender" runat="server" TargetControlID="cajaSugerencia">
        <Toolbar>
        </Toolbar>
    </ajaxToolkit:HtmlEditorExtender>
</asp:Content>

