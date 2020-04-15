<%@ Page Title="Cambiar Contraseña" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/ChangePassword.aspx.cs" Inherits="Vistas_Account_ChangePassword" %>

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
                    <asp:Label ID="LB_Validacion" runat="server" CssClass="text-danger" Visible="False"></asp:Label>
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
                        ErrorMessage="contraseña es requerida!"
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
                        ErrorMessage="contraseña confirmada es requerida!"
                        SetFocusOnError="True"
                        Display="Dynamic" CssClass="text-danger" />
                </div>
                <div class="col-12 input-group justify-content-center">
                    <asp:CompareValidator ID="comparePasswords"
                        runat="server"
                        ControlToCompare="cajaPass"
                        ControlToValidate="cajaConfirmarPass"
                        ErrorMessage="Las contraseñas no son iguales!"
                        Display="Dynamic" CssClass="text-danger" /> 
                </div>
                <br />
                <div class="form-group col-12">
                    <strong>
                        <asp:Button runat="server" OnClick="btnRestablecer_Click" Text="Cambiar Contraseña"
                            CssClass="btn btn-primary btn-lg btn-block"
                            Style="font-size: medium; background-color: #000000" />
                    </strong>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

