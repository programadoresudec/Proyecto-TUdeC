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
                <div class="segundaimagen">
                </div>
            </li>
            <li>
                <div class="terceraimagen">
                </div>
            </li>
        </ul>
        <ul class="pager">
            <li data-index="0" class="active"></li>
            <li data-index="1"></li>
            <li data-index="2"></li>
        </ul>
        <div class="banner-text-posi-w3ls">
			<div class="banner-text-whtree">
				<h3 class="text-capitalize text-white text-center p-4">Experimenta con TUdeC Crea-Aprende
				</h3>
				<p class="px-4 py-3 text-center text-white mx-auto">tudec te permite hacer tutorias o aprender</p>
			</div>
		</div>
    </div>
    <!-- //banner -->
</asp:Content>

