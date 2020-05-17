<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/InformacionDelCurso.aspx.cs" Inherits="Vistas_Cursos_InformacionDelCurso" %>

<%@ Register Src="~/Controles/Comentarios/CajaComentarios.ascx" TagPrefix="uc1" TagName="CajaComentarios" %>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />
    <br />
    <br />
    <br />
    <br />
    <div class="container-fluid mt-5 mb-4">
        <div class="row justify-content-around">
            <div class="col-lg-auto mb-5">
                <div class="card mt-4">
                    <div class="card-header text-center">
                        <h4 class="text-success"><strong>CREADO POR: </strong></h4>
                        <asp:Label Style="color: #2D732D;" Text="NombreDeUsuario" runat="server" ID="etiquetaNombreUsuario" />
                    </div>
                    <div class="card-body text-center">
                        <asp:Label Text="Nombre" runat="server" ID="etiquetaNombre" />
                        <br />
                        <asp:Label Text="CorreoUsuario" runat="server" ID="etiquetaCorreo" />
                        <br />
                        <asp:Image ImageUrl="Ícono" runat="server" ID="imagenArea" />
                        <br />
                        <asp:Label Text="área" runat="server" ID="etiquetaArea" />
                    </div>

                </div>
                <div class="card-footer text-center">
                    <asp:LinkButton Text="¡Habla Conmigo!" runat="server" CssClass="btn btn-dark" ID="botonInbox" />
                    <asp:LinkButton Text="Inscribirse" runat="server" BackColor="#003300" CssClass="btn btn-info" ForeColor="White" ID="botonInscribirse" />
                </div>
            </div>
            <div class="col-lg-6 text-center">
                <asp:Label Style="color: #2D732D; font-size: 40px" CssClass="text-center" Text="TituloCurso" runat="server" ID="etiquetaTitulo" />
                <div class="table-responsive">
                    <table class="table">
                        <asp:GridView ID="tablaTemas" Width="100%" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="TemasDataSource" OnRowDataBound="tablaTemas_RowDataBound" AllowPaging="True" DataKeyNames="Id">
                            <Columns>
                                <asp:BoundField DataField="Titulo" HeaderText="Título" SortExpression="Titulo" />
                            </Columns>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="TemasDataSource" runat="server" SelectMethod="GetTemas" TypeName="GestionTemas">
                            <SelectParameters>
                                <asp:SessionParameter Name="curso" SessionField="cursoSeleccionado" Type="Object" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="container text-center">
        <div class="row justify-content-end">
            <div class="col-lg-6">
                <h5 class="mb-4"><strong>Descripción Del Curso</strong></h5>
                <asp:TextBox Enabled="false" ID="campoDescripcion" runat="server" TextMode="MultiLine"></asp:TextBox>
            </div>
        </div>
        <br />
        <br />
        <asp:Label ID="etiquetaComentarios" Font-Size="X-Large" CssClass="text-info" runat="server"><strong> Comentarios</strong></asp:Label>
        <uc1:CajaComentarios runat="server" ID="CajaComentarios" />
    </div>
</asp:Content>

