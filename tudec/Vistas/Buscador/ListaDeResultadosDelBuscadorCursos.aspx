<%@ Page Title="Búsqueda Cursos" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeResultadosDelBuscadorCursos.aspx.cs" Inherits="ListaDeResultadosDelBuscador" %>

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
                        <asp:LinkButton CssClass="btn botonPulsado btn-block mr-2 disabled" ID="botonCurso" runat="server" Text="Buscar curso" />
                    </div>
                    <div class="col">
                        <asp:LinkButton CssClass="btn btn-outline-dark btn-block botones mr-2" ID="botonTutor" runat="server" OnClick="botonTutor_Click" Text="Buscar tutor" />
                    </div>
                </div>
                <div class="card mt-4">
                    <div class="card-header text-center">
                        <div class="col input-group">
                            <asp:TextBox AutoPostBack="true" ID="cajaBuscador" runat="server" CssClass=" fa fa-search form-control" placeHolder="Buscar curso" Width="217px"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender
                                MinimumPrefixLength="1" CompletionInterval="10"
                                CompletionSetCount="1" FirstRowSelected="false"
                                ID="cajaBuscador_AutoCompleteExtender"
                                runat="server" ServiceMethod="GetNombresCursos"
                                TargetControlID="cajaBuscador" />
                            <div class="input-group-prepend">
                                <asp:LinkButton CssClass="btn btn-info btn-sm" runat="server"> <i class="fa fa-search"></i></asp:LinkButton>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="card-title text-center">
                            <h4>Filtros</h4>
                        </div>
                        <div class="row">
                            <div class="col input-group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <i class="fas fa-chalkboard-teacher"></i>
                                    </div>
                                </div>
                                <asp:TextBox AutoPostBack="true" ID="cajaTutor" CssClass="form-control" placeHolder="Tutor" runat="server"></asp:TextBox>
                                <ajaxToolkit:AutoCompleteExtender
                                    ID="cajaTutor_AutoCompleteExtender"
                                    runat="server"
                                    BehaviorID="cajaTutor_AutoCompleteExtender"
                                    DelimiterCharacters=""
                                    TargetControlID="cajaTutor"
                                    MinimumPrefixLength="1"
                                    CompletionInterval="10"
                                    CompletionSetCount="1"
                                    FirstRowSelected="false"
                                    ServiceMethod="GetNombresTutores">
                                </ajaxToolkit:AutoCompleteExtender>
                            </div>
                        </div>
                        <div class="row mt-4 justify-content-center">
                            <div class="col-md-auto input-group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <i>Área</i>
                                    </div>
                                </div>
                                <asp:DropDownList ID="desplegableArea" AutoPostBack="true" runat="server" CssClass="form-control" DataSourceID="AreasSource" DataTextField="Area" DataValueField="Area">
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="AreasSource" runat="server" SelectMethod="GetAreasSrc" TypeName="Buscador"></asp:ObjectDataSource>
                            </div>
                        </div>
                        <div class="row mt-4 text-center">
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
                    <div class="card-footer text-center">
                        <asp:LinkButton CssClass="btn btn-info" ID="botonFiltrar" Width="50%" runat="server">
                            <i class="fa fa-filter mr-2"></i>Filtrar
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
            <div class="col-lg-8">
                <h1 class="text-center"><strong>Cursos</strong></h1>
                <div class="table-responsive">
                    <table class="table text-center">
                        <asp:GridView ID="tablaCursos" PagerStyle-HorizontalAlign="Center" HorizontalAlign="Center" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="CursosSource" OnRowDataBound="tablaCursos_RowDataBound" AllowPaging="True" DataKeyNames="Id">
                            <Columns>
                                <asp:BoundField DataField="Area" HeaderText="Área" SortExpression="Area" HtmlEncode="False">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Nombre" HeaderText="Curso" SortExpression="Nombre">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Creador" HeaderText="Usuario" SortExpression="Creador">
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
                <asp:ObjectDataSource ID="CursosSource" runat="server" SelectMethod="GetCursos" TypeName="Buscador">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="cajaBuscador" Name="curso" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="cajaTutor" Name="tutor" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="desplegableArea" DefaultValue="Seleccionar" Name="area" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="estrellas" Name="puntuacion" PropertyName="Calificacion" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div>
        </div>
    </div>
</asp:Content>

