<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Home.aspx.cs" Inherits="Vistas_Inicio" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
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
        <div class="banner-text-posi-w3ls">
            <div class="banner-text-whtree">
                <h3 class="text-capitalize text-white text-center p-4">Experimenta con TUdeC Crea-Aprende
                </h3>
                <p class="px-4 py-3 text-center text-white mx-auto">tudec te permite hacer tutorias o aprender.</p>
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
            </div>
        </div>
    </div>
    <!-- //Buzón de Sugerencias -->

    <!-- //Script movimiento de las imagenes del banner -->
    <script src="../App_Themes/Master/js/slider.js"></script>
    <!-- //Script movimiento de las imagenes del banner -->
</asp:Content>

