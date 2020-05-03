<%@ Page Title="Iniciar Sesión"  Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/Login.aspx.cs" Inherits="Views_Account_Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <br />
    <br />
    <br />
    <br />
    <br />
    <div class="container">
        <div class="form-group row justify-content-center">
            <div class=" form-group col-md-6">
                <br />
                <h2 style="text-align: center; color: darkblue; font-size: xx-large;"><strong>Login</strong></h2>
                <br />
                <div class="col-12 input-group justify-content-center">
                <asp:Label ID="LB_Validacion" runat="server" Visible="False"></asp:Label>
                </div>
                <div class="col-12 input-group">
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <i class="fa fa-user"></i>
                        </div>
                    </div>
                    <asp:TextBox ID="campoUsuario" ValidationGroup="login" CssClass="form-control" placeHolder="Email o Usuario" runat="server">
                    </asp:TextBox>
                </div>
                <div class="col-12 input-group justify-content-center">
                    <asp:RequiredFieldValidator ID="UsuarioRequerido"
                        runat="server"
                        ControlToValidate="campoUsuario"
                        ErrorMessage="¡requerido!"
                        SetFocusOnError="True" ValidationGroup="login"
                        Display="Dynamic" CssClass="text-danger" />
                </div>
                <br />
                <div class="col-12 input-group">
                    <div class="input-group-prepend">
                        <div class="input-group-text">
                            <i class="fa fa-key"></i>
                        </div>
                    </div>
                    <asp:TextBox ID="campoPass" runat="server" ValidationGroup="login" CssClass="form-control" placeHolder="Contraseña" TextMode="Password">
                    </asp:TextBox>
                </div>
                <div class="col-12 input-group justify-content-center">
                    <asp:RequiredFieldValidator ID="PassRequerida"
                        runat="server"
                        ControlToValidate="campoPass"
                        ErrorMessage="¡requerido!"
                        SetFocusOnError="True" ValidationGroup="login"
                        Display="Dynamic" CssClass="text-danger" />
                </div>
                <br />
                <div class="col-12 input-group justify-content-center">
                    <asp:HyperLink ID="cambiarPassword" CssClass="btn btn-link" runat="server"
                        NavigateUrl="~/Vistas/Account/VerificarEmail.aspx">¿Has olvidado la contraseña?</asp:HyperLink>
                </div>
                <div class="form-group col-12">
                    <strong>
                        <asp:Button ID="botonIniciar" CssClass="btn btn-dark btn-lg btn-block" Style="font-size: medium;" runat="server" 
                            Text="Iniciar sesión" OnClick="botonIniciar_Click"/>
                    </strong>
                </div>
            </div>
        </div>
    </div>
</asp:Content>




