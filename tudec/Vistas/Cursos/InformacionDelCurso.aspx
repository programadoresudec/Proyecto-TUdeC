<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/InformacionDelCurso.aspx.cs" Inherits="Vistas_Cursos_InformacionDelCurso" %>

<%@ Register Src="~/Controles/Comentarios/CajaComentarios.ascx" TagPrefix="uc1" TagName="CajaComentarios" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" Runat="Server">
    <br />
    <br />
    <br />
    <br />
    <br />

    <link href="../../App_Themes/Estilos/Estilos.css" rel="stylesheet" />

    <center>
    <table style="width:90%">
        <tr>
            <td>&nbsp;</td>
            <td>

                <center>
                    <asp:Label style="color: #2D732D; font-size: 40px" Text="TituloCurso" runat="server" ID="etiquetaTitulo" /></td>
            
        </tr>
        <tr>
            <td>

                <center>

                <table >
                    <tr>
                        <td><h4 style="color: #2D732D; ">CREADO POR: </h4><asp:Label style="color: #2D732D;" Text="NombreDeUsuario" runat="server" ID="etiquetaNombreUsuario" />
                        </td>
                    </tr>
                    <tr>
                        <td><asp:Label Text="Nombre" runat="server" ID="etiquetaNombre" /></td>
                    </tr>
                    <tr>
                        <td><asp:Label Text="CorreoUsuario" runat="server" ID="etiquetaCorreo" /></td>
                    </tr>
                    <tr>
                        <td>
                


                <asp:Button Text="¡Habla Conmigo!" runat="server" CssClass="auto-style13" BackColor="#666666" ForeColor="White" ID="botonInbox" />
                <asp:Button Text="Inscribirse" runat="server" BackColor="#003300" ForeColor="White" ID="botonInscribirse" />


                        </td>
                    </tr>
                    <tr>
                        <td><asp:Image ImageUrl="Ícono" runat="server" ID="imagenArea" />
                <asp:Label Text="área" runat="server" ID="etiquetaArea" /></td>
                    </tr>
                </table>

                    </center>
            </td>
            <td>
                <center>
                <asp:GridView style="width:90%" ID="tablaTemas" CssClass="tablas" runat="server" AutoGenerateColumns="False" DataSourceID="TemasDataSource" OnRowDataBound="tablaTemas_RowDataBound" AllowPaging="True" DataKeyNames="Id">
                    <Columns>
                        <asp:BoundField DataField="Titulo" HeaderText="Título" SortExpression="Titulo" />
                    </Columns>
                </asp:GridView>
                    </center>
                <asp:ObjectDataSource ID="TemasDataSource" runat="server" SelectMethod="GetTemas" TypeName="GestionTemas">
                    <SelectParameters>
                        <asp:SessionParameter Name="curso" SessionField="cursoSeleccionado" Type="Object" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                
                <center>
                DESCRIPCIÓN DEL CURSO
                    </center>
                    </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                
                <center>
                    <asp:TextBox Enabled="false" ID="campoDescripcion" style="width: 90%" runat="server" Height="150px" TextMode="MultiLine"></asp:TextBox>
                    </center>
                </td>
        </tr>
        </table>
        </center>

    <br />
    <br />

    <table style="width:100%">
        <tr>
            <td>

                <center>
            <asp:Label ID="etiquetaComentarios" runat="server" Text="COMENTARIOS"></asp:Label>
           </center>

                            </td>
        </tr>
        <tr>
            <td>
                
         
                <uc1:CajaComentarios runat="server" ID="CajaComentarios" />
               
         

            </td>
        </tr>
    </table>


    

    <br />
    <br />
    <br />
    <br />
    <br />
</asp:Content>

