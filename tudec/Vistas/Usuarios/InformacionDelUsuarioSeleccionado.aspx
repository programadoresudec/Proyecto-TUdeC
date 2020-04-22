<%@ Page Title="Usuario" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/InformacionDelUsuarioSeleccionado.aspx.cs" Inherits="Vistas_InformacionDelUsuarioSeleccionado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <style type="text/css">
        .auto-style1 {
            width: 99px;
        }
        .auto-style2 {
            width: 145px;
            height: 143px;
        }
        .auto-style3 {
            width: 90px;
        }
        .auto-style4 {
            width: 31px;
        }
        .auto-style5 {
            width: 75px;
        }
        .auto-style8 {
            width: 99px;
            height: 4px;
        }
        .auto-style10 {
            height: 9px;
        }
        .auto-style12 {
            height: 2px;
            width: 91px;
        }
        </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <br />
    <br />
    <br />
        <table class="auto-style4" style="width: 956px; height: 217px">
        <tr>
            <td class="auto-style3" rowspan="8">&nbsp;</td>
            <td class="auto-style1">&nbsp;</td>
            <td class="auto-style1"><asp:ImageButton ID="Reportar" ImageUrl="~/App_Themes/Estilos/img/Botón reportar.png" runat="server" Height="34px" Width="94px"/></td>
            <td class="auto-style5" rowspan="8">&nbsp;</td>
            <td rowspan="8">&nbsp;            <asp:GridView CssClass="tablas" ID="GridViewUsuSelec" runat="server" AutoGenerateColumns="False" DataSourceID="DatosUsuarioSeleccionadoDataSource">
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
            </asp:ObjectDataSource></td>
        </tr>

        <tr>
            <td class="auto-style1" colspan="2">
                <img alt="Alternate Text" class="auto-style2" src="../../App_Themes/Estilos/img/Imagen%20Usuario%20por%20defecto.png" /></td>
        </tr>

        <tr>
            <td colspan="2">
                <asp:Label ID="Label2" runat="server" Text="Nombre Usuario"></asp:Label>
            </td>
        </tr>

        <tr>
            <td class="auto-style8">&nbsp;<asp:Label Text="Nombre" runat="server" /> </td>
            <td class="auto-style8">&nbsp;<asp:Label Text="Apellido" runat="server" /></td>
        </tr>

        <tr>
            <td class="auto-style10"> <p class="auto-style12">Calificación:</p>
                &nbsp; 
            </td>
            <td class="auto-style10">&nbsp; <asp:Label Text="Numero de estrellas" runat="server" />  </td>
        </tr>

        <tr>
            <td colspan="2"><p>Descripción:</p>
            </td>
        </tr>

        <tr>
            <td colspan="2">&nbsp; 
                <asp:Label ID="Label3" runat="server" Text="Espacio para la descripción" />
            </td>
        </tr>

        <tr>
            <td class="auto-style1">&nbsp;<asp:Label Text="CALIFICAR:" runat="server" /></td>
            <td class="auto-style1">&nbsp;</td>
        </tr>

    </table>

    <br />
    <br />
<%--       <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <!--Control información del usuario-->
    <div class="conjunto_botn_imgperfil"> <!--Este div es para controlar un gran conjunto de elementos-->  

        <div class="espacio_img_perfil">
            
        </div>


        <div id="apodo_usuario">
            <center>
                <asp:Label ID="Label1" runat="server" Text="Apodo Usuario"></asp:Label>
            </center>
        </div>


        <div id="nombre_usu">
            <center>
               
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
        </div>
    </div>--%>

    <br />
    <br />
    <br />
    <br />

</asp:Content>

