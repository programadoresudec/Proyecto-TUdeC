<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="ReportesPorUsuario.aspx.cs" Inherits="Vistas_Admin_ReportesPorUsuario" %>


<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <div class="container">
        <br />
        <br />
        <br />
        <br />
        <br />
        <asp:ListView ID="ListView1" runat="server" DataSourceID="ODS_Reportes">
        <AlternatingItemTemplate>
            <li style="">Id:
                <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                <br />
                NombreDeUsuarioDenunciante:
                <asp:Label ID="NombreDeUsuarioDenuncianteLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciante") %>' />
                <br />
                NombreDeUsuarioDenunciado:
                <asp:Label ID="NombreDeUsuarioDenunciadoLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciado") %>' />
                <br />
                MotivoDelReporte:
                <asp:Label ID="MotivoDelReporteLabel" runat="server" Text='<%# Eval("MotivoDelReporte") %>' />
                <br />
                IdComentario:
                <asp:Label ID="IdComentarioLabel" runat="server" Text='<%# Eval("IdComentario") %>' />
                <br />
                IdMensaje:
                <asp:Label ID="IdMensajeLabel" runat="server" Text='<%# Eval("IdMensaje") %>' />
                <br />
                Descripcion:
                <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
                <br />
                <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Eval("Estado") %>' Enabled="false" Text="Estado" />
                <br />
                Fecha:
                <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha") %>' />
                <br />
                Comentario:
                <asp:Label ID="ComentarioLabel" runat="server" Text='<%# Eval("Comentario") %>' />
                <br />
                Mensaje:
                <asp:Label ID="MensajeLabel" runat="server" Text='<%# Eval("Mensaje") %>' />
                <br />
                ImagenesComentario:
                <asp:Label ID="ImagenesComentarioLabel" runat="server" Text='<%# Eval("ImagenesComentario") %>' />
                <br />
                ImagenesMensaje:
                <asp:Label ID="ImagenesMensajeLabel" runat="server" Text='<%# Eval("ImagenesMensaje") %>' />
                <br />
                <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
            </li>
        </AlternatingItemTemplate>
        <EditItemTemplate>
            <li style="">Id:
                <asp:TextBox ID="IdTextBox" runat="server" Text='<%# Bind("Id") %>' />
                <br />
                NombreDeUsuarioDenunciante:
                <asp:TextBox ID="NombreDeUsuarioDenuncianteTextBox" runat="server" Text='<%# Bind("NombreDeUsuarioDenunciante") %>' />
                <br />
                NombreDeUsuarioDenunciado:
                <asp:TextBox ID="NombreDeUsuarioDenunciadoTextBox" runat="server" Text='<%# Bind("NombreDeUsuarioDenunciado") %>' />
                <br />
                MotivoDelReporte:
                <asp:TextBox ID="MotivoDelReporteTextBox" runat="server" Text='<%# Bind("MotivoDelReporte") %>' />
                <br />
                IdComentario:
                <asp:TextBox ID="IdComentarioTextBox" runat="server" Text='<%# Bind("IdComentario") %>' />
                <br />
                IdMensaje:
                <asp:TextBox ID="IdMensajeTextBox" runat="server" Text='<%# Bind("IdMensaje") %>' />
                <br />
                Descripcion:
                <asp:TextBox ID="DescripcionTextBox" runat="server" Text='<%# Bind("Descripcion") %>' />
                <br />
                <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Bind("Estado") %>' Text="Estado" />
                <br />
                Fecha:
                <asp:TextBox ID="FechaTextBox" runat="server" Text='<%# Bind("Fecha") %>' />
                <br />
                Comentario:
                <asp:TextBox ID="ComentarioTextBox" runat="server" Text='<%# Bind("Comentario") %>' />
                <br />
                Mensaje:
                <asp:TextBox ID="MensajeTextBox" runat="server" Text='<%# Bind("Mensaje") %>' />
                <br />
                ImagenesComentario:
                <asp:TextBox ID="ImagenesComentarioTextBox" runat="server" Text='<%# Bind("ImagenesComentario") %>' />
                <br />
                ImagenesMensaje:
                <asp:TextBox ID="ImagenesMensajeTextBox" runat="server" Text='<%# Bind("ImagenesMensaje") %>' />
                <br />
                <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
                <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
            </li>
        </EditItemTemplate>
        <EmptyDataTemplate>
            No data was returned.
        </EmptyDataTemplate>
        <InsertItemTemplate>
            <li style="">Id:
                <asp:TextBox ID="IdTextBox" runat="server" Text='<%# Bind("Id") %>' />
                <br />NombreDeUsuarioDenunciante:
                <asp:TextBox ID="NombreDeUsuarioDenuncianteTextBox" runat="server" Text='<%# Bind("NombreDeUsuarioDenunciante") %>' />
                <br />NombreDeUsuarioDenunciado:
                <asp:TextBox ID="NombreDeUsuarioDenunciadoTextBox" runat="server" Text='<%# Bind("NombreDeUsuarioDenunciado") %>' />
                <br />MotivoDelReporte:
                <asp:TextBox ID="MotivoDelReporteTextBox" runat="server" Text='<%# Bind("MotivoDelReporte") %>' />
                <br />IdComentario:
                <asp:TextBox ID="IdComentarioTextBox" runat="server" Text='<%# Bind("IdComentario") %>' />
                <br />IdMensaje:
                <asp:TextBox ID="IdMensajeTextBox" runat="server" Text='<%# Bind("IdMensaje") %>' />
                <br />Descripcion:
                <asp:TextBox ID="DescripcionTextBox" runat="server" Text='<%# Bind("Descripcion") %>' />
                <br />
                <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Bind("Estado") %>' Text="Estado" />
                <br />Fecha:
                <asp:TextBox ID="FechaTextBox" runat="server" Text='<%# Bind("Fecha") %>' />
                <br />Comentario:
                <asp:TextBox ID="ComentarioTextBox" runat="server" Text='<%# Bind("Comentario") %>' />
                <br />Mensaje:
                <asp:TextBox ID="MensajeTextBox" runat="server" Text='<%# Bind("Mensaje") %>' />
                <br />ImagenesComentario:
                <asp:TextBox ID="ImagenesComentarioTextBox" runat="server" Text='<%# Bind("ImagenesComentario") %>' />
                <br />ImagenesMensaje:
                <asp:TextBox ID="ImagenesMensajeTextBox" runat="server" Text='<%# Bind("ImagenesMensaje") %>' />
                <br />
                <asp:Button ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" />
                <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Clear" />
            </li>
        </InsertItemTemplate>
        <ItemSeparatorTemplate>
<br />
        </ItemSeparatorTemplate>
        <ItemTemplate>
            <li style="">Id:
                <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                <br />
                NombreDeUsuarioDenunciante:
                <asp:Label ID="NombreDeUsuarioDenuncianteLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciante") %>' />
                <br />
                NombreDeUsuarioDenunciado:
                <asp:Label ID="NombreDeUsuarioDenunciadoLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciado") %>' />
                <br />
                MotivoDelReporte:
                <asp:Label ID="MotivoDelReporteLabel" runat="server" Text='<%# Eval("MotivoDelReporte") %>' />
                <br />
                IdComentario:
                <asp:Label ID="IdComentarioLabel" runat="server" Text='<%# Eval("IdComentario") %>' />
                <br />
                IdMensaje:
                <asp:Label ID="IdMensajeLabel" runat="server" Text='<%# Eval("IdMensaje") %>' />
                <br />
                Descripcion:
                <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
                <br />
                <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Eval("Estado") %>' Enabled="false" Text="Estado" />
                <br />
                Fecha:
                <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha") %>' />
                <br />
                Comentario:
                <asp:Label ID="ComentarioLabel" runat="server" Text='<%# Eval("Comentario") %>' />
                <br />
                Mensaje:
                <asp:Label ID="MensajeLabel" runat="server" Text='<%# Eval("Mensaje") %>' />
                <br />
                ImagenesComentario:
                <asp:Label ID="ImagenesComentarioLabel" runat="server" Text='<%# Eval("ImagenesComentario") %>' />
                <br />
                ImagenesMensaje:
                <asp:Label ID="ImagenesMensajeLabel" runat="server" Text='<%# Eval("ImagenesMensaje") %>' />
                <br />
                <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
            </li>
        </ItemTemplate>
        <LayoutTemplate>
            <ul id="itemPlaceholderContainer" runat="server" style="">
                <li runat="server" id="itemPlaceholder" />
            </ul>
            <div style="">
                <asp:DataPager ID="DataPager1" runat="server">
                    <Fields>
                        <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="False" />
                        <asp:NumericPagerField />
                        <asp:NextPreviousPagerField ButtonType="Button" ShowLastPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="False" />
                    </Fields>
                </asp:DataPager>
            </div>
        </LayoutTemplate>
        <SelectedItemTemplate>
            <li style="">Id:
                <asp:Label ID="IdLabel" runat="server" Text='<%# Eval("Id") %>' />
                <br />
                NombreDeUsuarioDenunciante:
                <asp:Label ID="NombreDeUsuarioDenuncianteLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciante") %>' />
                <br />
                NombreDeUsuarioDenunciado:
                <asp:Label ID="NombreDeUsuarioDenunciadoLabel" runat="server" Text='<%# Eval("NombreDeUsuarioDenunciado") %>' />
                <br />
                MotivoDelReporte:
                <asp:Label ID="MotivoDelReporteLabel" runat="server" Text='<%# Eval("MotivoDelReporte") %>' />
                <br />
                IdComentario:
                <asp:Label ID="IdComentarioLabel" runat="server" Text='<%# Eval("IdComentario") %>' />
                <br />
                IdMensaje:
                <asp:Label ID="IdMensajeLabel" runat="server" Text='<%# Eval("IdMensaje") %>' />
                <br />
                Descripcion:
                <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
                <br />
                <asp:CheckBox ID="EstadoCheckBox" runat="server" Checked='<%# Eval("Estado") %>' Enabled="false" Text="Estado" />
                <br />
                Fecha:
                <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha") %>' />
                <br />
                Comentario:
                <asp:Label ID="ComentarioLabel" runat="server" Text='<%# Eval("Comentario") %>' />
                <br />
                Mensaje:
                <asp:Label ID="MensajeLabel" runat="server" Text='<%# Eval("Mensaje") %>' />
                <br />
                ImagenesComentario:
                <asp:Label ID="ImagenesComentarioLabel" runat="server" Text='<%# Eval("ImagenesComentario") %>' />
                <br />
                ImagenesMensaje:
                <asp:Label ID="ImagenesMensajeLabel" runat="server" Text='<%# Eval("ImagenesMensaje") %>' />
                <br />
                <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
            </li>
        </SelectedItemTemplate>
    </asp:ListView>

    <asp:ObjectDataSource ID="ODS_Reportes" runat="server" DataObjectTypeName="EReporte" SelectMethod="reportesDelUsuario" TypeName="DaoReporte" UpdateMethod="bloquearUsuario">
        <SelectParameters>
            <asp:SessionParameter Name="nombreDeUsuarioDenunciado" SessionField="usuarioConReportes" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    </div>
    
</asp:Content>

