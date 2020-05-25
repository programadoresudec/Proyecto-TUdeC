<%@ Control Language="C#" AutoEventWireup="true" CodeFile="InterfazSubirImagen.ascx.cs" Inherits="Controles_InterfazSubirImagen_InterfazSubirImagen" %>
<div class="container h-100 mt-5" style="padding-top: 10%">
    <div class="row justify-content-center h-100">
        <div class="col-lg-4">

            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header text-center">
                        <asp:FileUpload ID="gestorArchivo" CssClass="fa fa-upload btn btn-outline-dark mr-5" accept=".png,.jpg,.jpeg,.gif" Width="55%" runat="server" onchange="mostrarImagen()" />
                        <asp:LinkButton ID="botonCancelar" runat="server" ForeColor="Red" OnClick="botonCancelar_Click">
                                <i class="fas fa-times-circle fa-lg mr-2"></i>
                        </asp:LinkButton>
                    </div>
                    <div class="modal-body">
                        <div class="text-center">
                            <asp:Label ID="LB_subioImagen" CssClass="alert alert-danger" Text="Debe subir un archivo." runat="server" Visible="false"></asp:Label>
                        </div>
                        <div class="row text-center">
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="gestorArchivo"
                                ErrorMessage="tiene una extensión no válida. Extensiones válidas: gif, jpg, jpeg, png."
                                Font-Size="Medium" CssClass="alertHome alert-danger" Display="Dynamic" ValidationGroup="gestorarchivo"
                                ValidationExpression="(.*?)\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)$" />
                        </div>
                        <asp:Panel ID="panelImagen" runat="server" Height="300px" Width="350px"></asp:Panel>
                    </div>
                    <div class="modal-footer text-center">
                        <asp:LinkButton ID="botonEnviar" CssClass="btn btn-success" runat="server" OnClick="botonEnviar_Click">
                           <strong>Enviar</strong><i class="fas fa-share ml-2"></i>
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    function base64ArrayBuffer(arrayBuffer) {
        var base64 = ''
        var encodings = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

        var bytes = new Uint8Array(arrayBuffer)
        var byteLength = bytes.byteLength
        var byteRemainder = byteLength % 3
        var mainLength = byteLength - byteRemainder

        var a, b, c, d
        var chunk

        // Main loop deals with bytes in chunks of 3
        for (var i = 0; i < mainLength; i = i + 3) {
            // Combine the three bytes into a single integer
            chunk = (bytes[i] << 16) | (bytes[i + 1] << 8) | bytes[i + 2]

            // Use bitmasks to extract 6-bit segments from the triplet
            a = (chunk & 16515072) >> 18 // 16515072 = (2^6 - 1) << 18
            b = (chunk & 258048) >> 12 // 258048   = (2^6 - 1) << 12
            c = (chunk & 4032) >> 6 // 4032     = (2^6 - 1) << 6
            d = chunk & 63               // 63       = 2^6 - 1

            // Convert the raw binary segments to the appropriate ASCII encoding
            base64 += encodings[a] + encodings[b] + encodings[c] + encodings[d]
        }

        // Deal with the remaining bytes and padding
        if (byteRemainder == 1) {
            chunk = bytes[mainLength]

            a = (chunk & 252) >> 2 // 252 = (2^6 - 1) << 2

            // Set the 4 least significant bits to zero
            b = (chunk & 3) << 4 // 3   = 2^2 - 1

            base64 += encodings[a] + encodings[b] + '=='
        } else if (byteRemainder == 2) {
            chunk = (bytes[mainLength] << 8) | bytes[mainLength + 1]

            a = (chunk & 64512) >> 10 // 64512 = (2^6 - 1) << 10
            b = (chunk & 1008) >> 4 // 1008  = (2^6 - 1) << 4

            // Set the 2 least significant bits to zero
            c = (chunk & 15) << 2 // 15    = 2^4 - 1

            base64 += encodings[a] + encodings[b] + encodings[c] + '='
        }

        return base64
    }

    function mostrarImagen() {

        var gestor = <%=gestorArchivo.ClientID%>;

        var panelImagen = <%=panelImagen.ClientID%>;

        var lector = new FileReader();

        lector.readAsArrayBuffer(gestor.files[0]);

        lector.onload = function () {

            var buffer = lector.result;
            var bytes = new Uint8Array(buffer);


            var imagen = document.createElement("img");

            imagen.setAttribute("src", "");

            bytes64 = base64ArrayBuffer(buffer);

            imagen.src = "data:image/jpeg;base64," + bytes64;

            imagen.onload = function () {


                if (imagen.naturalWidth > imagen.naturalHeight) {

                    imagen.width = 300;

                    var desplazamientoVertical = (300 - imagen.height) / 2;

                    imagen.style.paddingTop = desplazamientoVertical + "px";

                } else {

                    imagen.width = imagen.naturalWidth * 300 / imagen.naturalHeight;

                }
            }
            imagen.width = 0;
            panelImagen.innerHTML = "";
            panelImagen.append(imagen);
        }
    }
</script>
<script>
    $(document).ready(function () {
        window.setTimeout(function () {
            $(".alert").fadeTo(1500, 0).slideDown(500, function () {
                $(this).remove();
            });
        }, 1000);
    });
</script>












