using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


/// <summary>
/// Summary description for EAutentication
/// </summary>

[Serializable]
[Table("autentication", Schema = "seguridad")]
public class EAutentication
{
    #region attributes
    private int id;
    private string nombreDeUsuario;
    private string ip;
    private string mac;
    private DateTime fechaInicio;
    private Nullable<DateTime> fechaFin;
    private string session;
    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("nombre_de_usuario")]
    public string NombreDeUsuario { get => nombreDeUsuario; set => nombreDeUsuario = value; }
    [Column("ip")]
    public string Ip { get => ip; set => ip = value; }
    [Column("mac")]
    public string Mac { get => mac; set => mac = value; }
    [Column("fecha_inicio")]
    public DateTime FechaInicio { get => fechaInicio; set => fechaInicio = value; }
    [Column("fecha_fin")]
    public DateTime? FechaFin { get => fechaFin; set => fechaFin = value; }
    [Column("session")]
    public string Session { get => session; set => session = value; }
    #endregion
}