<%@ Page Title="Búsqueda Tutores" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeResultadosDelBuscadorTutores.aspx.cs" Inherits="Vistas_ListaDeResultadosDelBuscadorTutores" %>

<%@ Register Src="~/Controles/Estrellas/Estrellas.ascx" TagPrefix="uc1" TagName="Estrellas" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <br />
    <br />
    <br />
    <br />
    <br />
    <div class="container mt-5 mb-5">
        <div class="row justify-content-between">
            <div class="col-lg-auto mb-5">
                <div class="row justify-content-center">
                    <div class="col">
                        <asp:LinkButton CssClass="btn btn-outline-dark btn-block botones mr-2" ID="botonCurso" runat="server" OnClick="botonCurso_Click" Text="Buscar curso" />
                    </div>
                    <div class="col">
                        <asp:LinkButton CssClass="btn botonPulsado btn-block mr-2 disabled" ID="botonTutor" runat="server" Text="Buscar tutor" />
                    </div>
                </div>
                <div class="card mt-4">
                    <div class="card-header text-center">
                        <div class="col input-group">
                            <asp:TextBox ID="TextBox1" runat="server" CssClass=" fa fa-search form-control" placeHolder="Buscar tutor" Width="217px"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender
                                MinimumPrefixLength="1" CompletionInterval="10"
                                CompletionSetCount="1" FirstRowSelected="false"
                                ID="AutoCompleteExtender1" CompletionListItemCssClass="btn btn-link"
                                runat="server" ServiceMethod="GetNombresCursos"
                                TargetControlID="cajaBuscador" />
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <i class="fa fa-search"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="card-title text-center">
                            <h4>Filtros</h4>
                        </div>
                        <div class="row mt-2 text-center">
                            <div class="col-md-5">
                                <div class="card-title">
                                    <h6><strong>Calificación</strong></h6>
                                </div>
                            </div>
                            <div class="col-md-7">
                                <uc1:Estrellas runat="server" ID="Estrellas" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <h1 class="text-center"><strong>Tutores</strong></h1>
                <div class="table-responsive">
                    <table class="table">
                        <asp:GridView ID="tablaTutores" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="TutoresSource" OnRowDataBound="tablaTutores_RowDataBound" AllowPaging="True">
                            <Columns>
                                <asp:BoundField DataField="ImagenPerfil" HeaderText="Imagen de la cuenta" ControlStyle-CssClass="card-img rounded-circle" HtmlEncode="false" SortExpression="ImagenPerfil">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NombreDeUsuario" HeaderText="Nombre del tutor" SortExpression="NombreDeUsuario">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NumCursos" HeaderText="N° cursos" SortExpression="NumCursos">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="FechaCreacion" HeaderText="Fecha de creación" SortExpression="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Puntuacion" HeaderText="Calificación" SortExpression="Puntuacion">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </table>
                </div>
                <asp:ObjectDataSource ID="TutoresSource" runat="server" SelectMethod="GetTutores" TypeName="Buscador">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="cajaBuscador" Name="tutor" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="estrellas" Name="puntuacion" PropertyName="Calificacion" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div>
        </div>
    </div>
</asp:Content>
