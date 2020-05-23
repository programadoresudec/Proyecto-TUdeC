<%@ Page Title="" Language="C#" MasterPageFile="~/Vistas/MasterPage.master" AutoEventWireup="true" CodeFile="~/Controladores/CreacionYEdicionTema.aspx.cs" Inherits="Vistas_Cursos_CreacionYEdicionTema" %>

<%@ Register Src="~/Controles/Examenes/CreacionExamen.ascx" TagPrefix="uc1" TagName="CreacionExamen" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }



        .etiquetaCrearTema {
            font-size: 50px;
        }

        .cajaTitulo, .botonCrearExamen, .botonCrearTema {
            width: 60%;
        }

        .cajaTitulo {
            height: 30px;
            text-align: center;
        }

        .editor {
            width: 58.5%;
            height: 500px
        }

        .ajax__html_editor_extender_popupDiv {
            display: none;
        }

       

    </style>

    <script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>

    <script src="../../CKEditor4/ckeditor.js"></script>

    <script>

        $(document).ready(function () {

            var cajaTitulo = <%=cajaTitulo.ClientID%>;
            var titulo = cajaTitulo.value;

            if (titulo != "") {


                var botonCrear = document.getElementById("botonCrearTema");
                botonCrear.value = "Editar tema";



                var contenido = "<%=((ETema)Session[Constantes.TEMA_SELECCIONADO]).Informacion.Replace("\"","\\\"")%>";

                CKEDITOR.instances.editor.setData(contenido);


            }


            $('#botonCrearTema').click(function () {


                //Tema

                var cajaTitulo = <%=cajaTitulo.ClientID%>;
      
                var botonCrearExamen = <%=botonCrearExamen.ClientID%>;
                var idCurso = <%=((ECurso)Session[Constantes.CURSO_SELECCIONADO_PARA_EDITAR_TEMAS]).Id%>;
                if (idCurso != null) {
                    var titulo = cajaTitulo.value;

                    if (titulo != "") {

                        var contenido = CKEDITOR.instances.editor.getData();

                        var textoBoton = botonCrearExamen.value;

                        var existeExamen;

                        if (textoBoton == "Crear examen") {

                            existeExamen = false;

                        } else {

                            existeExamen = true;

                        }

                        var datos = "{'titulo':'" + titulo + "','contenido':'" + contenido + "','existeExamen':'" + existeExamen + "'}";

                        $.ajax({

                            type: "POST",
                            url: 'CreacionYEdicionTema.aspx/CrearTema',
                            data: datos,

                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,

                        });

                        //Examen

                        if (existeExamen) {

                            enviarExamen(titulo, contenido, idCurso);

                        } else {

                            alert("Se ha creado el tema");
                            window.location.href = "ListaDeTemasDelCurso.aspx"

                        }

                    } else {

                        alert("El tema debe tener un título");

                    }
                }
                else {
                    window.location.href="Vistas/Home.aspx"
                }

            });

        });

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContentMaster" runat="Server">

    <br />
    <br />
    <br />
    <br />
    <br />



    <table class="auto-style1">
        <tr>
            <td>
                <center>
                <asp:Label CssClass="etiquetaCrearTema" ID="etiquetaCrearTema" runat="server" Text="Crear tema"></asp:Label>
                    </center>
            </td>
        </tr>
        <tr>
            <td>
                <center>

                <asp:TextBox CssClass="cajaTitulo" placeholder="Título" ID="cajaTitulo" runat="server"></asp:TextBox>

           
                    </center>

                <ajaxToolkit:FilteredTextBoxExtender runat="server" TargetControlID="cajaTitulo" ID="cajaTitulo_FilteredTextBoxExtender" FilterType="LowercaseLetters, UppercaseLetters, Numbers, Custom" FilterMode="ValidChars" ValidChars="[ñÑáéíóúÁÉÍÓÚ]" ></ajaxToolkit:FilteredTextBoxExtender>
        
            </td>
        </tr>
        <tr>

            <td>
                <center>

                    <input id="botonSubirImagen" onclick="" type="button" value="Agregar imagen" />
                <asp:FileUpload ID="gestorImagen" runat="server" />
              
                    </center>


        </tr>
        
        <tr>
            <td>
                <div class="row justify-content-center">
                    

                    <textarea class="editor" id="editor">



                    </textarea>

                    <script>

                        CKEDITOR.replace("editor");

                    </script>

                </div>
                
            </td>
        </tr>
        <tr>
            <td>
                <center>
                <asp:Button CssClass="botonCrearExamen" ID="botonCrearExamen" runat="server" Text="Crear examen" OnClick="botonCrearExamen_Click" />
                    </center>
            </td>
        </tr>
        <tr>
            <td>

                <asp:Panel ID="panelExamen" runat="server">
                </asp:Panel>


            </td>
        </tr>
        <tr>
            <td>
                <center>
                <asp:Label  ID="etiquetaComentarios" runat="server" Text="Sección de comentarios"></asp:Label>
                    </center>
            </td>
        </tr>
        <tr>
            <td>
                <center>
                <input class="botonCrearTema" id="botonCrearTema" type="button" value="Crear tema" />
                
                    </center>
            </td>
        </tr>
    </table>



    <br />

</asp:Content>

