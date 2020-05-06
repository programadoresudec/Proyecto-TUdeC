using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

/// <summary>
/// Summary description for EReporte
/// </summary>
[Table("reportes", Schema = "reportes")]
public class EReporte
{
    private int id;
    private string nombreDeUsuarioDenunciante;
    private string nombreDeUsuarioDenunciado;
    private string motivoDelReporte;
    private int? idComentario;
    private int? idMensaje;
    private string descripcion;
    private bool estado;
    private List<string> imagenes;
    private DateTime fecha;
    private string comentario;
    private string mensaje;
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_nombre_de_usuario_denunciante")]
    public string NombreDeUsuarioDenunciante { get => nombreDeUsuarioDenunciante; set => nombreDeUsuarioDenunciante = value; }
    [Column("fk_nombre_de_usuario_denunciado")]
    public string NombreDeUsuarioDenunciado { get => nombreDeUsuarioDenunciado; set => nombreDeUsuarioDenunciado = value; }
    [Column("fk_motivo")]
    public string MotivoDelReporte { get => motivoDelReporte; set => motivoDelReporte = value; }
    [Column("fk_id_comentario")]
    public int? IdComentario { get => idComentario; set => idComentario = value; }
    [Column("fk_id_mensaje")]
    public int? IdMensaje { get => idMensaje; set => idMensaje = value; }
    [Column("descripcion")]
    public string Descripcion { get => descripcion; set => descripcion = value; }
    [Column("estado")]
    public bool Estado { get => estado; set => estado = value; }
    [Column("imagenes")]
    public List<string> Imagenes { get => imagenes; set => imagenes = value; }
    [Column("fecha")]
    public DateTime Fecha { get => fecha; set => fecha = value; }
    [NotMapped]
    public string Comentario { get => comentario; set => comentario = value; }
    [NotMapped]
    public string Mensaje { get => mensaje; set => mensaje = value; }
}