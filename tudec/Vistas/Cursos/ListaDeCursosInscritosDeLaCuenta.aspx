﻿<%@ Page Title="Cursos Inscritos" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeCursosInscritosDeLaCuenta.aspx.cs" Inherits="Vistas_ListaDeCursosInscritosDeLaCuenta" %>

<%@ Register Src="~/Controles/Estrellas/Estrellas.ascx" TagPrefix="uc1" TagName="Estrellas" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <br />
    <br />
    <br />
    <br />
    <br />
    <div class="container-fluid mt-5 mb-5">
        <div class="row justify-content-around">
            <div class="col-lg-auto mb-5">
                <div class="row justify-content-center">
                    <div class="col">
                        <asp:LinkButton CssClass="btn btn-outline-dark btn-block botones mr-2 " ID="botonCreados" runat="server" Text="Creados" OnClick="botonCreados_Click" />
                    </div>
                    <div class="col">
                        <asp:LinkButton CssClass="btn botonPulsado btn-block mr-2 disabled" ID="botonInscritos" runat="server" Text="Inscritos" />
                    </div>
                </div>
                <div class="card mt-4">
                    <div class="card-header">
                        <div class="col input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <i class="fa fa-search"></i>
                                </div>
                            </div>
                            <asp:TextBox CssClass=" form-control" ID="cajaBuscador" runat="server"
                                placeHolder="Nombre del curso"> </asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender MinimumPrefixLength="1" CompletionInterval="10"
                                CompletionSetCount="1" FirstRowSelected="false" ID="AutoCompleteExtender1"
                                runat="server" ServiceMethod="GetNombresCursos" TargetControlID="cajaBuscador" />
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row justify-content-center">
                            <asp:RegularExpressionValidator ID="RegularExpressionValidatorNombreUsuario"
                                runat="server" ErrorMessage="Ingrese una fecha valida." ValidationGroup="FechaCursosInscritos"
                                ControlToValidate="cajaFechaCreacion" Display="Dynamic" CssClass="alertHome alert-danger"
                                ValidationExpression="^([0-2][0-9]|3[0-1])(\/|-)(0[1-9]|1[0-2])\2(\d{4})$" />
                        </div>
                        <div class="col input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <i class="fa fa-calendar-alt"></i>
                                </div>
                            </div>
                            <asp:TextBox ID="cajaFechaCreacion" ValidationGroup="FechaCursosInscritos" CssClass="form-control" runat="server" placeHolder="Fecha de creación"></asp:TextBox>
                            <ajaxToolkit:CalendarExtender ID="cajaFechaCreacion_CalendarExtender" Format="dd/MM/yyyy" runat="server" BehaviorID="cajaFechaCreacion_CalendarExtender" TargetControlID="cajaFechaCreacion" />

                        </div>
                        <br />
                        <div class="row">
                            <asp:DropDownList ID="desplegableArea" runat="server" CssClass="form-control" DataTextField="Area" DataValueField="Area" DataSourceID="AreasSource">
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="AreasSource" runat="server" SelectMethod="GetAreasSrc" TypeName="GestionCurso"></asp:ObjectDataSource>
                        </div>
                        <br />
                        <div class="row">
                            <asp:TextBox ID="cajaTutor" runat="server" CssClass="form-control" placeHolder="Nombre del tutor"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender
                                ID="cajaTutor_AutoCompleteExtender"
                                runat="server" CompletionListItemCssClass="alert-link"
                                TargetControlID="cajaTutor"
                                MinimumPrefixLength="1"
                                CompletionInterval="10"
                                CompletionSetCount="1"
                                FirstRowSelected="false"
                                ServiceMethod="GetNombresTutores">
                            </ajaxToolkit:AutoCompleteExtender>
                        </div>
                    </div>
                </div>
                <div class="card-footer text-center">
                    <asp:LinkButton CssClass="btn btn-info" ValidationGroup="FechaCursosInscritos" ID="botonFiltrar" Width="50%" runat="server">
                            <i class="fa fa-filter mr-2"></i>Filtrar
                    </asp:LinkButton>
                </div>
            </div>
            <div class="col-lg-7">
                <h1 class="text-center"><strong>Cursos Inscritos</strong></h1>
                <div class="table-responsive">
                    <table class="table">
                        <asp:GridView ID="tablaCursos" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="CursosSource" OnRowDataBound="tablaCursos_RowCreated" Width="853px" AllowPaging="True" DataKeyNames="Id">
                            <Columns>
                                <asp:BoundField DataField="Nombre" HeaderText="Curso" SortExpression="Nombre">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Area" HeaderText="Área del<br/>conocimiento" SortExpression="Area" HtmlEncode="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="FechaCreacion" DataFormatString="{0:dd/MM/yyyy}" HeaderText="Fecha de<br/>Creación" SortExpression="FechaCreacion" HtmlEncode="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Creador" HeaderText="Tutor" SortExpression="Creador">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Puntuacion" HeaderText="Puntuación" SortExpression="Puntuacion">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Boleta de<br/>Calificaciones">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Chat">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Cancelar<br/>Inscripción">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </table>
                </div>
                <asp:ObjectDataSource ID="CursosSource" runat="server" SelectMethod="GetCursosInscritos" TypeName="GestionCurso">
                    <SelectParameters>
                        <asp:SessionParameter Name="usuario" SessionField="usuarioLogeado" Type="Object" />
                        <asp:ControlParameter ControlID="cajaBuscador" Name="nombre" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="cajaTutor" Name="tutor" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="cajaFechaCreacion" Name="fechaCreacion" PropertyName="Text" Type="String" DefaultValue="" />
                        <asp:ControlParameter ControlID="desplegableArea" Name="area" PropertyName="SelectedValue" Type="String" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div>
        </div>
    </div>
</asp:Content>

