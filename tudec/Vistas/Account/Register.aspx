<%@ Page Async="true" Title="Registrar" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Register.aspx.cs" Inherits="Views_Account_Register" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <br />
    <br />
    <br />
    <br />
    <br />
    <div class="container">
        <div class="form-group row justify-content-center">
            <div class=" form-group col-md-auto">
                <br />
                <h2 style="text-align: center; color: #25B4ED; font-size: x-large;"><strong>Crear Nueva Cuenta</strong></h2>
                <br />
                <div class="form-group row justify-content-center">
                    <asp:RequiredFieldValidator ID="NombreUsuarioRequerido"
                        runat="server"
                        ControlToValidate="cajaNombreUsuario"
                        ErrorMessage="nombre de usuario requerido!"
                        SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                        <!-- //validacion de no tener espacios.-->
                    <asp:RegularExpressionValidator ID="RegularExpressionValidatorNombreUsuario"
                        runat="server" ErrorMessage="no debe contener espacios verifique."
                        ControlToValidate="cajaNombreUsuario" CssClass="text-danger"
                        ValidationExpression="^[\S]*$">
                    </asp:RegularExpressionValidator>
                    <div class="form-group col-12">
                        <asp:TextBox ID="cajaNombreUsuario" placeHolder="Nombre De Usuario (nick)" runat="server"
                            CssClass="form-control" />
                    </div>
                </div>
                <asp:RequiredFieldValidator ID="NombreRequerido" runat="server"
                    ControlToValidate="cajaPrimerNombre"
                    ErrorMessage="Primer nombre es requerido!"
                    SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                <div class="form-group row">
                    <div class="form-group col-6">
                        <asp:TextBox ID="cajaPrimerNombre" runat="server" placeHolder="Primer Nombre" CssClass="form-control" />
                    </div>
                    <div class="form-group col-6">
                        <asp:TextBox ID="cajaSegundoNombre" runat="server" placeHolder="Segundo Nombre" CssClass="form-control" />
                    </div>
                </div>
                <asp:RequiredFieldValidator ID="ApellidoRequerido" runat="server"
                    ControlToValidate="cajaPrimerApellido"
                    ErrorMessage="primer Apellido es requerido!"
                    SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                <div class="form-group row">
                    <div class="form-group col-6">
                        <asp:TextBox ID="cajaPrimerApellido" runat="server" placeHolder="Primer Apellido" CssClass="form-control" />
                    </div>
                    <div class="form-group col-6">
                        <asp:TextBox ID="cajaSegundoApellido" runat="server" placeHolder="Segundo Apellido" CssClass="form-control" />
                    </div>
                </div>
                <asp:RequiredFieldValidator ID="emailRequerido" runat="server"
                    ControlToValidate="cajaEmail"
                    ErrorMessage="email es requerido!"
                    SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                <div class="form-group row">
                    <div class="form-group col-6">
                        <asp:TextBox ID="cajaEmail" runat="server" placeHolder="Correo Institucional" CssClass="form-control" />
                    </div>
                    <div class="form-group col-6">
                        <asp:Label ID="labelCorreoUdec" runat="server" Text="Label">@ucundinamarca.edu.co</asp:Label>
                    </div>
                </div>
                <div class="form-group row justify-content-center">
                    <asp:RequiredFieldValidator ID="passRequerida"
                        runat="server"
                        ControlToValidate="cajaPass"
                        ErrorMessage="contraseña es requerida!"
                        SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                    <div class="form-group col-12">
                        <asp:TextBox ID="cajaPass" placeHolder="Contraseña" runat="server"
                            TextMode="Password"
                            CssClass="form-control" />
                    </div>
                </div>

                <div class="form-group row justify-content-center">
                    <asp:RequiredFieldValidator ID="confirmarPassRequerida"
                        runat="server"
                        ControlToValidate="cajaConfirmarPass"
                        ErrorMessage="contraseña confirmada es requerida!"
                        SetFocusOnError="True"
                        Display="Dynamic" CssClass="text-danger" />
                    <div class="form-group col-12">
                        <asp:TextBox ID="cajaConfirmarPass" placeHolder="Confirmar Contraseña" runat="server"
                            TextMode="Password"
                            CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group row justify-content-center">
                    <asp:CompareValidator ID="comparePasswords"
                        runat="server"
                        ControlToCompare="cajaPass"
                        ControlToValidate="cajaConfirmarPass"
                        ErrorMessage="Las contraseñas no son iguales!"
                        Display="Dynamic" CssClass="text-danger" />
                </div>
                <div class="form-group row">
                    <div class="form-group col-12">
                        <strong>
                            <asp:Button runat="server" OnClick="btnRegistrar_Click" Text="Registrar"
                                CssClass="btn btn-primary btn-lg btn-block"
                                Style="font-size: medium; background-color: #25B4ED" />
                        </strong>
                    </div>
                </div>
                <div class="form-group row justify-content-center">
                    <asp:Label ID="labelValidandoCuenta" runat="server" CssClass="text-success" Visible="False"></asp:Label>
                    <asp:Label ID="LB_ErrorUsuario_Correo" runat="server" CssClass="text-danger" Visible="False"></asp:Label>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

