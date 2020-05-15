<%@ Page Title="Configuración de la cuenta" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Settings.aspx.cs" Inherits="Vistas_Account_Settings" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <div class="container mt-5" style="padding-bottom: 10%">
        <br />
        <br />
        <br />
        <br />
        <div class="row justify-content-between">
            <div class="col-lg-3 mt-5">
                <div class="card">
                    <div class="card-header">
                        <div class="row justify-content-center">
                            <asp:Image ID="ImagenPerfil" CssClass="card-img rounded-circle" Width="150px" Height="150px" runat="server" />
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row justify-content-center">
                            <h4 class="card-title">
                                <asp:Label Text="text" ID="LbNombreUsuario" runat="server" /></h4>
                        </div>
                        <div class="nav flex-column nav-pills" id="tabConfiguracion" role="tablist" aria-orientation="vertical">
                            <a class="nav-link" id="profile-tab" data-toggle="tab" href="#tab-profile" role="tab" aria-controls="tab-profile" aria-selected="false"><i class="fa fa-user-circle mr-2"></i>Mi Perfil</a>
                            <a class="nav-link" id="photography-tab" data-toggle="tab" href="#tab-photography" role="tab" aria-controls="tab-photography" aria-selected="false"><i class="fa fa-camera mr-2"></i>Fotografia</a>
                            <a class="nav-link" id="pass-tab" data-toggle="tab" href="#tab-pass" role="tab" aria-controls="tab-pass" aria-selected="false"><i class="fas fa-key mr-2"></i>Cambiar Contraseña</a>
                        </div>
                    </div>
                    <div class="card-footer">
                        <p style="text-align: center"><%: DateTime.Now.ToString("dd-MM-yyyy")%></p>
                    </div>
                </div>
            </div>
            <div class="col-lg-8 mt-5">
                <div class="tab-content" id="v-pills-tabContent">
                    <div class="tab-pane fade" id="tab-profile" role="tabpanel" aria-labelledby="profile-tab">
                        <div class="card">
                            <div class="card-header">
                                <h2 style="text-align: center; color: #000000; font-size: x-large;"><strong>Mi Perfil</strong></h2>
                            </div>
                            <div class="card-body">
                                <div class="row justify-content-center">
                                    <asp:Label ID="LB_validarGuardado" runat="server" CssClass="alert alert-success" Visible="false"></asp:Label>
                                </div>
                                <br />
                                <div class="row justify-content-center">
                                    <label for="TB_nombreUsuario" class="col-sm-4 col-form-label"><strong>Nombre de usuario</strong></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox runat="server" ID="TB_nombreUsuario" Enabled="false" CssClass="form-control" />
                                    </div>
                                </div>
                                <br />
                                <div class="row justify-content-center">
                                    <label for="TB_correoInstitucional" class="col-sm-4 col-form-label"><strong>Correo Institucional</strong></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox runat="server" ID="TB_correoInstitucional" Enabled="false" CssClass="form-control" />
                                    </div>
                                </div>
                                <br />
                                <div class="row justify-content-center">
                                    <label for="TB_nombreCompleto" class="col-sm-4 col-form-label"><strong>Nombre</strong></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox runat="server" ID="TB_nombreCompleto" Enabled="false" CssClass="form-control" />
                                    </div>
                                </div>
                                <br />
                                <div class="row justify-content-center">
                                    <label for="TB_descripcionUsuario" class="col-sm-4 col-form-label"><strong>Descripción</strong></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox runat="server" ID="TB_descripcionUsuario" CssClass="form-control" TextMode="MultiLine" />
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="row justify-content-center">
                                    <strong>
                                        <asp:Button runat="server" ID="BtnGuardarPerfil" OnClick="BtnGuardarPerfil_Click" Text="Guardar"
                                            CssClass="btn btn-info" Style="font-size: medium;" />
                                    </strong>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="tab-pane fade" id="tab-photography" role="tabpanel" aria-labelledby="photography-tab">
                        <div class="card">
                            <div class="card-header">
                                <h2 style="text-align: center; color: #000000; font-size: x-large;"><strong>Fotografía </strong></h2>
                            </div>
                            <div class="card-body">
                                <div class="row justify-content-center">
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="subirImagen"
                                        ErrorMessage="tiene una extensión no válida. Extensiones válidas: gif, jpg, jpeg, png."
                                        Font-Size="Medium" CssClass="alertHome alert-danger" Display="Dynamic"
                                        ValidationExpression="(.*?)\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)$" />
                                </div>
                                <div class="row justify-content-center">
                                    <asp:Label ID="LB_subioImagen" runat="server" Visible="false"></asp:Label>
                                </div>
                                <div class="card-text text-center">
                                    <i class="fa fa-upload btn btn-secondary">
                                        <asp:FileUpload ID="subirImagen" CssClass="btn btn-secondary btn-sm"  ToolTip="Subir Imagen" accept=".png,.jpg,.jpeg,.gif" runat="server" />
                                    </i>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="row justify-content-center">
                                    <strong>
                                        <asp:Button runat="server" ID="BtnGuardarImagen" OnClick="BtnGuardarImagen_Click" Text="Guardar"
                                            CssClass="btn btn-info" Style="font-size: medium;" />
                                    </strong>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="tab-pass" role="tabpanel" aria-labelledby="pass-tab">
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
                                    <asp:TextBox ID="passNueva" placeHolder="Contraseña Nueva" runat="server" ValidationGroup="passwords"
                                        TextMode="Password" CssClass="form-control" />
                                </div>
                                <div class="col-12 input-group justify-content-center">
                                    <asp:RequiredFieldValidator ID="passRequerida"
                                        runat="server"
                                        ControlToValidate="passNueva"
                                        ErrorMessage="¡requerido!"
                                        ValidationGroup="passwords"
                                        SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                                </div>
                                <br />
                                <div class="col-12 input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <i class="fa fa-key"></i>
                                        </div>
                                    </div>
                                    <asp:TextBox ID="confirmarPassNueva" placeHolder="Confirmar Contraseña Nueva" ValidationGroup="passwords" runat="server"
                                        TextMode="Password" CssClass="form-control" />
                                </div>

                                <div class="col-12 input-group justify-content-center">
                                    <asp:RequiredFieldValidator ID="confirmarPassRequerida"
                                        runat="server"
                                        ControlToValidate="confirmarPassNueva"
                                        ErrorMessage="¡requerido!"
                                        SetFocusOnError="True"
                                        ValidationGroup="passwords"
                                        Display="Dynamic" CssClass="text-danger" />
                                </div>
                                <br />
                                <div class="col-12 input-group justify-content-center">
                                    <asp:CompareValidator ID="comparePasswords"
                                        runat="server"
                                        ValidationGroup="passwords"
                                        ControlToCompare="passNueva"
                                        ControlToValidate="confirmarPassNueva"
                                        ErrorMessage="Las contraseñas no son iguales!"
                                        Display="Dynamic" CssClass="alertHome alert-danger" />
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="row justify-content-center">
                                    <strong>
                                        <asp:Button runat="server" ID="BtnCambiarPass" ValidationGroup="passwords" OnClick="BtnCambiarPass_Click" Text="Cambiar Contraseña"
                                            CssClass="btn btn-info" Style="font-size: medium;" />
                                        <asp:HiddenField ID="TabName" runat="server" />
                                    </strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- //SCRIPT Para dejar activo el tab que inicia y cuando un boton se ejecuta por medio del onclick-->
    <script>
        $(function () {
            var tabName = $("[id*=TabName]").val() != "" ? $("[id*=TabName]").val() : "tab-profile";
            $('#tabConfiguracion a[href="#' + tabName + '"]').tab('show');
            $("#tabConfiguracion a").click(function () {
                $("[id*=TabName]").val($(this).attr("href").replace("#", ""));
            });
        });
    </script>
</asp:Content>

