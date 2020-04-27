<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/GestionUsuarios.aspx.cs" Inherits="Vistas_Admin_GestionUsuarios" %>


<asp:Content ID="contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">

    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

    <div class="container">
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
          <ajaxToolkit:AutoCompleteExtender
                        MinimumPrefixLength="1"
                        CompletionInterval="10"
                        CompletionSetCount="1"
                        FirstRowSelected="false"
                        ID="cajaBuscador_AutoCompleteExtender"
                        runat="server"
                        ServiceMethod="GetNombreUsuario"
                        TargetControlID="cajaBuscador">
                    </ajaxToolkit:AutoCompleteExtender>
        <div class="row justify-content-center">
            <div class=" form-group col-md-auto">
                <div class="input-group mb-3">
                    <asp:TextBox AutoPostBack="true" ID="cajaBuscador" runat="server" placeHolder="Texto de Busqueda" Width="200px">
                    </asp:TextBox>
                  
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <asp:LinkButton ID="botonBuscar" runat="server">
							<i class="fa fa-search"></i></asp:LinkButton>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <i class="fas fa-filter"></i>
                    <asp:DropDownList ID="DDL_Estado" runat="server" DataTextField="Estado" placeHolder="Estado" CssClass="dropdown-toggle" DataSourceID="ODS_EstadosUsuario" DataValueField="Estado">
                    </asp:DropDownList>
                    <asp:ObjectDataSource ID="ODS_EstadosUsuario" runat="server" SelectMethod="obtenerEstadosUsuario" TypeName="DaoUsuario"></asp:ObjectDataSource>
                </div>
            </div>
            
                <div class="table-responsive">
                    <table class="table">
                        <asp:GridView ID="GridViewGestionUsuario" runat="server" CssClass="tablas" AutoGenerateColumns="False" DataSourceID="ODS_DaoUsuario">
                            <Columns>
                                <asp:ImageField DataImageUrlField="ImagenPerfil" HeaderText="Imagen de perfil" SortExpression="ImagenPerfil">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:ImageField>
                                <asp:BoundField DataField="NombreDeUsuario" HeaderText="Nombre De Usuario" SortExpression="NombreDeUsuario">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Estado" HeaderText="Estado" SortExpression="Estado">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha De Registro" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NumCursos" HeaderText="# de Cursos" SortExpression="NumCursos">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Bloquear">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="botonBloquearUsuario" runat="server"
                                            CssClass="btn btn-default"><i class="fas fa-user-lock" style="color:red"></i></asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Ver Reportes">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="botonVerReportes" runat="server"
                                            CssClass="btn btn-default"><i class="fa fa-eye" style="color:darkgreen"></i></asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>

                        <asp:ObjectDataSource ID="ODS_DaoUsuario" runat="server" SelectMethod="gestionDeUsuarioAdmin" TypeName="DaoUsuario"></asp:ObjectDataSource>

                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

