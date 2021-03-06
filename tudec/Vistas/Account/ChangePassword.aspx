﻿<%@ Page Title="Cambiar Contraseña" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ChangePassword.aspx.cs" Inherits="Vistas_Account_ChangePassword" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <br />
    <br />
    <br />
    <br />
    <br />

    <div class="container">
        <div class="form-group row justify-content-center">
            <div class=" form-group col-md-6">
                <br />
                <h2 style="text-align: center; color: #000000; font-size: x-large;"><strong>Cambiar Contraseña</strong></h2>
                <br />
                <div class="col-12 input-group justify-content-center">
                    <asp:RegularExpressionValidator ID="validarCaracteresPass"
                        runat="server" ErrorMessage="La contraseña debe contener entre 8 y 20 caracteres."
                        ControlToValidate="cajaPass" CssClass="alertHome alert-danger" Display="Dynamic"
                        ValidationExpression="^[a-zA-Z0-9'@&#.\S]{8,20}$" />
                </div>
                <div class="col-12 input-group justify-content-center">
                    <asp:Label ID="LB_Validacion" runat="server" Visible="False"></asp:Label>
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
                        ValidationGroup="cambio"
                        SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                </div>
                <br />
                <div class="col-12 input-group">
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <i class="fa fa-key"></i>
                        </div>
                    </div>
                    <asp:TextBox ID="cajaConfirmarPass" placeHolder="Confirmar Contraseña" runat="server"
                        TextMode="Password" CssClass="form-control" />
                </div>

                <div class="col-12 input-group justify-content-center">
                    <asp:RequiredFieldValidator ID="confirmarPassRequerida"
                        runat="server"
                        ControlToValidate="cajaConfirmarPass"
                        ErrorMessage="¡requerido!" ValidationGroup="cambio"
                        SetFocusOnError="True"
                        Display="Dynamic" CssClass="text-danger" />
                </div>
                <br />
                <div class="col-12 input-group justify-content-center">
                    <asp:CompareValidator ID="comparePasswords"
                        runat="server"
                        ControlToCompare="cajaPass" ValidationGroup="cambio"
                        ControlToValidate="cajaConfirmarPass"
                        ErrorMessage="Las contraseñas no son iguales!"
                        Display="Dynamic" CssClass="alertHome alert-danger" />
                </div>
                <div class="form-group col-12">
                    <strong>
                        <asp:Button runat="server" OnClick="btnRestablecer_Click"  ValidationGroup="cambio" Text="Cambiar Contraseña"
                            CssClass="btn btn-dark btn-lg btn-block" Style="font-size: medium;" />
                    </strong>
                </div>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            window.setTimeout(function () {
                $(".alert").fadeTo(1000, 0).slideUp(800, function () {
                    {
                        window.top.location = "Login.aspx"
                    }
                    $(this).remove();
                });
            }, 3000);

        });
    </script>
</asp:Content>

