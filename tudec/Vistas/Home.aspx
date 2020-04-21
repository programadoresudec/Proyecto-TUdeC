<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Home.aspx.cs" Inherits="Vistas_Inicio" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">

    <script>

        $(document).ready(function () {
            $('#enviar').click(function () {

                

                var buzon = $find("<%=buzon_HtmlEditorExtender.ClientID%>");
                buzon = buzon._editableDiv;
                var titulo = <%=cajaTitulo.ClientID%>;

                if (titulo.value != "" && buzon.innerHTML != "") {

                    textoTitulo = titulo.value;

                    var datos = "{'titulo':'" + textoTitulo + "','contenido':'" + buzon.innerHTML + "'}";

                    $.ajax({

                        type: "POST",
                        url: 'Home.aspx/EnviarHtml',
                        data: datos,

                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: true,

                    });

                    titulo.value = "";
                    buzon.innerHTML = "";

                    alert("Sugerencia enviada");

                }
                else {

                    alert("Rellene los campos antes de enviar la sugerencia")

                }

            });
        });

    </script>

    <!-- banner -->
    <div class="banner-agile">
        <ul class="slider">
            <li class="active">
                <div class="banner-inicio">
                </div>
            </li>
            <li>
                <div class="banner-segundo">
                </div>
            </li>
            <li>
                <div class="banner-tercero">
                </div>
            </li>
            <li>
                <div class="banner-cuarto">
                </div>
            </li>
            <li class="prev">
                <div class="banner-fin">
                </div>
            </li>
        </ul>
        <ul class="pager">
            <li data-index="0" class="active"></li>
            <li data-index="1"></li>
            <li data-index="2"></li>
            <li data-index="3"></li>
            <li data-index="4"></li>
        </ul>
        <div class="banner-texto-posicion">
            <div class="banner-texto">
                <h3 class="text-capitalize text-white text-center p-4">Crea-Aprende-Enseña con TUdeC
                </h3>
                <p class="px-4 py-3 text-center text-white mx-auto">Plataforma web Ingenieria De Sistemas universidad
                    Cundinamarca. Hecha por: Miguel Tellez, Frand Casas, Diego Parra.</p>
            </div>
        </div>
    </div>
    <!-- //banner -->
    <br />
    <br />
    <!-- //Buzón de Sugerencias -->
    <asp:Panel CssClass="container" runat="server">

        <asp:Panel CssClass="form-group row justify-content-center" runat="server">
            <asp:Panel ID="panelBuzon" CssClass=" form-group col-md-auto" runat="server">
                <br />
                <h2 style="text-align: center; color: #163392; font-size: x-large;"><strong>Buzón De
                        Sugerencias</strong></h2>
                <br />
                <asp:Panel ID="panelCamposBuzon" runat="server">
                    <asp:TextBox ID="cajaTitulo" runat="server" Width="300px" CssClass="form-control"
                        placeHolder="Título"></asp:TextBox>
                    <br />
                    <asp:TextBox ID="buzon" runat="server" Height="300px" Width="300px" CssClass="form-control">
                    </asp:TextBox>

                    <input id="enviar" type="button" value="Enviar sugerencia" style="width:300px"
                        class="btn btn-success" />

                    <ajaxToolkit:HtmlEditorExtender ID="buzon_HtmlEditorExtender" runat="server" TargetControlID="buzon"
                        OnImageUploadComplete="buzon_HtmlEditorExtender_ImageUploadComplete">

                        <Toolbar>

                            <ajaxToolkit:InsertImage />

                        </Toolbar>

                    </ajaxToolkit:HtmlEditorExtender>
                </asp:Panel>
            </asp:Panel>
        </asp:Panel>

    </asp:Panel>
    <!-- //Buzón de Sugerencias -->
    <!-- //Script movimiento de las imagenes del banner -->
    <script src="../App_Themes/Master/js/slider.js"></script>
    <!-- //Script movimiento de las imagenes del banner -->
</asp:Content>