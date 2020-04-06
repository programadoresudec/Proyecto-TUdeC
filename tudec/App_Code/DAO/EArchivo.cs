using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EArchivo
/// </summary>
/// 

[Table("archivos", Schema="archivos")]
public class EArchivo
{

    private int id;
    private Nullable<int> idMensaje;
    private Nullable<int> idSugerencia;
    private Nullable<int> idComentario;
    private Nullable<int> idReporte;
    private Nullable<int> idTema;
    private string direccion;

    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_id_mensaje")]
    public int? IdMensaje { get => idMensaje; set => idMensaje = value; }
    [Column("fk_id_sugerencia")]
    public int? IdSugerencia { get => idSugerencia; set => idSugerencia = value; }
    [Column("fk_id_comentario")]
    public int? IdComentario { get => idComentario; set => idComentario = value; }
    [Column("fk_id_reporte")]
    public int? IdReporte { get => idReporte; set => idReporte = value; }
    [Column("fk_id_tema")]
    public int? IdTema { get => idTema; set => idTema = value; }
    [Column("direccion")]
    public string Direccion { get => direccion; set => direccion = value; }

}