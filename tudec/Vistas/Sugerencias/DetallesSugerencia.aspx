<%@ Page Title="Detalles Sugerencia" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/DetallesSugerencia.aspx.cs" Inherits="Vistas_DetallesSugerencia" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">

    <script>

        window.onload = function () {

            var buzon = $find("<%= cajaSugerencia_HtmlEditorExtender.ClientID %>");

            <%

        ESugerencia sugerencia = (ESugerencia)Session["Sugerencia"];
        string imagenesJson = sugerencia.ImagenesJson;
        List<string> imagenes = Newtonsoft.Json.JsonConvert.DeserializeObject<List<string>>(imagenesJson);
        string contenido = sugerencia.Contenido.Replace('"', '\'');

        int contador = 0;

        for(int indice=0; indice<contenido.Length; indice++)
        {

            char caracter = contenido[indice];

            if(caracter == '&')
            {

                contenido = contenido.Substring(0, indice) + imagenes[contador] +  contenido.Substring(indice + 1);
                contador++;

            }

        }

            %>;

            var contenido = "<%= contenido %>";



            buzon._editableDiv.innerHTML = contenido;
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
                <center><asp:Label ID="titulo" runat="server" Text="Título de sugerencia"></asp:Label></center>
        
                <br />
                <br />
                <asp:TextBox ID="cajaSugerencia" runat="server" Height="300px" Width="300px"></asp:TextBox>
            </div>
        </div>
    </div>
                
    <ajaxToolkit:HtmlEditorExtender ID="cajaSugerencia_HtmlEditorExtender" runat="server" TargetControlID="cajaSugerencia">

        <Toolbar>

            <ajaxToolkit:InsertImage />

        </Toolbar>

        </ajaxToolkit:HtmlEditorExtender>


    <br />

</asp:Content>

