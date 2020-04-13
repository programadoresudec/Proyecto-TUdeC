﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Home.aspx.cs" Inherits="Vistas_Inicio" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">

    <script>

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
                <p class="px-4 py-3 text-center text-white mx-auto">Plataforma web Ingenieria De Sistemas universidad Cundinamarca. Hecha por: Miguel Tellez, Frand Casas, Diego Parra.</p>
			</div>
        </div>
    </div>
    <!-- //banner -->
    <br />
    <br />
    <!-- //Buzón de Sugerencias -->
    <div class="container">
        <div class="form-group row justify-content-center">
            <div class=" form-group col-md-auto">
                <br />
                <h2 style="text-align: center; color: #163392; font-size: x-large;"><strong>Buzón De Sugerencias</strong></h2>
                <br />
                <asp:TextBox ID="cajaTitulo" runat="server" Width="300px" CssClass="form-control" placeHolder="Título"></asp:TextBox>
                <br />
                <asp:TextBox ID="buzon" runat="server" Height="300px" Width="300px" CssClass="form-control"></asp:TextBox>
                <asp:Button ID="enviar" runat="server" Text="Enviar sugerencia"  Width="300px" CssClass="form-control" OnClick="enviar_Click"/>
                <ajaxToolkit:HtmlEditorExtender ID="buzon_HtmlEditorExtender" runat="server"  TargetControlID="buzon" OnImageUploadComplete="buzon_HtmlEditorExtender_ImageUploadComplete">

                    <Toolbar>

                        <ajaxToolkit:InsertImage />

                    </Toolbar>

                </ajaxToolkit:HtmlEditorExtender>
            </div>
        </div>
    </div>
    <!-- //Buzón de Sugerencias -->
    <!-- //Script movimiento de las imagenes del banner -->
    <script src="../App_Themes/Master/js/slider.js"></script>
    <!-- //Script movimiento de las imagenes del banner -->
</asp:Content>

