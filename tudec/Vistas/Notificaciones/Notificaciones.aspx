<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Notificaciones.aspx.cs" Inherits="Vistas_Notificaciones_Notificaciones" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <div class="container mt-5">
        <br />
        <br />
        <br />
        <br />
        <br />
        <div class="container flex-md-row">
            <asp:HyperLink ID="BtnDevolver" CssClass="btn btn-info" runat="server"
                NavigateUrl="~/Vistas/Home.aspx" Style="font-size: medium;">
                    <i class="fas fa-arrow-alt-circle-left mr-2"></i><strong>Devolver</strong> 
            </asp:HyperLink>
        </div>
        <div class="row justify-content-center mt-5">
            <asp:Label ID="LB_TieneNotificaciones" runat="server" Visible="false"
                CssClass="text-capitalize text-center p-4 font-weight-bold alertHome alert-info"
                Style="font-size: 40px !important">
        <strong>NO Tiene Notificaciones Por Ahora.</strong>
            </asp:Label>
        </div>
        <div class="row">
            <asp:LinkButton CssClass="btn btn-link btn-lg" runat="server">
                <i class="fa fa-check-circle"></i> Marcar Todos Como Leidos.
            </asp:LinkButton>
        </div>
        <asp:DataList ID="DL_Notificaciones" runat="server" DataSourceID="ODS_Notificaciones">
            <ItemTemplate>
                <div class="row mt-3">
                    <div class="card">
                        <div class="card-body">
                            <asp:Label ID="MensajeLabel" Font-Size="X-Large" runat="server" Text='<%# Eval("Mensaje") %>' />
                        </div>
                        <div class="card-footer text-center">
                            <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha") %>' />
                        </div>
                    </div>
                    <br />
                    <br />
                    <br />
                </div>
            </ItemTemplate>
        </asp:DataList>
        <asp:ObjectDataSource ID="ODS_Notificaciones" runat="server" SelectMethod="notificacionesDelUsuario" TypeName="DaoNotificacion">
            <SelectParameters>
                <asp:SessionParameter Name="nombreUsuario" SessionField="notificacionesUsuario" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <br />
        <br />
    </div>
</asp:Content>

