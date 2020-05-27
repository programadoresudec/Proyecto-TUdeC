﻿<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CampanaNotifcacion.ascx.cs" Inherits="Controles_CampanaNotificacion_CampanaNotifcacion" %>
<asp:LinkButton runat="server" CssClass="btn btn-outline-light fa fa-bell fa-lg mt-2" ID="BtnNotificaciones"
    data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" Visible="false">
    <asp:Label CssClass="rounded-circle btn-sm"  ID="LB_campana" BackColor="#ee0606" Visible="false" ForeColor="White" runat="server" />
</asp:LinkButton>
<div class="dropdown-menu dropdown-menu-right text-center" aria-labelledby="navbarDropdown">
    <asp:LinkButton CssClass="btn btn-outline-success" OnClick="Notificaciones_Click" ID="Notificaciones" runat="server"
        Visible="true"></asp:LinkButton>
</div>
