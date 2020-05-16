<%@ Page Title="Sugerencias" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/VisualizacionDeSugerencias.aspx.cs" Inherits="Vistas_VisualizacionDeSugerencias" %>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <br />
    <br />
    <div class="container mt-5">

        <div class="row justify-content-center mt-5">
            <h1 class="w3l_header text-center mb-4 mt-5"><strong>Sugerencias</strong></h1>
        </div>
        <div class="form-row justify-content-center">
            <div class="col-mb-6 text-center mb-4">
                <div class="input-group">
                     <asp:TextBox ID="cajaBuscador" runat="server" CssClass="fa fa-search form-control" Width="200px" placeHolder="Buscar"></asp:TextBox>
                    <ajaxToolkit:AutoCompleteExtender
                        MinimumPrefixLength="1"
                        CompletionInterval="10"
                        CompletionSetCount="1"
                        FirstRowSelected="false"
                        ID="cajaBuscador_AutoCompleteExtender"
                        runat="server"
                        ServiceMethod="GetTitulosSugerencias"
                        TargetControlID="cajaBuscador" />
                    <div class="input-group-append">
                         <asp:LinkButton CssClass="btn btn-info" runat="server"> <i class="fa fa-search"></i></asp:LinkButton> 
                    </div>
                </div>
            </div>
            <div class="col-mb-6">
                <div class="row">
                    <div class="col-lg-auto mb-4">
                        <asp:DropDownList ID="desplegableLectura" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="desplegableLectura_SelectedIndexChanged">
                            <asp:ListItem>Estado de lectura</asp:ListItem>
                            <asp:ListItem>Leídos</asp:ListItem>
                            <asp:ListItem>No leídos</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="table-responsive">
                <table class="table">
                    <asp:GridView ID="tablaSugerencias" CssClass="tablas" runat="server" HorizontalAlign="Center" AutoGenerateColumns="False" DataSourceID="SugerenciasSource" OnRowDataBound="tablaSugerencias_RowDataBound" AllowPaging="True">
                        <PagerStyle HorizontalAlign="Center" />
                        <Columns>
                            <asp:BoundField DataField="Emisor" HeaderText="Emisor" SortExpression="Emisor">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Titulo" HeaderText="Título" SortExpression="Titulo">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:CheckBoxField DataField="Estado" HeaderText="Estado de lectura" SortExpression="Estado">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:CheckBoxField>
                            <asp:BoundField DataField="Fecha" HeaderText="Fecha" SortExpression="Fecha">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Ver detalles">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="SugerenciasSource" runat="server" SelectMethod="GetSugerencias" TypeName="Sugerencia">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="desplegableLectura" Name="filtro" PropertyName="SelectedValue" Type="String" />
                            <asp:ControlParameter ControlID="cajaBuscador" Name="titulo" PropertyName="Text" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </table>
            </div>
        </div>
    </div>
</asp:Content>

