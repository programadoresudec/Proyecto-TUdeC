<%@ Control Language="C#" AutoEventWireup="true" CodeFile="InterfazInscribirseCurso.ascx.cs" Inherits="Controles_InterfazInscribirseCurso_InterfazInscribirseCurso" %>
<div class="container h-100 mt-5" style="padding-top: 10%">
    <div class="row justify-content-center h-100">
        <div class="col-lg-4">

            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="modal-header text-center">
                            <i class="fas fa-badge-check fa-2x"><strong>Inscripción</strong></i>
                            <asp:LinkButton ID="botonCancelar" runat="server" ForeColor="Red" OnClick="botonCancelar_Click">
                                <i class="fas fa-times-circle fa-lg"></i>
                            </asp:LinkButton>
                        </div>
                        <div class="row justify-content-center mt-2 mb-2">
                            <asp:Label ID="LB_Validacion" runat="server" Visible="false"></asp:Label>
                        </div>

                        <asp:TextBox ID="cajaCodigo" placeholder="Código" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                    <div class="modal-footer text-center">
                        <asp:LinkButton ID="botonInscribirse" CssClass="btn btn-success" runat="server" OnClick="botonInscribirse_Click">
                           <strong>Inscribirse</strong><i class="fas fa-share ml-2"></i>
                        </asp:LinkButton>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        window.setTimeout(function () {
            $(".alert").fadeTo(1000, 0).slideUp(500, function () {
                {
                    window.top.location = "InformacionDelCurso.aspx"
                }
                $(this).remove();
            });
        }, 1000);

    });
</script>
<script>
    $(document).ready(function () {
        window.setTimeout(function () {
            $(".alertHome").fadeTo(1500, 0).slideDown(500, function () {
                $(this).remove();
            });
        }, 1000);
    });
</script>
