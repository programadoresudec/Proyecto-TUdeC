<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Settings.aspx.cs" Inherits="Vistas_Account_Settings" %>


<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">

    <div class="container">
        <br />
        <br />
        <br />
        <br />
        <br />
        <div class="row justify-content-start">
            <div class="col-md-3 mt-4">
                <div class="card">
                    <asp:Image ID="ImagenPerfil" CssClass="card-img" Width="120px" ImageUrl="~/Recursos/Imagenes/PerfilUsuarios/DefaultUsuario.jpg" runat="server" />
                    <div class="card-body">
                        <h4 class="card-title">John Doe</h4>
                        <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                            <a class="nav-link active" id="v-pills-profile-tab" data-toggle="pill" href="#v-pills-profile" role="tab" aria-controls="v-pills-profile" aria-selected="false"><i class="fa fa-user-circle mr-2"></i>Mi Perfil</a>
                            <a class="nav-link" id="v-pills-messages-tab" data-toggle="pill" href="#v-pills-messages" role="tab" aria-controls="v-pills-messages" aria-selected="false"><i class="fa fa-camera mr-2"></i>Fotografia</a>
                            <a class="nav-link" id="v-pills-settings-tab" data-toggle="pill" href="#v-pills-settings" role="tab" aria-controls="v-pills-settings" aria-selected="false"><i class="fas fa-key mr-2"></i>Cambiar Contraseña</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-8 mt-2">
                <div class="card">
                    <div class="card-body">
                        <div class="tab-content" id="v-pills-tabContent">
                            <div class="tab-pane fade show active" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                                 <h2 style="text-align: center; color: #000000; font-size: x-large;"><strong>Mi Perfil
                                </strong></h2>
                                <br />
                            </div>
                            <div class="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab">
                                 <h2 style="text-align: center; color: #000000; font-size: x-large;"><strong>Fotografía
                                </strong></h2>
                                <br />
                            </div>
                            <div class="tab-pane fade" id="v-pills-settings" role="tabpanel" aria-labelledby="v-pills-settings-tab">
                                <h2 style="text-align: center; color: #000000; font-size: x-large;"><strong>Cambio De Contraseña
                                </strong></h2>
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
                                        ControlToValidate="cajaPass" CssClass="alertHome alert-danger" Display="Dynamic"
                                        ValidationExpression="^[a-zA-Z0-9'@&#.\S]{8,20}$" />
                                </div>
                                <div class="col-12 input-group justify-content-center">
                                    <asp:Label ID="LB_Validacion" runat="server" CssClass="alert alert-danger" Visible="False"></asp:Label>
                                </div>
                                <div class="col-12 input-group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <i class="fa fa-key"></i>
                                        </div>
                                    </div>
                                    <asp:TextBox ID="cajaPass" placeHolder="Contraseña Nueva" runat="server"
                                        TextMode="Password" CssClass="form-control" />
                                </div>
                                <div class="col-12 input-group justify-content-center">
                                    <asp:RequiredFieldValidator ID="passRequerida"
                                        runat="server"
                                        ControlToValidate="cajaPass"
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
                                    <asp:TextBox ID="cajaConfirmarPass" placeHolder="Confirmar Contraseña Nueva" runat="server"
                                        TextMode="Password" CssClass="form-control" />
                                </div>

                                <div class="col-12 input-group justify-content-center">
                                    <asp:RequiredFieldValidator ID="confirmarPassRequerida"
                                        runat="server"
                                        ControlToValidate="cajaConfirmarPass"
                                        ErrorMessage="¡requerido!"
                                        SetFocusOnError="True"
                                        Display="Dynamic" CssClass="text-danger" />
                                </div>
                                <br />
                                <div class="col-12 input-group justify-content-center">
                                    <asp:CompareValidator ID="comparePasswords"
                                        runat="server"
                                        ControlToCompare="cajaPass"
                                        ControlToValidate="cajaConfirmarPass"
                                        ErrorMessage="Las contraseñas no son iguales!"
                                        Display="Dynamic" CssClass="alertHome alert-danger" />
                                </div>
                                <div class="form-group col-12">
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
</asp:Content>

