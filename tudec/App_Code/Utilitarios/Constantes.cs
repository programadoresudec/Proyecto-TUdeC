using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;



/// <summary>
/// Clase que tiene atributos constantes para el proyecto.
/// </summary>
public static class Constantes
{
    #region const attributes
    /// <summary>
    /// Constantes de estados en los atributos de algunas entidades.
    /// </summary>
    public const string ESTADO_EN_ESPERA = "espera de activacion";
    public const string ESTADO_CAMBIO_PASS = "change pass";
    public const string ESTADO_PK = "pk";
    public const string ESTADO_UNIQUE = "unique";
    public const string ESTADO_ACTIVO = "activo";
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
    /// <summary>
    /// Constantes De Session
    /// </summary>
    public const string USUARIO_LOGEADO = "usuarioLogeado";
    public const string USUARIO_ID = "usuarioId";
    public const string VALIDAR_TOKEN = "validarToken";
    
    #endregion
}