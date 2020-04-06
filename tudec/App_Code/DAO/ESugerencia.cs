using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de ESugerencia
/// </summary>
/// 

[Table("sugerencias", Schema="sugerencias")]
public class ESugerencia
{

    private int id;
    private string emisor;
    private string contenido;
    private bool estado;

    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_nombre_de_usuario_emisor")]
    public string Emisor { get => emisor; set => emisor = value; }
    [Column("contenido")]
    public string Contenido { get => contenido; set => contenido = value; }
    [Column("estado")]
    public bool Estado { get => estado; set => estado = value; }
}