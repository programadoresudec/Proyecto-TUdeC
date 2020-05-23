<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Notificaciones.aspx.cs" Inherits="Vistas_Notificaciones_Notificaciones" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <div class="container mt-5">
        <br />
        <br />
        <br />
        <br />
        <div class="row">
            <div class="col-lg-6 text-center">
                <asp:HyperLink ID="Hyperlink_Devolver" CssClass="btn btn-info" runat="server" Style="font-size: medium;">
                    <i class="fas fa-arrow-alt-circle-left fa-lg"></i>
                </asp:HyperLink>
                <asp:LinkButton CssClass="btn btn-link btn-lg" ID="LNB_EnVistoTodos" runat="server" OnClick="LNB_EnVistoTodos_Click">
                <i class="fa fa-check-circle"></i> Marcar como Leidas.
                </asp:LinkButton>
                <asp:LinkButton CssClass="btn btn-link btn-lg" ID="LNB_BorrarTodas" runat="server" OnClick="LNB_BorrarTodas_Click">
                <i class="fa fa-trash"></i> Eliminar Todas.
                </asp:LinkButton>
            </div>
        </div>
        <div class="row justify-content-center mt-5">
            <asp:Label ID="LB_TieneNotificaciones" runat="server" Visible="false"
                CssClass="text-capitalize text-center p-4 font-weight-bold alertHome alert-info"
                Style="font-size: 40px !important">
        <strong>NO Tiene Notificaciones Por Ahora.</strong>
            </asp:Label>
        </div>
        <asp:DataList ID="DL_Notificaciones" runat="server" DataSourceID="ODS_Notificaciones">
            <ItemTemplate>
                <div class="row mt-3">
                    <div class="card">
                        <div class="card-body">
                            <asp:Label ID="LB_id" Visible="false" runat="server" Text='<%# Eval("Id") %>' />
                            <asp:Label ID="MensajeLabel" Font-Size="X-Large" runat="server" Text='<%# Eval("Mensaje") %>' />
                        </div>
                        <div class="card-footer text-center">
                            <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha") %>' />
                            <br />
                            <asp:LinkButton runat="server" ID="LNB_Borrar" CssClass="btn btn-danger btn-sm" OnClick="LNB_Borrar_Click"><i class="fa fa-trash"></i></asp:LinkButton>
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

