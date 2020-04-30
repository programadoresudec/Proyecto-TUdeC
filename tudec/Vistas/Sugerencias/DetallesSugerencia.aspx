<%@ Page Title="Detalles Sugerencia" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/DetallesSugerencia.aspx.cs" Inherits="Vistas_DetallesSugerencia" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 64px;
            height: 64px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" runat="Server">

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


    <div class="container">
        <div class="form-group row justify-content-center">
            <div class=" form-group col-md-auto">
                <center><asp:Label ID="titulo" runat="server" Text="Título de sugerencia"></asp:Label>
                    <br />
                    <asp:Image ID="imagenUsuario" ImageUrl="../../Recursos/Imagenes/PerfilUsuarios/Usuario.png"  runat="server"></asp:Image>
                    <asp:Label ID="emisor" runat="server" Text="Usuario"></asp:Label>
                </center>

                <br />
                <br />
                <asp:TextBox ID="cajaSugerencia" runat="server" Height="500px" Width="300px"></asp:TextBox>
            </div>
        </div>
    </div>

    <ajaxToolkit:HtmlEditorExtender ID="cajaSugerencia_HtmlEditorExtender" runat="server" TargetControlID="cajaSugerencia">

        <Toolbar>
        </Toolbar>

    </ajaxToolkit:HtmlEditorExtender>


    <br />

</asp:Content>

