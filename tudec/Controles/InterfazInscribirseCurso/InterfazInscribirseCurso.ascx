<%@ Control Language="C#" AutoEventWireup="true" CodeFile="InterfazInscribirseCurso.ascx.cs" Inherits="Controles_InterfazInscribirseCurso_InterfazInscribirseCurso" %>
<style type="text/css">
    
    td{


        text-align:center;

    }

    table{

        background-color: white;
        border-radius: 15px;
    }

    .etiquetaInscripcion{

        font-size: 30px;

    }

</style>

<table>
    <tr>
        <td>
            <asp:Label CssClass="etiquetaInscripcion" ID="etiquetaInscripcion" runat="server" Text="Inscripción"></asp:Label>
            <asp:ImageButton ID="botonCancelar" Width="16px" ImageUrl="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Fairytale_button_cancel.svg/1200px-Fairytale_button_cancel.svg.png" runat="server" OnClick="botonCancelar_Click" />
        </td>
    </tr>
    <tr>
        <td>
            <asp:TextBox ID="cajaCodigo" placeholder="Código" runat="server"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Button ID="botonInscribirse" runat="server" Text="Inscribirse" OnClick="botonInscribirse_Click" />
        </td>
    </tr>
</table>

