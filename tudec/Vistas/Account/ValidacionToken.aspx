<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ValidacionToken.aspx.cs" Inherits="Vistas_Account_ValidacionToken" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <div class="text-center mt-4" style="padding:17% 8% 8%">
        <asp:Label ID="LB_TextoOne" runat="server" Text="Label" 
            CssClass="text-capitalize text-dark text-center p-4 font-weight-bold"
            Style="font-size: 40px !important">
        <strong>NO SE PUDO VERIFICAR LA DIRECCIÓN DE EMAIL</strong>
        </asp:Label>
        <br />
        <br />
        <asp:Label ID="LB_TextoTwo" runat="server"
            CssClass="px-4 py-3 text-center text-danger mx-auto" Text="Label">
        <strong>OOPS! Se produjo un problema al verificar tu dirección de email!</strong>
        </asp:Label>
    </div>
</asp:Content>

