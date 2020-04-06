<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Buzon.ascx.cs" Inherits="Controles_Buzon_Buzon" %>
<style type="text/css">
    .auto-style1 {
        width: 100%;
    }
    .auto-style2 {
        height: 26px;
    }
</style>


<script>


    function crecer(caja) {

        if (caja.value.length > 26) {

            if (caja.value.length % 26 == 0) {

                //alert("E");
                var numFilas = parseInt(caja.getAttribute("rows"));

                caja.setAttribute("rows", (numFilas + 1).toString());

            }

        }

    }

   
</script>



<table class="auto-style1">
    <tr>
        <td class="auto-style2">
            <asp:TextBox ID="cajaAsunto" runat="server" Width="195px"></asp:TextBox>
                
            <asp:ImageButton ID="botonImagen" runat="server" OnClick="BotonImagen_Click" Height="20px" ImageUrl="~/Recursos/Imagenes/Sugerencias/Imagen.png" />
            
            </td>
    </tr>
    <tr>
        <td>

            
                <asp:Panel ID="panelSugerencia" runat="server" Height="200px" Width="223px">
                </asp:Panel>


        </td>
    </tr>
    <tr>
        <td>
            <asp:Button ID="botonEnviar" runat="server" Text="Enviar sugerencia" Width="229px" OnClick="botonEnviar_Click"  />
        </td>
    </tr>
    <tr>
        <td>
            <asp:FileUpload ID="subidorImagenes" runat="server" Width="226px" />
        </td>
    </tr>
</table>

