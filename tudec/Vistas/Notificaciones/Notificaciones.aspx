<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Notificaciones.aspx.cs" Inherits="Vistas_Notificaciones_Notificaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <br />
    <br />
    <br />
    <br />
    <table class="auto-style1">
        <tr>
            <td>&nbsp;
                <center>
                    <h2>Tus notificaciones</h2>
                </center>
            </td>
        </tr>
        <tr>
            <td>
                <center>
                    <asp:GridView ID="GridView1" runat="server">
                    </asp:GridView>
                </center>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
    </table>
    <br />
    <br />
    <br />
    <br />
</asp:Content>

