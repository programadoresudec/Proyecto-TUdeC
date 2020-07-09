<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="ReporteAdmin.aspx.cs" Inherits="Vistas_ReportesCrystal_ReporteAdmin" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.4000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" Namespace="CrystalDecisions.Web" TagPrefix="CR" %>


<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <br />
    <br />
    <br />
    <br />
    <br />
    <div class="container mt-5 mb-5" padding-bottom:20%">
        <div class="row justify-content-center mt-5">
            <div class="col-lg-6">
                <div class="row">
                    <div class="col">
                        <asp:TextBox runat="server" ID="TB_nombreUsuario" placeHolder="Ingrese El nombre" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col">
                        <asp:LinkButton runat="server" CssClass="btn btn-success" OnClick="generarReporte_Click" ID="generarReporte"><i class="fa fa-file-alt mr-2"></i> Generar Reporte</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
        <div class="row mt-5 mb-5">
            <CR:CrystalReportSource ID="sourceReporteAdmin" runat="server">
                <Report FileName="..\..\Crystal\ReporteAdmin.rpt">
                </Report>
            </CR:CrystalReportSource>
            <CR:CrystalReportViewer ID="CRV_Admin" Visible="false" runat="server" AutoDataBind="true" ReportSourceID="sourceReporteAdmin" />
        </div>
    </div>
</asp:Content>

