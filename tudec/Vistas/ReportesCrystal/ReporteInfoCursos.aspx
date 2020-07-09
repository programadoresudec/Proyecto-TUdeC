<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReporteInfoCursos.aspx.cs" Inherits="Vistas_ReportesCrystal_ReporteInfoCursos" %>

<%@ Register assembly="CrystalDecisions.Web, Version=13.0.4000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        
        <CR:CrystalReportSource ID="sourceReporte" runat="server">
            <Report FileName="..\..\Crystal\InfoCursos.rpt">
            </Report>
        </CR:CrystalReportSource>

        <CR:CrystalReportViewer ID="viewerReporte" runat="server" AutoDataBind="true" ReportSourceID="sourceReporte" />
    </form>
</body>
</html>
