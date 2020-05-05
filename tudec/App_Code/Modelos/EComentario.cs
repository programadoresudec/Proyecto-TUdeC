using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EComentario
/// </summary>
/// 

[Table("comentarios", Schema="comentarios")]
public class EComentario
{

    private int id;
    private string emisor;
    private Nullable<int> idCurso;
    private Nullable<int> idTema;
    private Nullable<int> idComentario;
    private string comentario;
    private DateTime fechaEnvio;
    private string imagenes;

    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_nombre_de_usuario_emisor")]
    public string Emisor { get => emisor; set => emisor = value; }
    [Column("fk_id_curso")]
    public int? IdCurso { get => idCurso; set => idCurso = value; }
    [Column("fk_id_tema")]
    public int? IdTema { get => idTema; set => idTema = value; }
    [Column("fk_id_comentario")]
    public int? IdComentario { get => idComentario; set => idComentario = value; }
    [Column("comentario")]
    public string Comentario { get => comentario; set => comentario = value; }
    [Column("fecha_envio")]
    public DateTime FechaEnvio { get => fechaEnvio; set => fechaEnvio = value; }
    [Column("imagenes")]
    public string Imagenes { get => imagenes; set => imagenes = value; }
}