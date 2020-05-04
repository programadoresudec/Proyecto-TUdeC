<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="CalificarExamen.aspx.cs" Inherits="Vistas_Examen_CalificarExamen" %>

<%@ Register Src="~/Controles/Examenes/CalificacionExamen.ascx" TagPrefix="uc1" TagName="CalificacionExamen" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">


    <br />
    <br />
    <br />
    <br />
    <br />

    <uc1:CalificacionExamen runat="server" ID="CalificacionExamen" />

    <br />

</asp:Content>

