<%@ Page Title="Verificar Email" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/VerificarEmail.aspx.cs" Inherits="Vistas_Account_VerificarEmail" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Contenido" ContentPlaceHolderID="BodyContentMaster" runat="Server">
    <br />
    <br />
    <br />
    <br />
    <br />
    <div class="container">
        <div class="form-group row justify-content-center">
            <div class=" form-group col-md-auto">
                <br />
                <h2 style="text-align: center; color: darkblue; font-size: xx-large;"><strong>Por favor ingrese su correo</strong></h2>
                <br />
                <div class="col-12 input-group justify-content-center">
                    <asp:Label ID="LB_Validacion" runat="server" CssClass="alert alert-danger" Visible="False"></asp:Label>
                </div>
                <div class="row justify-content-center">
                    <div class="col-12 input-group">
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <i class="fa fa-envelope"></i>
                            </div>
                        </div>
                        <ajaxToolkit:FilteredTextBoxExtender ID="FiltrarCaja" runat="server"
                            TargetControlID="campoCorreo" FilterType="LowercaseLetters, UppercaseLetters, Numbers" />
                        <asp:TextBox ID="campoCorreo" CssClass="form-control" placeHolder="E-mail" runat="server"></asp:TextBox>
                        <div class="input-group-prepend">
                            <div class="input-group-text">
                                <i>@ucundinamarca.edu.co</i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 input-group justify-content-center">
                    <asp:RequiredFieldValidator ID="correoRequerido" runat="server"
                        ControlToValidate="campoCorreo" ErrorMessage="¡requerido!" ValidationGroup="verificarCorreo"
                        SetFocusOnError="True" Display="Dynamic" CssClass="text-danger" />
                </div>
                <br />
                <div class=" form-row">

                    <div class=" form-group col">
                        <asp:HyperLink ID="BtnCancelar" CssClass="btn btn-info btn-lg btn-block" runat="server"
                            NavigateUrl="~/Vistas/Account/Login.aspx" Style="font-size: medium;">
                                <i class="fas fa-arrow-alt-circle-left mr-2"></i><strong>Cancelar</strong> 
                        </asp:HyperLink>
                    </div>
                    <div class="form-group col">
                        <strong>
                            <asp:LinkButton ID="botonEnviar" ValidationGroup="verificarCorreo"
                                CssClass=" btn btn-dark btn-lg btn-block" runat="server"
                                OnClick="botonEnviarToken_Click" Style="font-size: medium; text-align: center">
                               <strong>Enviar</strong><i class="fas fa-share-square ml-2"></i>
                            </asp:LinkButton>
                        </strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

