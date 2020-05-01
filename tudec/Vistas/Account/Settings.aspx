<%@ Page Title="Configuración de la cuenta" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Settings.aspx.cs" Inherits="Vistas_Account_Settings" %>


<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">

    <div class="container mt-5" style="padding-bottom: 10%">
        <br />
        <br />
        <br />
        <br />
        <div class="row justify-content-between">
            <div class="col-md-3 mt-4">
                <div class="card">
                    <div class="card-header">
                        <div class="row justify-content-center">
                            <asp:Image ID="ImagenPerfil" CssClass="card-img rounded-circle" Width="150px" runat="server" />
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row justify-content-center">
                            <h4 class="card-title">
                                <asp:Label Text="text" ID="LbNombreUsuario" runat="server" /></h4>
                        </div>
                        <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                            <a class="nav-link active" id="v-pills-profile-tab" data-toggle="pill" href="#v-pills-profile" role="tab" aria-controls="v-pills-profile" aria-selected="false"><i class="fa fa-user-circle mr-2"></i>Mi Perfil</a>
                            <a class="nav-link" id="v-pills-photography-tab" data-toggle="pill" href="#v-pills-photography" role="tab" aria-controls="v-pills-photography" aria-selected="false"><i class="fa fa-camera mr-2"></i>Fotografia</a>
                            <a class="nav-link" id="v-pills-pass-tab" data-toggle="pill" href="#v-pills-pass" role="tab" aria-controls="v-pills-pass" aria-selected="false"><i class="fas fa-key mr-2"></i>Cambiar Contraseña</a>
                        </div>
                    </div>
                    <div class="card-footer">
                    </div>
                </div>
            </div>
            <div class="col-md-8 mt-5">
                <div class="tab-content" id="v-pills-tabContent">
                    <div class="tab-pane fade show active" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                        <div class="card">
                            <div class="card-header">
                                <h2 style="text-align: center; color: #000000; font-size: x-large;"><strong>Mi Perfil</strong></h2>
                            </div>
                            <div class="card-body">
                            </div>
                        </div>


                        <br />
                    </div>
                    <div class="tab-pane fade" id="v-pills-photography" role="tabpanel" aria-labelledby="v-pills-photography-tab">
                        <div class="card">
                            <div class="card-header">
                                <h2 style="text-align: center; color: #000000; font-size: x-large;"><strong>Fotografía </strong></h2>
                            </div>
                            <div class="card-body">
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="v-pills-pass" role="tabpanel" aria-labelledby="v-pills-pass-tab">
                        <div class="card">
                            <div class="card-header">
                                <h2 style="text-align: center; color: #000000; font-size: x-large;"><strong>Cambio De Contraseña</strong></h2>
                            </div>
                            <div class="card-body">
                                <div class="col-12 input-group justify-content-center">
                                    <asp:Label ID="LB_ValidacionPass" runat="server" Visible="false"></asp:Label>
                                </div>
                                <br />
                                <div class="col-12 input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <i class="fa fa-key"></i>
                                        </div>
                                    </div>
                                    <asp:TextBox ID="passActual" placeHolder="Contraseña Actual" runat="server"
                                        TextMode="Password" CssClass="form-control" />
                                </div>
                                <br />
                                <div class="col-12 input-group justify-content-center">
                                    <asp:RegularExpressionValidator ID="validarCaracteresPass"
                                        runat="server" ErrorMessage="La contraseña debe contener entre 8 y 20 caracteres."
                                        ControlToValidate="passNueva" CssClass="alertHome alert-danger" Display="Dynamic"
                                        ValidationExpression="^[a-zA-Z0-9'@&#.\S]{8,20}$" />
                                </div>

                                <div class="col-12 input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <i class="fa fa-key"></i>
                                        </div>
                                    </div>
                                    <asp:TextBox ID="passNueva" placeHolder="Contraseña Nueva" runat="server"
                                        TextMode="Password" CssClass="form-control" />
                                </div>
                                <div class="col-12 input-group justify-content-center">
                                    <asp:RequiredFieldValidator ID="passRequerida"
                                        runat="server"
                                        ControlToValidate="passNueva"
                                        ErrorMessage="¡requerido!"
                                        SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                                </div>
                                <br />
                                <div class="col-12 input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <i class="fa fa-key"></i>
                                        </div>
                                    </div>
                                    <asp:TextBox ID="confirmarPassNueva" placeHolder="Confirmar Contraseña Nueva" runat="server"
                                        TextMode="Password" CssClass="form-control" />
                                </div>

                                <div class="col-12 input-group justify-content-center">
                                    <asp:RequiredFieldValidator ID="confirmarPassRequerida"
                                        runat="server"
                                        ControlToValidate="confirmarPassNueva"
                                        ErrorMessage="¡requerido!"
                                        SetFocusOnError="True"
                                        Display="Dynamic" CssClass="text-danger" />
                                </div>
                                <br />
                                <div class="col-12 input-group justify-content-center">
                                    <asp:CompareValidator ID="comparePasswords"
                                        runat="server"
                                        ControlToCompare="passNueva"
                                        ControlToValidate="confirmarPassNueva"
                                        ErrorMessage="Las contraseñas no son iguales!"
                                        Display="Dynamic" CssClass="alertHome alert-danger" />
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class=" col-12">
                                    <strong>
                                        <asp:Button runat="server" ID="BtnCambiarPass" OnClick="BtnCambiarPass_Click" Text="Cambiar Contraseña"
                                            CssClass="btn btn-dark btn-lg btn-block" Style="font-size: medium;" />
                                    </strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="TabName" runat="server" />
    <script>
        $(function () {
            var tabName = $("[id*=TabName]").val() != "" ? $("[id*=TabName]").val() : "v-pills-profile";
            $('#v-pills-tab a[href="#' + tabName + '"]').tab('show');
            $("#v-pills-tab a").click(function () {
                $("[id*=TabName]").val($(this).attr("href").replace("#", ""));
            });
        });
    </script>
</asp:Content>

