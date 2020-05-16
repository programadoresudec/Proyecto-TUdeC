<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ReportesPorUsuario.aspx.cs" Inherits="Vistas_Admin_ReportesPorUsuario" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <br />
    <br />
    <br />
    <br />
    <br />
    <div class="container flex-md-row">
        <asp:HyperLink ID="BtnDevolver" CssClass="btn btn-info" runat="server"
            NavigateUrl="~/Vistas/Admin/GestionUsuarios.aspx" Style="font-size: medium;">
                <i class="fas fa-arrow-alt-circle-left mr-2"></i><strong>Devolver</strong> 
        </asp:HyperLink>
    </div>
    <div class="container-fluid">
        <br />
        <div class="row justify-content-center">
            <asp:ListView ID="LV_Reportes" runat="server" DataKeyNames="Id" DataSourceID="ODS_Reportes">
                <EditItemTemplate>
                    <asp:TextBox ID="IdTextBox" runat="server" Visible="false" Text='<%# Bind("Id") %>' />
                    <div class="card ml-md-5 mr-md-5 mb-4">
                        <div class="card-header text-center">
                            <strong>Nombre Del Usuario Denunciante</strong>
                            <br />
                            <asp:Label ID="NombreDeUsuarioDenuncianteLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciante") %>' />
                        </div>
                        <div class="card-body">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">
                                    <div class="row justify-content-center">
                                        <strong>Motivo Del Reporte:</strong>
                                        <asp:DropDownList ID="DDL_Motivos" runat="server" CssClass="form-control ml-2" Width="60%" DataSourceID="ODS_Motivos" DataTextField="Motivo" DataValueField="Motivo" SelectedValue='<%# Bind("MotivoDelReporte") %>'>
                                        </asp:DropDownList>
                                        <asp:ObjectDataSource ID="ODS_Motivos" runat="server" SelectMethod="getMotivoReporte" TypeName="DaoReporte"></asp:ObjectDataSource>
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="card-title">
                                        <strong>Descripción Del Reporte</strong>
                                    </div>
                                    <div class="card-text">
                                        <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="card-text">
                                        <strong>Fecha:</strong>
                                        <asp:Label ID="FechaLabel" CssClass="ml-2" runat="server" Text='<%# Eval("Fecha") %>' />
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="row justify-content-center">
                                        <a class="btn btn-dark" data-toggle="collapse" href="#<%# Eval("Id")+"Comentario" %>"
                                            role="button" aria-expanded="false" aria-controls="collapseComentarios">Información De Los Comentarios
                                        </a>
                                    </div>
                                    <div class="collapse" id="<%#Eval("Id")+"Comentario"%>">
                                        <div class="card card-body mt-3">
                                            <div class="row justify-content-center">
                                                <asp:Label ID="ComentarioLabel" runat="server" Text='<%# Eval("Comentario") %>' />
                                            </div>
                                            <div class="row justify-content-center">
                                                <asp:Image ID="ImagenesComentarioLabel" runat="server" ImageUrl='<%# Eval("ImagenesComentario") %>' />
                                            </div>
                                        </div>
                                    </div>
                                </li>

                                <li class="list-group-item">
                                    <div class="row justify-content-center">
                                        <a class="btn btn-dark" data-toggle="collapse" href="#<%# Eval("Id")+"Mensaje" %>"
                                            role="button" aria-expanded="false" aria-controls="collapseMensajes">Información De Los Mensajes
                                        </a>
                                    </div>
                                    <div class="collapse" id="<%# Eval("Id")+"Mensaje" %>">
                                        <div class="card card-body mt-3">
                                            <div class="row justify-content-center">
                                                <asp:Label ID="MensajeLabel" runat="server" Text='<%# Eval("Mensaje") %>' />
                                            </div>
                                            <div class="row justify-content-center">
                                                <asp:Image ID="ImagenesMensaje" runat="server" ImageUrl="~/Recursos/Imagenes/SugerenciasEnviadas/Sugerencia28Imagen0.jpg" />
                                            </div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="card-footer">
                            <div class="row">
                                <div class="col-md-6">
                                    <asp:LinkButton ID="CancelButton" runat="server" CommandName="Cancel" CssClass="btn btn-info btn-block">
                                  <i class="fas fa-arrow-alt-circle-left mr-2"></i><strong>Cancelar</strong>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-6">
                                    <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" CssClass="btn btn-success btn-block">
                                  <i class="fa fa-save mr-2"></i><strong>Actualizar</strong>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </EditItemTemplate>
                <EmptyDataTemplate>
                    <div class="row justify-content-center mb-5 mt-5" style="padding-top:3%">
                        <div class="col-lg-auto text-center">
                        <h1 class="text-info"><i class="fa fa-info-circle mr-2"></i><strong>No tiene Reportes Por Ver.</strong></h1>

                        </div>
                    </div>
                </EmptyDataTemplate>
                <ItemTemplate>
                    <asp:Label ID="LB_IdReporte" runat="server" Visible="false" Text='<%# Eval("Id") %>' />
                    <asp:Label ID="LB_NombreUsuarioDenunciado" runat="server" Visible="false" Text='<%# Eval("NombreDeUsuarioDenunciado") %>' />
                    <div class="card ml-md-5 mr-md-5 mb-4">
                        <div class="card-header text-center">
                            <strong>Nombre Del Usuario Denunciante</strong><br />
                            <asp:Label ID="NombreDeUsuarioDenuncianteLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciante") %>' />
                        </div>
                        <div class="card-body">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">
                                    <div class="card-text">
                                        <strong>Motivo Del Reporte:</strong>
                                        <asp:Label ID="MotivoDelReporteLabel" CssClass="ml-2" runat="server" Text='<%# Eval("MotivoDelReporte") %>' />
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="card-title">
                                        <strong>Descripción Del Reporte</strong>
                                    </div>
                                    <div class="card-text">
                                        <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="card-text">
                                        <strong>Fecha:</strong>
                                        <asp:Label ID="FechaLabel" CssClass="ml-2" runat="server" Text='<%# Eval("Fecha") %>' />
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="row justify-content-center">
                                        <a class="btn btn-dark" data-toggle="collapse" href="#<%# Eval("Id")+"Comentario" %>"
                                            role="button" aria-expanded="false" aria-controls="collapseComentarios">Información De Los Comentarios
                                        </a>
                                    </div>
                                    <div class="collapse" id="<%#Eval("Id")+"Comentario"%>">
                                        <div class="card card-body mt-3">
                                            <div class="row justify-content-center">
                                                <asp:Label ID="ComentarioLabel" runat="server" Text='<%# Eval("Comentario") %>' />
                                            </div>
                                            <div class="row justify-content-center">
                                                <asp:Image ID="ImagenesComentarioLabel" Width="75px" runat="server" ImageUrl='<%# Eval("ImagenesComentario") %>' />
                                            </div>
                                        </div>
                                    </div>
                                </li>

                                <li class="list-group-item">
                                    <div class="row justify-content-center">
                                        <a class="btn btn-dark" data-toggle="collapse" href="#<%# Eval("Id")+"Mensaje" %>"
                                            role="button" aria-expanded="false" aria-controls="collapseMensajes">Información De Los Mensajes
                                        </a>
                                    </div>
                                    <div class="collapse" id="<%# Eval("Id")+"Mensaje" %>">
                                        <div class="card card-body mt-3">
                                            <div class="row justify-content-center">
                                                <asp:Label ID="MensajeLabel" runat="server" Text='<%# Eval("Mensaje") %>' />
                                            </div>
                                            <div class="row justify-content-center">
                                                <asp:Image ID="ImagenesMensaje" Width="75px" runat="server" ImageUrl='<%# Eval("ImagenesMensaje") %>' />
                                            </div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="card-footer">
                            <div class="row">
                                <div class="col-lg-auto">
                                    <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" CssClass="btn btn-danger btn-block mb-3">
                                <i class="fas fa-user-lock mr-2"></i><strong>Reportar</strong>
                                    </asp:LinkButton>
                                </div>
                                <div class="col-lg-auto">
                                    <asp:LinkButton ID="Quitar" runat="server" OnClick="Quitar_Click" CssClass="btn btn-outline-info btn-block">
                                  <i class="fas fa-times-circle mr-2"></i><strong>Quitar Reporte</strong>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>

                <LayoutTemplate>
                    <table runat="server" border="0" style="">
                        <tr id="itemPlaceholderContainer" runat="server">
                            <td id="itemPlaceholder" runat="server"></td>
                        </tr>
                    </table>

                    <asp:DataPager ID="Paginacion" runat="server" PageSize="3">
                        <Fields>
                            <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ButtonCssClass="btn-link" ShowNextPageButton="False" ShowPreviousPageButton="False" />
                            <asp:NumericPagerField CurrentPageLabelCssClass="btn-link" />
                            <asp:NextPreviousPagerField ButtonType="Button" ShowLastPageButton="True" ButtonCssClass="btn-link" ShowNextPageButton="False" ShowPreviousPageButton="False" />
                        </Fields>
                    </asp:DataPager>

                </LayoutTemplate>
            </asp:ListView>
            <asp:ObjectDataSource ID="ODS_Reportes" runat="server" DataObjectTypeName="EReporte" SelectMethod="reportesDelUsuario" TypeName="DaoReporte" UpdateMethod="actualizarMotivo">
                <SelectParameters>
                    <asp:SessionParameter Name="nombreDeUsuarioDenunciado" SessionField="usuarioConReportes" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </div>
    </div>
</asp:Content>







