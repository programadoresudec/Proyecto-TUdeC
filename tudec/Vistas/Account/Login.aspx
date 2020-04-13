<%@ Page Title="Iniciar Sesión" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Login.aspx.cs" Inherits="Views_Account_Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" Runat="Server">

<link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

    <br />
    <br />
    <br />
    <br />
    <br />
    <center>

        <h1 style="color: darkblue" >Iniciar sesión</h1>

        <br />
        <table class="auto-style1" style="width: 30%">
            <tr>
                <td><strong>Nombre de usuario:</strong></td>
                <td>
                    <asp:TextBox ID="campoUsuario" CssClass="form-control" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                </td>
            </tr>
            <tr>
                <td><strong>Contraseña</strong></td>
                <td>
                    <asp:TextBox ID="campoPass" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                   <center> 
                       <br />
                       <asp:Label ID="LB_usuarioNoExiste" runat="server" CssClass="text-danger" Visible="False"></asp:Label>
                       <br />
                       <asp:Button ID="botonIniciar" CssClass="botones" runat="server" Text="Iniciar sesión" OnClick="botonIniciar_Click" /> </center> 
                </td>
            </tr>
        </table>

    </center>

    <br />
</asp:Content>

<asp:Content ID="Content1" runat="server" contentplaceholderid="head">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
    </style>
</asp:Content>


