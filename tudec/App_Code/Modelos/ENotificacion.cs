using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

[Table("notificaciones", Schema = "notificaciones")]
public class ENotificacion
{

    #region attributes
    private int id;
    private string mensaje;
    private Boolean estado;
    private string nombreDeUsuario;
    private DateTime fecha;
    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("mensaje")]
    public string Mensaje { get => mensaje; set => mensaje = value; }
    [Column("estado")]
    public bool Estado { get => estado; set => estado = value; }
    [Column("fk_nombre_de_usuario")]
    public string NombreDeUsuario { get => nombreDeUsuario; set => nombreDeUsuario = value; }
    [Column("fecha")]
    public DateTime Fecha { get => fecha; set => fecha = value; }
    #endregion
}
