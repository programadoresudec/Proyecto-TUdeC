<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="InformacionDelUsuarioSeleccionado.aspx.cs" Inherits="Vistas_InformacionDelUsuarioSeleccionado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    
    <!--Control información del usuario-->
    <div> <!--Este div es para controlar la imagen de perfil y el botón de reportar-->  

        <div>  <!--Este div es para el botón de reportar--> 
            <asp:ImageButton ID="ImageButton1" runat="server"/>
        </div>

        <div> <!--Este div es para la foto de perfil y la información del usuario-->
            
        </div>

        <div><!--Para el numero de estrellas-->

        </div>

        <div><!--Para la descripción-->

        </div>

        <div><!--Para calificar por estrellas-->

        </div>

    </div>

    <div> <!--Este div es para los cursos creados por la persona-->   
        <div>
            <h1>CURSOS ACTIVOS CREADOS POR ESTA PERSONA</h1>
        </div>
    </div>

</asp:Content>

