<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="InformacionDelUsuarioSeleccionado.aspx.cs" Inherits="Vistas_InformacionDelUsuarioSeleccionado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../../App_Themes/Estilos/InformacioDelUsuarioSeleccionado.css" rel="stylesheet" />
    <style type="text/css">
        .auto-style1 {
            left: 5%;
            bottom: 40%;
            width: 38%;
            right: 337px;
        }
        .auto-style2 {
            left: 45%;
            bottom: 40%;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <!--Control información del usuario-->
    <div class="conjunto_botn_imgperfil"> <!--Este div es para controlar un gran conjunto de elementos-->  

        <div class="espacio_boton"> 
            <asp:ImageButton ID="Reportar" CssClass="boton_reportar" ImageUrl="~/App_Themes/Estilos/img/Botón reportar.png" runat="server"/>
        </div>


        <div class="espacio_img_perfil">
            <img id="imagen_de_perfil" src="../../App_Themes/Estilos/img/Imagen Usuario por defecto.png" alt="Alternate Text" />
        </div>


        <div id="apodo_usuario">
            <center>
                <asp:Label ID="Label1" runat="server" Text="Apodo Usuario"></asp:Label>
            </center>
        </div>


        <div id="nombre_usu">
            <center>
                <asp:Label ID="Label2" runat="server" Text="Nombre Usuario"></asp:Label>
            </center>
        </div>

        
        <div id="apellidos_usu">
            <center>
                <asp:Label ID="Label3" runat="server" Text="Apellido Usuario"></asp:Label>
            </center>
        </div>

        
        <div id="texto_cal" class="auto-style1">
            <p>Calificación por estrellas:</p>
        </div>


        <div id="promedio_estrellas" class="auto-style2">
            <asp:Label ID="Label4" Text="text" runat="server" />
        </div>


        <div id="descripcion">
            <center>
                <asp:Label ID="Label5" Text="Descripción del Usuario" runat="server" />
            </center>
        </div>


        <div id="calificar_usu"><!--Para calificar por estrellas-->

        </div>


    </div>


    <div class="cursos_creados"> <!--Este div es para los cursos creados por la persona-->  
                    <h3>CURSOS ACTIVOS CREADOS POR ESTA PERSONA</h3>
        <div>
            <asp:GridView ID="GridView1" runat="server" DataSourceID="InformaciónUsuarioDataSource"></asp:GridView>
            <asp:ObjectDataSource ID="InformacionUsuarioSeleccionadoDataSource" runat="server"></asp:ObjectDataSource>
            <asp:ObjectDataSource ID="InformaciónUsuarioDataSource" runat="server"></asp:ObjectDataSource>
        </div>
    </div>
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />

</asp:Content>

