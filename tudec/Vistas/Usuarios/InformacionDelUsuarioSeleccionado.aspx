<%@ Page Title="Usuario" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/InformacionDelUsuarioSeleccionado.aspx.cs" Inherits="Vistas_InformacionDelUsuarioSeleccionado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../../App_Themes/Estilos/InformacioDelUsuarioSeleccionado.css" rel="stylesheet" />
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <style type="text/css">
        .auto-style1 {
            left: 5%;
            bottom: 40%;
            width: 38%;
            right: 337px;
        }
        .auto-style2 {
            left: 47%;
            bottom: 40%;
        }
        .auto-style3 {
            margin-left: 40px;
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
            <center>

                <asp:Label ID="Label4" runat="server" Text="Calificación:"></asp:Label>

            </center>
            
        </div>


        <div id="promedio_estrellas" class="auto-style2">
           
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
        <div class="auto-style3">
            <asp:GridView CssClass="tablas" ID="GridViewUsuSelec" runat="server" AutoGenerateColumns="False" DataSourceID="DatosUsuarioSeleccionadoDataSource">
                <Columns>
                    <asp:BoundField DataField="Area" HeaderText="Área" SortExpression="Area" >
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Nombre" HeaderText="Curso " SortExpression="Nombre" >
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha de creación" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}" >
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Estado" HeaderText="Estado" SortExpression="Estado" >
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Puntuacion" HeaderText="Puntuación" SortExpression="Puntuacion" >
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
            <asp:ObjectDataSource ID="DatosUsuarioSeleccionadoDataSource" runat="server" SelectMethod="GetCursos" TypeName="GestionUsuario">
                <SelectParameters>
                    <asp:SessionParameter Name="eUsuario" SessionField="UsuarioSeleccionado" Type="Object" />
                </SelectParameters>
            </asp:ObjectDataSource>
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

