<%@ Page Title="Calificación de Exámenes" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ListaDeTemasDelCurso.aspx.cs" Inherits="Vistas_Cursos_ListaDeTemasDelCurso" %>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <br />
    <br />
    <br />
    <br />
    <br />
    <div class="container flex-md-row mt-4">
        <asp:HyperLink ID="BtnDevolver" CssClass="btn btn-info" runat="server"
            NavigateUrl="~/Vistas/Cursos/ListaDeCursosCreadosDeLaCuenta.aspx" Style="font-size: medium;">
                    <i class="fas fa-arrow-alt-circle-left fa-lg"></i>
        </asp:HyperLink>
    </div>
    <div class="container mt-3 mb-5">
        <div class="row justify-content-center mt-5 mb-5">
            <div class="col-lg-8">
                <div class="row justify-content-center">
                    <div class="table-responsive text-center">
                        <table class="table">
                            <asp:GridView CssClass="tablas" PagerStyle-HorizontalAlign="Center" HorizontalAlign="Center" Width="100%" ID="tablaTemario" runat="server" AutoGenerateColumns="False" DataSourceID="temarioDataSource" AllowPaging="True" OnRowDataBound="tablaTemario_RowDataBound" DataKeyNames="Id">
                                <Columns>
                                    <asp:BoundField DataField="Titulo" HeaderText="Temas" SortExpression="Titulo" />
                                </Columns>
                            </asp:GridView>

                            <asp:ObjectDataSource ID="temarioDataSource" runat="server" SelectMethod="GetTemas" TypeName="GestionTemas">
                                <SelectParameters>
                                    <asp:SessionParameter Name="curso" SessionField="cursoSeleccionadoParaEditarTemas" Type="Object" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="row justify-content-center mt-4 mb-5">
            <div class="col-lg-auto">
                <asp:LinkButton ID="botonAgregarTema" runat="server" CssClass="btn btn-success btn-lg" OnClick="botonAgregarTema_Click"> 
                        <i class="fa fa-plus mr-2"></i> <strong>Agregar Tema</strong> </asp:LinkButton>
            </div>
        </div>
    </div>
</asp:Content>

