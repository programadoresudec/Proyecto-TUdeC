using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Constantes
/// </summary>
public static class Constantes
{
    #region const attributes
    public const string ESTADO_EN_ESPERA = "espera de activacion";
    public const string ESTADO_CAMBIO_PASS = "change pass";
    public const string ESTADO_PK = "pk";
    public const string ESTADO_UNIQUE = "unique";
    public const string ROL_ADMIN = "administrador";
    public const string ROL_USER = "usuario";
    public const string MENSAJE_VALIDAR_CUENTA = "Cuenta Exitosa.";
    public const string URL_VALIDAR_CUENTA = "/Vistas/Account/CuentaActivada.aspx?";
    public const string MENSAJE_CAMBIO_PASS = "Cambio De Contraseña";
    public const string URL_CAMBIO_PASS = "/Vistas/Account/ChangePassword.aspx?";
    public const string ESTADO_ACTIVO = "activo";
    public const string CORREO = "tudec2020@gmail.com";
    public const string PASSWORD = "programadoresudec2020";
    public const string CORREO_INSTITUCIONAL = "@ucundinamarca.edu.co";
    public const string VALIDAR_TOKEN = "validarToken";
    public const string USUARIOS_LOGEADOS = "usuarioLogeado";
    #endregion
}