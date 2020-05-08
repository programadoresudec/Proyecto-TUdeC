using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EUsuario
/// </summary>
/// 

[Serializable]
[Table("usuarios", Schema = "usuarios")]
public class EUsuario
{
    #region attributes
    private string nombreDeUsuario;
    private string rol;
    private string estado;
    private string primerNombre;
    private string segundoNombre;
    private string primerApellido;
    private string segundoApellido;
    private string correoInstitucional;
    private string pass;
    private DateTime fechaCreacion;
    private Nullable<DateTime> fechaDesbloqueo;
    private Nullable<int> puntuacion;
    private string token;
    private Nullable<DateTime> vencimientoToken;
    private string session;
    private string imagenPerfil;
    private Nullable<DateTime> lastModify;
    private int numCursos;
    private string descripcion;
    private int? puntuacionDeBloqueo;
    private int numeroDeReportes;
    #endregion

    #region properties
    [Key]
    [Column("nombre_de_usuario")]
    public string NombreDeUsuario { get => nombreDeUsuario; set => nombreDeUsuario = value; }
    [Column("fk_rol")]
    public string Rol { get => rol; set => rol = value; }
    [Column("fk_estado")]
    public string Estado { get => estado; set => estado = value; }
    [Column("primer_nombre")]
    public string PrimerNombre { get => primerNombre; set => primerNombre = value; }
    [Column("segundo_nombre")]
    public string SegundoNombre { get => segundoNombre; set => segundoNombre = value; }
    [Column("primer_apellido")]
    public string PrimerApellido { get => primerApellido; set => primerApellido = value; }
    [Column("segundo_apellido")]
    public string SegundoApellido { get => segundoApellido; set => segundoApellido = value; }
    [Column("correo_institucional")]
    public string CorreoInstitucional { get => correoInstitucional; set => correoInstitucional = value; }
    [Column("pass")]
    public string Pass { get => pass; set => pass = value; }
    [Column("fecha_creacion")]
    public DateTime FechaCreacion { get => fechaCreacion; set => fechaCreacion = value; }
    [Column("fecha_desbloqueo")]
    public DateTime? FechaDesbloqueo { get => fechaDesbloqueo; set => fechaDesbloqueo = value; }
    [Column("puntuacion")]
    public int? Puntuacion { get => puntuacion; set => puntuacion = value; }
    [Column("token")]
    public string Token { get => token; set => token = value; }
    [Column("imagen_perfil")]
    public string ImagenPerfil { get => imagenPerfil; set => imagenPerfil = value; }
    [Column("vencimiento_token")]
    public DateTime? VencimientoToken { get => vencimientoToken; set => vencimientoToken = value; }
    [Column("session")]
    public string Session { get => session; set => session = value; }
    [Column("ultima_modificacion")]
    public DateTime? LastModify { get => lastModify; set => lastModify = value; }
    [Column("descripcion")]
    public string Descripcion { get => descripcion; set => descripcion = value; }
    [Column("puntuacion_bloqueo")]
    public int? PuntuacionDeBloqueo { get => puntuacionDeBloqueo; set => puntuacionDeBloqueo = value; }
    [NotMapped]
    public int NumCursos { get => numCursos; set => numCursos = value; }
    [NotMapped]
    public int NumeroDeReportes { get => numeroDeReportes; set => numeroDeReportes = value; }
    #endregion
}