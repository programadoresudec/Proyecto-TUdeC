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
                        runat="server" ErrorMessage="El apodo contiene caracteres no válidos"
                        ControlToValidate="cajaNombreUsuario" Display="Dynamic" CssClass="alertHome alert-danger"
                        ValidationExpression="[A-Za-z0-9-_]*$" />
                </div>
                <asp:RequiredFieldValidator ID="NombreUsuarioRequerido"
                    runat="server"
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
                        <asp:TextBox ID="cajaNombreUsuario" placeHolder="Nombre De Usuario (nick)" runat="server"
                            CssClass="form-control" />
                    </div>
                </div>
            <br />
            <asp:RequiredFieldValidator ID="NombreRequerido" runat="server"
                ControlToValidate="cajaPrimerNombre"
                ErrorMessage="¡Primer nombre requerido!"
                SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />

            <div class="row justify-content-center">
                <div class="col-md-6">
                    <ajaxToolkit:FilteredTextBoxExtender ID="filtroPrimerNombre" runat="server"
                        TargetControlID="cajaPrimerNombre" FilterType="LowercaseLetters, UppercaseLetters" />
                    <asp:TextBox ID="cajaPrimerNombre" runat="server" placeHolder="Primer Nombre" CssClass="form-control" />
                </div>
                <div class="col-md-6">
                    <ajaxToolkit:FilteredTextBoxExtender ID="FiltroSegundoNombre" runat="server"
                        TargetControlID="cajaSegundoNombre" FilterType="LowercaseLetters, UppercaseLetters" />
                    <asp:TextBox ID="cajaSegundoNombre" runat="server" placeHolder="Segundo Nombre" CssClass="form-control" />
                </div>
            </div>
            <br />
            <asp:RequiredFieldValidator ID="ApellidoRequerido" runat="server"
                ControlToValidate="cajaPrimerApellido"
                ErrorMessage="¡Primer apellido requerido!"
                SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <ajaxToolkit:FilteredTextBoxExtender ID="FiltroPrimerApellido" runat="server"
                        TargetControlID="cajaPrimerApellido" FilterType="LowercaseLetters, UppercaseLetters" />
                    <asp:TextBox ID="cajaPrimerApellido" runat="server" placeHolder="Primer Apellido" CssClass="form-control" />
                </div>
                <div class="col-md-6">
                    <ajaxToolkit:FilteredTextBoxExtender ID="FiltroSegundoApellido" runat="server"
                        TargetControlID="cajaSegundoApellido" FilterType="LowercaseLetters, UppercaseLetters" />
                    <asp:TextBox ID="cajaSegundoApellido" runat="server" placeHolder="Segundo Apellido" CssClass="form-control" />
                </div>
            </div>
            <br />
            <asp:RequiredFieldValidator ID="emailRequerido" runat="server"
                ControlToValidate="cajaEmail"
                ErrorMessage="¡requerido!"
                SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
            <div class="row justify-content-center">
                <div class="col-12 input-group">
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <i class="fa fa-envelope"></i>
                        </div>
                    </div>
                    <asp:TextBox ID="cajaEmail" runat="server" placeHolder="Correo Institucional" CssClass="form-control" />
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
                    ValidationExpression="^[a-zA-Z0-9'@&#.\S]{8,20}$" />
            </div>
            <asp:RequiredFieldValidator ID="passRequerida"
                runat="server"
                ControlToValidate="cajaPass"
                ErrorMessage="¡requerido!"
                SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
            <div class="row justify-content-center">
                <div class="col-12 input-group">
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <i class="fa fa-key"></i>
                        </div>
                    </div>
                    <asp:TextBox ID="cajaPass" placeHolder="Contraseña" runat="server"
                        TextMode="Password" CssClass="form-control" />
                </div>
            </div>
            <br />
            <asp:RequiredFieldValidator ID="confirmarPassRequerida"
                runat="server"
                ControlToValidate="cajaConfirmarPass"
                ErrorMessage="¡requerido!"
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
                        TextMode="Password" CssClass="form-control" />
                </div>
            </div>
                <br />
            <div class="row justify-content-center">
                <asp:CompareValidator ID="comparePasswords"
                    runat="server"
                    ControlToCompare="cajaPass"
                    ControlToValidate="cajaConfirmarPass"
                    ErrorMessage="¡Las contraseñas no son iguales!"
                    Display="Dynamic" CssClass="alertHome alert-danger" />
            </div>
               
            <div class="form-group row">
                <div class="col-12">
                    <strong>
                        <asp:Button runat="server" OnClick="btnRegistrar_Click" TabIndex="-1" Text="Registrar"
                            CssClass="btn btn-dark btn-lg btn-block" Style="font-size: medium;"/>
                    </strong>
                </div>
            </div>

            <div class="form-group row justify-content-center">
                <asp:Label ID="labelValidar" runat="server"  CssClass="alert alert-danger" Visible="False"></asp:Label>
            </div>
            </div>
        </div>
    </div>
</asp:Content>

