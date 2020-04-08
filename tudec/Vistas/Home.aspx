<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Home.aspx.cs" Inherits="Vistas_Inicio" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <!-- banner -->
    <div class="banner-agile">
        <ul class="slider">
            <li class="active">
                <div class="inicio">
                </div>
            </li>
            <li>
                <div class="banner-w3ls-2">
                </div>
            </li>
            <li>
                <div class="banner-w3ls-3">
                </div>
            </li>
            <li>
                <div class="banner-w3ls-4">
                </div>
            </li>
            <li class="prev">
                <div class="banner-w3ls-5">
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
                <h3 class="text-capitalize text-white text-center p-4">Tudec APRENDE Y CREA
                </h3>
                <p class="px-4 py-3 text-center text-white mx-auto">
                    TUdeC te permite hacer tutorias
                    virtuales mediante creación de cursos.
                </p>
            </div>
        </div>
    </div>
    <!-- //banner -->
</asp:Content>

