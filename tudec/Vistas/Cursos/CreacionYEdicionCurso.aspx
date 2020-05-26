<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/CreacionYEdicionCurso.aspx.cs" Inherits="Vistas_Cursos_CreacionYEdicionCurso" %>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" runat="Server">
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
    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="row justify-content-center">
                    <asp:Label runat="server" ID="Lb_validacion" Visible="false"> <strong>¡Error! Debe escoger un área de conocimiento.</strong></asp:Label>
                </div>
                <div class="row justify-content-center">
                    <asp:Label runat="server" ID="LB_editado" Visible="false"> <strong>¡Satisfactorio! Su curso se ha editado.</strong> </asp:Label>
                </div>
                <div class="row justify-content-center" id="creado">
                    <asp:Label runat="server" ID="LB_creado" Width="100%" Visible="false"></asp:Label>
                </div>
                <div class="row justify-content-center mb-4">
                    <asp:Label CssClass="fa fa-plus-circle fa-3x" ID="etiquetaCrearCurso" runat="server" Text="Crear curso"></asp:Label>
                </div>
                <div class="row justify-content-center mb-4">
                    <div class="col input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <i class="fas fa-heading">
                                    <label>Título</label>
                                </i>
                            </div>
                        </div>
                        <ajaxToolkit:FilteredTextBoxExtender runat="server" TargetControlID="cajaTitulo" ID="cajaTitulo_FilteredTextBoxExtender"
                            FilterType="LowercaseLetters, UppercaseLetters, Numbers, Custom" FilterMode="ValidChars" ValidChars="[ñÑáéíóúÁÉÍÓÚ +-_#/()?¡!¿=$]" />
                        <asp:TextBox CssClass="form-control" ID="cajaTitulo" MaxLength="100" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="validadorCaja" CssClass="text-danger" Display="Dynamic" ControlToValidate="cajaTitulo" runat="server" ErrorMessage="*" ValidationGroup="creacionCurso" />
                    </div>
                </div>
                <div class="row justify-content-center">
                    <div class="col-lg-6 mb-4">
                        <asp:DropDownList CssClass="form-control" ID="desplegableArea" runat="server" DataSourceID="AreasDataSource"
                            DataTextField="Area" DataValueField="Area">
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="AreasDataSource" runat="server" SelectMethod="GetAreasSrc" TypeName="GestionCurso"></asp:ObjectDataSource>
                    </div>
                    <div class="col-lg-6">
                        <div class="col input-group">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <i class="fa fa-calendar-alt"></i>
                                </div>
                            </div>
                            <asp:TextBox ID="cajaFechaInicio" CssClass="form-control" placeholder="Fecha inicio" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="validadorFecha" Display="Dynamic" ControlToValidate="cajaFechaInicio" CssClass="text-danger" runat="server" ErrorMessage="*" ValidationGroup="creacionCurso"></asp:RequiredFieldValidator>
                            <ajaxToolkit:CalendarExtender ID="cajaFechaInicio_CalendarExtender" runat="server" Format="dd/MM/yyyy" BehaviorID="cajaFechaInicio_CalendarExtender" TargetControlID="cajaFechaInicio" />
                        </div>
                    </div>
                </div>
                <div class=" row justify-content-center mt-4">
                    <div class="col input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <i class="fa fa-file-alt fa-1x">
                                    <label class="ml-2">Descripción</label>
                                </i>
                            </div>
                        </div>
                        <asp:TextBox ID="cajaDescripcion" CssClass="form-control" Height="150px" runat="server" TextMode="MultiLine"></asp:TextBox>
                    </div>
                </div>
                <div class="row justify-content-center mt-4">
                    <asp:LinkButton ID="botonCrearCurso" CssClass="btn btn-success btn-lg" runat="server" Text="<strong>Crear curso</strong>" OnClick="botonCrearCurso_Click" ValidationGroup="creacionCurso" />
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            window.setTimeout(function () {
                $(".alertCursoEditado").fadeTo(1000, 0).slideUp(500, function () {
                    {
                        window.location.href = "ListaDeCursosCreadosDeLaCuenta.aspx"
                    }
                    $(this).remove();
                });
            }, 1000);

        });
    </script>

    <script>
        $(document).ready(function () {
            window.setTimeout(function () {
                $(".alertCursoCreado").fadeTo(1000, 0).slideUp(500, function () {
                    {
                        window.location.href = "ListaDeTemasDelCurso.aspx"
                    }
                    $(this).remove();
                });
            }, 1000);

        });
    </script>
</asp:Content>

