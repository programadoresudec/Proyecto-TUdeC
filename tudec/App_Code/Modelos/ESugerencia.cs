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

    #region attributes
    private int id;
    private string titulo;
    private string emisor;
    private string contenido;
    private bool estado;
    private List<string> imagenes;
    private string imagenesJson;
    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("titulo")]
    public string Titulo { get => titulo; set => titulo = value; }
    [Column("fk_nombre_de_usuario_emisor")]
    public string Emisor { get => emisor; set => emisor = value; }
    [Column("contenido")]
    public string Contenido { get => contenido; set => contenido = value; }
    [Column("estado")]
    public bool Estado { get => estado; set => estado = value; }
    [NotMapped]
    public List<string> Imagenes { get => imagenes; set => imagenes = value; }
    [Column("imagenes")]
    public string ImagenesJson { get => imagenesJson; set => imagenesJson = value; }

    #endregion
}