﻿<%@ Page Title="Acerca De Nosotros" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/About.aspx.cs" Inherits="Views_About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/About/css/About.css" type="text/css" rel="stylesheet" media="all">
    <!-- about-->
    <br />
    <br />
    <section class="row py-sm-5" id="why">
        <div class="container py-lg-5 py">
            <div class="row py-lg-5 py-4">
                <div class="col-lg-5 mt-lg-0 mt-3">
                    <img src="../../App_Themes/About/img/logo.png" class="img-fluid img-thumbnail" alt="" />
                </div>
                <div class="col-lg-7">
                    <h4 class="w3pvt-title mt-5" style="text-align:center">TUdeC Objetivo</h4>
                    <br>
                    <br>
                    <p class="mt-3" style="text-align:center">
                        TUdeC tiene como propósito la creación de una plataforma web educativa que le permite a los estudiantes de la
                            Universidad de Cundinamarca extensión Facatativá la creación e inscripción de cursos para impartir conocimientos
                        y aprender, respectivamente.
                    </p>
                    <br>
                    <br>
                    <div class="row mt-4 justify-content-center">
                        <a href="#team" class="text-capitalize serv_link btn bg-theme scroll">Acerca Del Team</a>
                    </div>
                    
                </div>
            </div>
        </div>
    </section>
    <!-- //about -->
    <!-- team  -->
    <section class="pb-sm-5 py-4 team-agile" id="team">
        <div class="container py-md-5">
            <div class="title-w3ls text-center">
                <span class="sub-title">Creadores de TUdeC</span>
                <h4 class="w3pvt-title">Nuestro team
                </h4>
            </div>
            <div class="d-flex team-agile-row pt-sm-5 pt-3">
                <div class="col-lg-4 col-md-6">
                    <div class="box20">
                        <img src="../../App_Themes/About/img/Miguel.png" alt="" class="img-fluid" />
                        <div class="box-content">
                            <br>
                            <h3 class="title">MiguelTellez</h3>
                            <span class="post">Miguel Angel
                                    <br>
                                Manrique Tellez</span>
                        </div>
                        <ul class="icon">
                            <li>
                                <a href="mailto:mangelmanrique@ucundinamarca.edu.co">
                                    <span class="fa fa-envelope"></span>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <span class="fab fa-github"></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mt-md-0 mt-4">
                    <div class="box20">
                        <img src="../../App_Themes/About/img/Diego.png" alt="" class="img-fluid" />
                        <div class="box-content">
                            <br>
                            <h3 class="title">Diegoaparra</h3>
                            <span class="post">Diego Arturo
                                    <br>
                                Parra Molina</span>
                        </div>
                        <ul class="icon">
                            <li>
                                <a href="mailto:diegoaparra@ucundinamarca.edu.co">
                                    <span class="fa fa-envelope"></span>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <span class="fab fa-github"></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mt-lg-0 mt-4 mx-auto">
                    <div class="box20">
                        <img src="../../App_Themes/About/img/Frand.png" alt="" class="img-fluid" />
                        <div class="box-content">
                            <br>
                            <h3 class="title">frandCasitas</h3>
                            <span class="post">Frand Eldimer
                                    <br>
                                Casas Lopez</span>
                        </div>
                        <ul class="icon">
                            <li>
                                <a href="mailto:fecasas@ucundinamarca.edu.co">
                                    <span class="fa fa-envelope"></span>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <i class="fab fa-github"></i>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- //team -->
</asp:Content>

