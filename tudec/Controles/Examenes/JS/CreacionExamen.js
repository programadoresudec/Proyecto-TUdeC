class Examen {

    static preguntas = [];

    static getJSON() {

        var contador;

        var listaPreguntas = [];

        for (contador = 0; contador < this.preguntas.length; contador++) {

            listaPreguntas.push(this.preguntas[contador].getInfoPregunta());

        }
      
        return JSON.stringify(listaPreguntas);

    }

    static camposVacios() {

        var contador;

        var retorno = false;

        for (contador = 0; contador < this.preguntas.length; contador++) {

            if (this.preguntas[contador].camposVacios() == true) {

                retorno = true;
                break;

            }

        }

        return retorno;

    }


    static porcentajeCompleto() {

        var contador;
        var acumuladorPorcentaje = 0;

        var retorno = false;

        for (contador = 0; contador < this.preguntas.length; contador++) {

            acumuladorPorcentaje += parseInt(this.preguntas[contador].getPorcentaje());

        }

        if (acumuladorPorcentaje == 100) {

            retorno = true;

        }

        return retorno;

    }

}


class PreguntaMultipleUnicaRespuesta {

   

    constructor() {

        
        
    }

    getInfoPregunta() {

        var objetoRetorno = new PreguntaMultipleUnicaRespuesta();
        objetoRetorno.pregunta = this.cajaPregunta.value;
        objetoRetorno.respuestas = this.getRespuestas();
        objetoRetorno.respuestaMarcada = this.getRespuestaMarcada();
        objetoRetorno.porcentaje = this.getPorcentaje();
        objetoRetorno.tipoPregunta = "Múltiple con única respuesta"
        return objetoRetorno;

    }


    camposVacios() {

        var retorno = false;

        if (this.cajaPregunta.value == "") {

            retorno = true;

        }

        var contador;

        for (contador = 0; contador < this.respuestas.length; contador++) {

            if (this.respuestas[contador].value == "") {

                retorno = true;
                break;

            }

        }

        return retorno;

    }
    
    getRespuestas() {

        var textosRespuestas = [];

        var contador;

        for (contador = 0; contador < this.respuestas.length; contador++) {

            textosRespuestas.push(this.respuestas[contador].value);

        }

        return textosRespuestas;

    }

    getPorcentaje() {

        return this.desplegablePorcentaje.value;

    }

    getTextoPregunta() {

        return this.cajaPregunta.value;

    }

    getRespuestaMarcada() {

        var contador;
        var indice;

        var espaciosMarcar = this.espaciosMarcar;
        var cantidadRespuestas = espaciosMarcar.length;
        
        for (contador = 0; contador < cantidadRespuestas; contador++) {

            var imagen = espaciosMarcar[contador].src;

            if (imagen.includes("puntoMarcacion.png")) {

                indice = contador;

                break;

            }

        }

        return indice;

    }

    getPregunta() {

        var objetoSustituto = this;

        this.tabla = document.createElement("table");
        this.tabla.bgColor = "#c3c9d1";
        this.tabla.width = "60%";
        this.tabla.style.borderRadius = "10px";

        var fila;

        for (fila = 0; fila < 4; fila++) {

            var filaTabla = this.tabla.insertRow();
            var celda = filaTabla.insertCell();
            celda.style.paddingLeft = "3%";
            celda.style.paddingTop = "1%";
            celda.style.paddingBottom = "1%";

        }

        //fila 1
        this.cajaPregunta = document.createElement("input");
        this.cajaPregunta.style.width = "75%";
        this.botonInsertarRespuesta = document.createElement("input");
        this.botonInsertarRespuesta.style.width = "20%";
        this.cajaPregunta.setAttribute("type", "text");
        this.cajaPregunta.setAttribute("placeholder", "Pregunta");
        this.botonInsertarRespuesta.setAttribute("type", "button");
        this.botonInsertarRespuesta.setAttribute("value", "Insertar respuesta");
        var botonEliminarPregunta = document.createElement("img");
        
        botonEliminarPregunta.src = "../../Controles/Examenes/JS/Eliminar.png";
        botonEliminarPregunta.width = 16;

        botonEliminarPregunta.addEventListener("click", function () {

            var saltoDeLinea = objetoSustituto.tabla.nextSibling;
            objetoSustituto.tabla.parentNode.removeChild(objetoSustituto.tabla);
            Examen.preguntas.splice(Examen.preguntas.indexOf(objetoSustituto), 1);
            saltoDeLinea.parentNode.removeChild(saltoDeLinea);

        })

        this.botonInsertarRespuesta.addEventListener("click", function () {

            var tablita = objetoSustituto.tabla;
            var filita = tablita.insertRow(tablita.rows.length - 1);
            var celdita = filita.insertCell();
            celdita.style.paddingLeft = "3%";
            celdita.style.paddingTop = "1%";
            celdita.style.paddingBottom = "1%";

            var nuevoEspacioMarcar = document.createElement("img");
            nuevoEspacioMarcar.src = "../../Controles/Examenes/JS/puntoBlanco.png";
            nuevoEspacioMarcar.width = 16;

            objetoSustituto.espaciosMarcar.push(nuevoEspacioMarcar);

            nuevoEspacioMarcar.addEventListener("click", function () {

                var indice = objetoSustituto.espaciosMarcar.indexOf(nuevoEspacioMarcar);

                objetoSustituto.espaciosMarcar[indice].src = "../../Controles/Examenes/JS/puntoMarcacion.png";

                var contadorEspacios;

                for (contadorEspacios = 0; contadorEspacios < objetoSustituto.espaciosMarcar.length; contadorEspacios++) {

                    if (contadorEspacios != indice) {

                        objetoSustituto.espaciosMarcar[contadorEspacios].src = "../../Controles/Examenes/JS/puntoBlanco.png";

                    }

                }

            })

            var nuevaCajaRespuesta = document.createElement("input");
            var botonEliminarRespuesta = document.createElement("img");
            botonEliminarRespuesta.src = "../../Controles/Examenes/JS/Eliminar.png";
            botonEliminarRespuesta.width = 16;
         
            botonEliminarRespuesta.addEventListener("click", function () {

                var numeroFila = filita.rowIndex;

                objetoSustituto.tabla.deleteRow(numeroFila);
                objetoSustituto.respuestas.splice(numeroFila - 1, 1);
                objetoSustituto.espaciosMarcar.splice(numeroFila-1, 1);
            
            })
            
            objetoSustituto.respuestas.push(nuevaCajaRespuesta);
            nuevaCajaRespuesta.setAttribute("type", "text");
            var textoPlaceHolder = "Respuesta ";
            nuevaCajaRespuesta.setAttribute("placeholder", textoPlaceHolder);
            celdita.append(nuevoEspacioMarcar);
            celdita.append(nuevaCajaRespuesta);
            celdita.append(botonEliminarRespuesta);

        });

        this.tabla.rows[0].cells[0].append(this.cajaPregunta);
        this.tabla.rows[0].cells[0].append(this.botonInsertarRespuesta);
        this.tabla.rows[0].cells[0].append(botonEliminarPregunta);

        //fila 2 y 3
        this.respuestas = [];
        var cajaRespuesta = document.createElement("input");
        var cajaRespuesta2 = document.createElement("input");
        cajaRespuesta.setAttribute("type", "text");
        cajaRespuesta.setAttribute("placeholder", "Respuesta");
        cajaRespuesta2.setAttribute("type", "text");
        cajaRespuesta2.setAttribute("placeholder", "Respuesta");
        this.respuestas.push(cajaRespuesta);
        this.respuestas.push(cajaRespuesta2);

        this.espaciosMarcar = [];
        var botonEspacioMarcar1 = document.createElement("img");
        botonEspacioMarcar1.src = "../../Controles/Examenes/JS/puntoMarcacion.png";
        botonEspacioMarcar1.width = 16;

        var botonEspacioMarcar2 = document.createElement("img");
        botonEspacioMarcar2.src = "../../Controles/Examenes/JS/puntoBlanco.png";
        botonEspacioMarcar2.width = 16;

        this.espaciosMarcar.push(botonEspacioMarcar1);
        this.espaciosMarcar.push(botonEspacioMarcar2);


        this.espaciosMarcar[0].addEventListener("click", function () {

            objetoSustituto.espaciosMarcar[0].src = "../../Controles/Examenes/JS/puntoMarcacion.png";

            var contadorEspacios;

            for (contadorEspacios = 0; contadorEspacios < objetoSustituto.espaciosMarcar.length; contadorEspacios++) {

                if (contadorEspacios != 0) {

                    objetoSustituto.espaciosMarcar[contadorEspacios].src = "../../Controles/Examenes/JS/puntoBlanco.png";

                }

            }

        })

        this.espaciosMarcar[1].addEventListener("click", function () {

            objetoSustituto.espaciosMarcar[1].src = "../../Controles/Examenes/JS/puntoMarcacion.png";

            var contadorEspacios;

            for (contadorEspacios = 0; contadorEspacios < objetoSustituto.espaciosMarcar.length; contadorEspacios++) {

                if (contadorEspacios != 1) {

                    objetoSustituto.espaciosMarcar[contadorEspacios].src = "../../Controles/Examenes/JS/puntoBlanco.png";

                }

            }

        })


        this.tabla.rows[1].cells[0].append(botonEspacioMarcar1);
        this.tabla.rows[2].cells[0].append(botonEspacioMarcar2);
        this.tabla.rows[1].cells[0].append(this.respuestas[0]);
        this.tabla.rows[2].cells[0].append(this.respuestas[1]);

        //fila 4

        this.desplegablePorcentaje = document.createElement("select");

        var contadorPorcentaje;

        for (contadorPorcentaje = 1; contadorPorcentaje <= 100; contadorPorcentaje++) {

            var opcion = document.createElement("option");
            opcion.value = contadorPorcentaje;
            opcion.innerHTML = opcion.value;
            this.desplegablePorcentaje.append(opcion);

        }
        
        this.tabla.rows[3].cells[0].append(this.desplegablePorcentaje);

        return this.tabla;

    }

}

class PreguntaMultipleMultipleRespuesta {


    constructor() {


    }

    camposVacios() {

        var retorno = false;

        if (this.cajaPregunta.value == "") {

            retorno = true;

        }

        var contador;

        for (contador = 0; contador < this.respuestas.length; contador++) {

            if (this.respuestas[contador].value == "") {

                retorno = true;
                break;

            }

        }

        return retorno;

    }

    getInfoPregunta() {

        
        var objetoRetorno = new PreguntaMultipleMultipleRespuesta();
        objetoRetorno.pregunta = this.cajaPregunta.value;
        objetoRetorno.respuestas = this.getRespuestas();
        objetoRetorno.respuestasMarcadas = this.getRespuestasMarcadas();
        objetoRetorno.porcentaje = this.getPorcentaje();
        objetoRetorno.tipoPregunta = "Múltiple con múltiple respuesta"
        return objetoRetorno;
    }

    getRespuestas() {

        var textosRespuestas = [];

        var contador;

        for (contador = 0; contador < this.respuestas.length; contador++) {

            textosRespuestas.push(this.respuestas[contador].value);

        }

        return textosRespuestas;

    }

    getPorcentaje() {

        return this.desplegablePorcentaje.value;

    }

    getTextoPregunta() {

        return this.cajaPregunta.value;

    }

    getRespuestasMarcadas() {

        var indiceRespuestas = [];
        var contador;

        var checkers = this.checkers;
        var cantidadRespuestas = checkers.length;

        for (contador = 0; contador < cantidadRespuestas; contador++) {

            if (checkers[contador].checked == true) {

                indiceRespuestas.push(contador);

            }

        }

        return indiceRespuestas;

    }

    getPregunta() {

        var objetoSustituto = this;

        this.tabla = document.createElement("table");
        this.tabla.bgColor = "#c3c9d1";
        this.tabla.width = "60%";
        this.tabla.style.borderRadius = "10px";

        var fila;

        for (fila = 0; fila < 4; fila++) {

            var filaTabla = this.tabla.insertRow();
            var celda = filaTabla.insertCell();
            celda.style.paddingLeft = "3%";
            celda.style.paddingTop = "1%";
            celda.style.paddingBottom = "1%";

        }

        //fila 1
        this.cajaPregunta = document.createElement("input");
        this.cajaPregunta.style.width = "75%";
        this.botonInsertarRespuesta = document.createElement("input");
        this.botonInsertarRespuesta.style.width = "20%";
        this.cajaPregunta.setAttribute("type", "text");
        this.cajaPregunta.setAttribute("placeholder", "Pregunta");
        this.botonInsertarRespuesta.setAttribute("type", "button");
        this.botonInsertarRespuesta.setAttribute("value", "Insertar respuesta");
        var botonEliminarPregunta = document.createElement("img");

        botonEliminarPregunta.src = "../../Controles/Examenes/JS/Eliminar.png";
        botonEliminarPregunta.width = 16;

        botonEliminarPregunta.addEventListener("click", function () {

            var saltoDeLinea = objetoSustituto.tabla.nextSibling;
            objetoSustituto.tabla.parentNode.removeChild(objetoSustituto.tabla);
            Examen.preguntas.splice(Examen.preguntas.indexOf(objetoSustituto), 1);
            saltoDeLinea.parentNode.removeChild(saltoDeLinea);

        })

        this.botonInsertarRespuesta.addEventListener("click", function () {

            var tablita = objetoSustituto.tabla;
            var filita = tablita.insertRow(tablita.rows.length - 1);
            var celdita = filita.insertCell();
            celdita.style.paddingLeft = "3%";
            celdita.style.paddingTop = "1%";
            celdita.style.paddingBottom = "1%";

            var nuevoChecker = document.createElement("input");
            nuevoChecker.type = "checkbox";

            objetoSustituto.checkers.push(nuevoChecker);

            var nuevaCajaRespuesta = document.createElement("input");
            var botonEliminarRespuesta = document.createElement("img");
            botonEliminarRespuesta.src = "../../Controles/Examenes/JS/Eliminar.png";
            botonEliminarRespuesta.width = 16;

            botonEliminarRespuesta.addEventListener("click", function () {

                var numeroFila = filita.rowIndex;

                objetoSustituto.tabla.deleteRow(numeroFila);
                objetoSustituto.respuestas.splice(numeroFila - 1, 1);
                objetoSustituto.checkers.splice(numeroFila - 1, 1);

            })

            objetoSustituto.respuestas.push(nuevaCajaRespuesta);
            nuevaCajaRespuesta.setAttribute("type", "text");
            var textoPlaceHolder = "Respuesta ";
            nuevaCajaRespuesta.setAttribute("placeholder", textoPlaceHolder);
            celdita.append(nuevoChecker);
            celdita.append(nuevaCajaRespuesta);
            celdita.append(botonEliminarRespuesta);

        });

        this.tabla.rows[0].cells[0].append(this.cajaPregunta);
        this.tabla.rows[0].cells[0].append(this.botonInsertarRespuesta);
        this.tabla.rows[0].cells[0].append(botonEliminarPregunta);

        //fila 2 y 3
        this.respuestas = [];
        var cajaRespuesta = document.createElement("input");
        var cajaRespuesta2 = document.createElement("input");
        cajaRespuesta.setAttribute("type", "text");
        cajaRespuesta.setAttribute("placeholder", "Respuesta");
        cajaRespuesta2.setAttribute("type", "text");
        cajaRespuesta2.setAttribute("placeholder", "Respuesta");
        this.respuestas.push(cajaRespuesta);
        this.respuestas.push(cajaRespuesta2);

        this.checkers = [];
        var checker1 = document.createElement("input");
        var checker2 = document.createElement("input");

        checker1.type = "checkbox";
        checker2.type = "checkbox";

        this.checkers.push(checker1);
        this.checkers.push(checker2);

        this.tabla.rows[1].cells[0].append(checker1);
        this.tabla.rows[2].cells[0].append(checker2);
        this.tabla.rows[1].cells[0].append(this.respuestas[0]);
        this.tabla.rows[2].cells[0].append(this.respuestas[1]);

        //fila 4

        this.desplegablePorcentaje = document.createElement("select");

        var contadorPorcentaje;

        for (contadorPorcentaje = 1; contadorPorcentaje <= 100; contadorPorcentaje++) {

            var opcion = document.createElement("option");
            opcion.value = contadorPorcentaje;
            opcion.innerHTML = opcion.value;
            this.desplegablePorcentaje.append(opcion);

        }

        this.tabla.rows[3].cells[0].append(this.desplegablePorcentaje);

        return this.tabla;

    }


}

class PreguntaAbierta {

    constructor() {


    }

    camposVacios() {

        var retorno = false;

        if (this.cajaPregunta.value == "") {

            retorno = true;

        }

        return retorno;

    }

    getInfoPregunta() {

        var objetoRetorno = new PreguntaAbierta();
        objetoRetorno.pregunta = this.cajaPregunta.value;
        objetoRetorno.porcentaje = this.getPorcentaje();
        objetoRetorno.tipoPregunta = "Abierta"
        return objetoRetorno;

    }


    getRespuesta() {

        return this.campoRespuesta.value;

    }

    getPorcentaje() {

        return this.desplegablePorcentaje.value;

    }

    getTextoPregunta() {

        return this.cajaPregunta.value;

    }

    getPregunta() {

        var objetoSustituto = this;

        this.tabla = document.createElement("table");
        this.tabla.bgColor = "#c3c9d1";
        this.tabla.width = "60%";
        this.tabla.style.borderRadius = "10px";

        var fila;

        for (fila = 0; fila < 3; fila++) {

            var filaTabla = this.tabla.insertRow();
            var celda = filaTabla.insertCell();
            celda.style.paddingLeft = "3%";
            celda.style.paddingTop = "1%";
            celda.style.paddingBottom = "1%";

        }

        //fila 1
        this.cajaPregunta = document.createElement("input");
        this.cajaPregunta.setAttribute("type", "text");
        this.cajaPregunta.setAttribute("placeholder", "Pregunta");
        this.cajaPregunta.style.width = "95%";

        var botonEliminarPregunta = document.createElement("img");
        botonEliminarPregunta.src = "../../Controles/Examenes/JS/Eliminar.png";
        botonEliminarPregunta.width = 16;

        botonEliminarPregunta.addEventListener("click", function () {

            var saltoDeLinea = objetoSustituto.tabla.nextSibling;
            objetoSustituto.tabla.parentNode.removeChild(objetoSustituto.tabla);
            Examen.preguntas.splice(Examen.preguntas.indexOf(objetoSustituto), 1);
            saltoDeLinea.parentNode.removeChild(saltoDeLinea);

        })

        this.tabla.rows[0].cells[0].append(this.cajaPregunta);
        this.tabla.rows[0].cells[0].append(botonEliminarPregunta);


        //fila 2
        this.campoRespuesta = document.createElement("textarea");
        this.campoRespuesta.setAttribute("placeholder", "Respuesta");
        this.campoRespuesta.style.width = "95%";
        this.campoRespuesta.style.height = "100px";
        this.campoRespuesta.disabled = true;
        this.tabla.rows[1].cells[0].append(this.campoRespuesta);

        //fila 3

        this.desplegablePorcentaje = document.createElement("select");

        var contadorPorcentaje;

        for (contadorPorcentaje = 1; contadorPorcentaje <= 100; contadorPorcentaje++) {

            var opcion = document.createElement("option");
            opcion.value = contadorPorcentaje;
            opcion.innerHTML = opcion.value;
            this.desplegablePorcentaje.append(opcion);

        }

        this.tabla.rows[2].cells[0].append(this.desplegablePorcentaje);


        return this.tabla;

    }

}

class PreguntaArchivo{

    constructor() {




    }

    camposVacios() {

        var retorno = false;

        if (this.campoPeticion.value == "") {

            retorno = true;

        }

        return retorno;

    }

    getInfoPregunta() {

        var objetoRetorno = new PreguntaAbierta();
        objetoRetorno.pregunta = this.campoPeticion.value;
        objetoRetorno.porcentaje = this.getPorcentaje();
        objetoRetorno.tipoPregunta = "Solicitud archivo"
        return objetoRetorno;

    }

    getNumArchivos() {

        return this.botonesSubirArchivo.length;

    }

    getPorcentaje() {

        return this.desplegablePorcentaje.value;

    }

    getPregunta() {

        var objetoSustituto = this;

        this.tabla = document.createElement("table");
        this.tabla.bgColor = "#c3c9d1";
        this.tabla.width = "60%";
        this.tabla.style.borderRadius = "10px";

        var fila;

        for (fila = 0; fila < 4; fila++) {

            var filaTabla = this.tabla.insertRow();
            var celda = filaTabla.insertCell();
            celda.style.paddingLeft = "3%";
            celda.style.paddingTop = "1%";
            celda.style.paddingBottom = "1%";

        }

        //fila 1

        this.campoPeticion = document.createElement("textarea");
        this.campoPeticion.setAttribute("placeholder", "Petición");
        this.campoPeticion.style.width = "100%";
        this.campoPeticion.style.height = "100px";

        var botonEliminarPregunta = document.createElement("img");
        botonEliminarPregunta.src = "../../Controles/Examenes/JS/Eliminar.png";
        botonEliminarPregunta.width = 16;

        botonEliminarPregunta.addEventListener("click", function () {

            var saltoDeLinea = objetoSustituto.tabla.nextSibling;
            objetoSustituto.tabla.parentNode.removeChild(objetoSustituto.tabla);
            Examen.preguntas.splice(Examen.preguntas.indexOf(objetoSustituto), 1);
            saltoDeLinea.parentNode.removeChild(saltoDeLinea);

        })

        this.tabla.rows[0].cells[0].append(this.campoPeticion);

        this.tabla.rows[0].insertCell();

        this.tabla.rows[0].cells[1].align = "left";
        this.tabla.rows[0].cells[1].style.verticalAlign = "top";
        this.tabla.rows[0].cells[1].append(botonEliminarPregunta);
        this.tabla.rows[0].cells[1].style.paddingTop = "1%";

        //fila 2

        this.botonSubirArchivo = document.createElement("input");
        this.botonSubirArchivo.type = "file";
        this.botonSubirArchivo.disabled = true;

        this.botonesSubirArchivo = [];
        this.botonesSubirArchivo.push(this.botonSubirArchivo);

        this.tabla.rows[1].cells[0].append(this.botonSubirArchivo);
        
        //fila 3

        this.desplegablePorcentaje = document.createElement("select");

        var contadorPorcentaje;

        for (contadorPorcentaje = 1; contadorPorcentaje <= 100; contadorPorcentaje++) {

            var opcion = document.createElement("option");
            opcion.value = contadorPorcentaje;
            opcion.innerHTML = opcion.value;
            this.desplegablePorcentaje.append(opcion);

        }

        this.tabla.rows[2].cells[0].append(this.desplegablePorcentaje);

        return this.tabla;


    }

}