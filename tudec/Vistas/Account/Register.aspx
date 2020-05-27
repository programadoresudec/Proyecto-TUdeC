<%@ Page Title="Registrar" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Register.aspx.cs" Inherits="Views_Account_Register" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <div class="container">
        <br />
        <br />
        <br />
        <br />
        <br />
        <h2 style="text-align: center; color: darkblue; font-size: x-large;"><strong>Crear Nueva Cuenta</strong></h2>
        <br />
        <div class="row justify-content-center">
            <div class=" form-group col-md-auto">
                <div class="row justify-content-center">
                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorNombreUsuario"
                        runat="server" ErrorMessage="El apodo solo puede contener letras, números, guiones y guiones bajos."
                        ControlToValidate="cajaNombreUsuario" Display="Dynamic" CssClass="alertHome alert-danger"
                        ValidationExpression="[A-Za-z0-9-_ñÑ]*$" ValidationGroup="register" />
                </div>
                <asp:RequiredFieldValidator ID="NombreUsuarioRequerido"
                    runat="server" ValidationGroup="register"
                    ControlToValidate="cajaNombreUsuario"
                    ErrorMessage="¡apodo requerido!"
                    SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                <div class="row justify-content-center ">
                    <div class="col-12 input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <i class="fa fa-user"></i>
                            </div>
                        </div>
                        <asp:TextBox ID="cajaNombreUsuario" MaxLength="60" placeHolder="Nombre De Usuario (nick)" runat="server"
                            CssClass="form-control" ValidationGroup="register" />
                    </div>
                </div>
                <br />
                <asp:RequiredFieldValidator ID="NombreRequerido" runat="server"
                    ControlToValidate="cajaPrimerNombre" ValidationGroup="register"
                    ErrorMessage="¡Primer nombre requerido!"
                    SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <ajaxToolkit:FilteredTextBoxExtender ID="filtroPrimerNombre" runat="server"
                            TargetControlID="cajaPrimerNombre" FilterType="LowercaseLetters, UppercaseLetters, Custom" FilterMode="ValidChars" ValidChars="[ñÑáéíóúÁÉÍÓÚ]"/>
                        <asp:TextBox ID="cajaPrimerNombre" MaxLength="40" runat="server" placeHolder="Primer Nombre" CssClass="mb-4 form-control" />
                    </div>
                    <div class="col-md-6">
                        <ajaxToolkit:FilteredTextBoxExtender ID="FiltroSegundoNombre" runat="server" FilterType="LowercaseLetters, UppercaseLetters, Custom"
                            TargetControlID="cajaSegundoNombre" FilterMode="ValidChars" ValidChars="[ñÑáéíóúÁÉÍÓÚ]"/>
                        <asp:TextBox ID="cajaSegundoNombre"  MaxLength="50" runat="server" placeHolder="Segundo Nombre" CssClass="mb-4 form-control" />
                    </div>
                </div>
                <asp:RequiredFieldValidator ID="ApellidoRequerido" runat="server"
                    ControlToValidate="cajaPrimerApellido"
                    ErrorMessage="¡Primer apellido requerido!" ValidationGroup="register"
                    SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <ajaxToolkit:FilteredTextBoxExtender ID="FiltroPrimerApellido" runat="server"
                            TargetControlID="cajaPrimerApellido" FilterType="LowercaseLetters, UppercaseLetters, Custom" FilterMode="ValidChars" ValidChars="[ñÑáéíóúÁÉÍÓÚ]"/>
                        <asp:TextBox ID="cajaPrimerApellido" MaxLength="40" ValidationGroup="register" runat="server" placeHolder="Primer Apellido" CssClass="mb-4 form-control" />
                    </div>
                    <div class="col-md-6">
                        <ajaxToolkit:FilteredTextBoxExtender ID="FiltroSegundoApellido" runat="server"
                            TargetControlID="cajaSegundoApellido" FilterType="LowercaseLetters, UppercaseLetters, Custom" FilterMode="ValidChars" ValidChars="[ñÑáéíóúÁÉÍÓÚ]" />
                        <asp:TextBox ID="cajaSegundoApellido" MaxLength="40" runat="server" placeHolder="Segundo Apellido" CssClass="mb-4 form-control" />
                    </div>
                </div>
                <asp:RequiredFieldValidator ID="emailRequerido" runat="server"
                    ControlToValidate="cajaEmail"
                    ErrorMessage="¡requerido!" ValidationGroup="register"
                    SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                <div class="row justify-content-center">
                    <div class="col-12 input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <i class="fa fa-envelope"></i>
                            </div>
                        </div>
                        <ajaxToolkit:FilteredTextBoxExtender ID="FiltrarCaja" runat="server"
                            TargetControlID="cajaEmail" FilterType="LowercaseLetters, UppercaseLetters, Numbers, Custom" FilterMode="ValidChars" ValidChars="[ñÑáéíóúÁÉÍÓÚ]"/>
                        <asp:TextBox ID="cajaEmail" MaxLength="30" runat="server" ValidationGroup="register" placeHolder="E-mail" CssClass="form-control" />
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <i>@ucundinamarca.edu.co</i>
                            </div>
                        </div>
                    </div>
                </div>
                <br />
                <div class="row justify-content-center">
                    <asp:RegularExpressionValidator ID="validarCaracteresPass"
                        runat="server" ErrorMessage="La contraseña debe contener entre 8 y 20 caracteres."
                        ControlToValidate="cajaPass" Display="Dynamic" CssClass="alertHome alert-danger"
                        ValidationExpression="^[a-zA-Z0-9'@&#.\S]{8,20}$" ValidationGroup="register"/>
                </div>
                <asp:RequiredFieldValidator ID="passRequerida"
                    runat="server"
                    ControlToValidate="cajaPass"
                    ErrorMessage="¡requerido!" ValidationGroup="register"
                    SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                <div class="row justify-content-center">
                    <div class="col-12 input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <i class="fa fa-key"></i>
                            </div>
                        </div>
                        <asp:TextBox ID="cajaPass" placeHolder="Contraseña" runat="server"
                            TextMode="Password" CssClass="form-control" ValidationGroup="register" />
                    </div>
                </div>
                <br />
                <asp:RequiredFieldValidator ID="confirmarPassRequerida"
                    runat="server"
                    ControlToValidate="cajaConfirmarPass"
                    ErrorMessage="¡requerido!" ValidationGroup="register"
                    SetFocusOnError="True"
                    Display="Dynamic" CssClass="text-danger" />
                <div class="row justify-content-center">
                    <div class="col-12 input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <i class="fa fa-key"></i>
                            </div>
                        </div>
                        <asp:TextBox ID="cajaConfirmarPass" placeHolder="Confirmar Contraseña" runat="server"
                            TextMode="Password" CssClass="form-control" ValidationGroup="register" />
                   </div>
                </div>
                <br />
                <div class="row justify-content-center">
                    <asp:CompareValidator ID="comparePasswords"
                        runat="server" ValidationGroup="register"
                        ControlToCompare="cajaPass"
                        ControlToValidate="cajaConfirmarPass"
                        ErrorMessage="¡Las contraseñas no son iguales!"
                        Display="Dynamic" CssClass="alertHome alert-danger" />
                </div>

                <div class="form-group row">
                    <div class="col-12">
                        <strong>
                            <asp:Button runat="server" OnClick="btnRegistrar_Click" ValidationGroup="register" Text="Registrar"
                                CssClass="btn btn-dark btn-lg btn-block" Style="font-size: medium;" />
                        </strong>
                    </div>
                </div>

                <div class="form-group row justify-content-center">
                    <asp:Label ID="labelValidar" runat="server" Visible="False"></asp:Label>
                </div>
            </div>
        </div>
    </div>
      <script>
        $(document).ready(function () {
            window.setTimeout(function () {
                $(".alert").fadeTo(1000, 0).slideUp(500, function () {
                    {
                        window.location.href = "Login.aspx"
                    }
                    $(this).remove();
                });
            }, 2000);

        });
    </script>
</asp:Content>

