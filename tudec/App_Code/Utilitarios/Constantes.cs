﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Clase que tiene atributos constantes para el proyecto.
/// </summary>
public static class Constantes
{
    #region const attributes
    #region Constantes de estados
    /// <summary>
    /// Constantes de estados en los atributos de algunas entidades.
    /// </summary>
    public const string ESTADO_EN_ESPERA = "espera de activacion";
    public const string ESTADO_BLOQUEADO = "bloqueado";
    public const string ESTADO_REPORTADO = "reportado";
    public const string ESTADO_CAMBIO_PASS = "change pass";
    public const string ESTADO_PK = "pk";
    public const string ESTADO_UNIQUE = "unique";
    public const string ESTADO_ACTIVO = "activo"; 
    #endregion
    #region Constantes Del Proyecto
    /// <summary>
    /// Constantes para el proyecto.
    /// </summary>
    public const string MENSAJE_VALIDAR_CUENTA = "Cuenta Exitosa.";
    public const string URL_VALIDAR_CUENTA = "/Vistas/Account/CuentaActivada.aspx?";
    public const string MENSAJE_CAMBIO_PASS = "Cambio De Contraseña";
    public const string URL_CAMBIO_PASS = "/Vistas/Account/ChangePassword.aspx?";
    public const string CORREO = "tudec2020@gmail.com";
    public const string PASSWORD = "programadoresudec2020";
    public const string CORREO_INSTITUCIONAL = "@ucundinamarca.edu.co";
    public const string ROL_ADMIN = "administrador";
    public const string ROL_USER = "usuario";
    public const string IMAGEN_DEFAULT = "~/Recursos/Imagenes/PerfilUsuarios/DefaultUsuario.jpg";
    public const string LOCATION_IMAGEN_PERFIL = "~/Recursos/Imagenes/PerfilUsuarios/";
    public const string MOTIVO_1 = "Groserias";
    public const string MOTIVO_2 = "Ofensas al usuario";
    public const string SUGERENCIAS_ENVIADAS = "~/Recursos/Imagenes/SugerenciasEnviadas/";
    public const string MOTIVO_3 = "SPAM";
    public const string MOTIVO_4 = "Contenido +18";
    public const string MOTIVO_5 = "Ofender Grupo";
    public const int PUNTUACION_MAXIMA_PARA_SER_BLOQUEADO = 20;
    public const int LONGITUD_CODIGO = 6;
    public const string MANUAL = "../Manual/Manual de Usuario.pdf";
    #endregion
    #region Constantes De SESSION
    /// <summary>
    /// Constantes De Session
    /// </summary>
    public const string USUARIO_LOGEADO = "usuarioLogeado";
    public const string USUARIO_SELECCIONADO = "usuarioSeleccionado";
    public const string USUARIO_SELECCIONADO_CHAT = "usuarioSeleccionadoChat";
    public const string CURSO_SELECCIONADO = "cursoSeleccionado";
    public const string CURSO_SELECCIONADO_PARA_EDITAR = "cursoSeleccionadoParaEditar";
    public const string CURSO_SELECCIONADO_PARA_EDITAR_TEMAS = "cursoSeleccionadoParaEditarTemas";
    public const string CURSO_SELECCIONADO_PARA_EXPULSAR_ALUMNOS = "cursoSeleccionadoParaExpulsarAlumnos";
    public const string CURSO_SELECCIONADO_PARA_VER_NOTAS = "cursoSeleccionadoParaVerNotas";
    public const string CURSO_SELECCIONADO_PARA_CHAT = "cursoSeleccionadoParaChat";
    public const string CURSO_SELECCIONADO_PARA_CALIFICAR_EXAMEN = "cursoSeleccionadoParaCalificarExamen";
    public const string TEMA_CREADO = "temaCreado";
    public const string NOTIFICACIONES = "notificacionesUsuario";
    public const string TEMA_SELECCIONADO = "temaSeleccionado";
    public const string TEMA_SELECCIONADO_PARA_CALIFICAR_EXAMEN = "temaSeleccionadoParaCalificarExamen";
    public const string USUARIO_ID = "usuarioId";
    public const string VALIDAR_TOKEN = "validarToken";
    public const string EXAMEN_A_REALIZAR = "examenARealizar";
    public const string USUARIO_CON_REPORTES = "usuarioConReportes";
    public const string CALIFICACION_EXAMEN = "calificacionExamen";
    #endregion
    #endregion
 
}