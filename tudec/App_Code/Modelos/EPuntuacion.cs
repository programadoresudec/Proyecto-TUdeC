using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EPuntuacion
/// </summary>
/// 

[Table("puntuaciones", Schema="puntuaciones")]
public class EPuntuacion
{

    #region attributes
    private int id;
    private string emisor;
    private string receptor;
    private int puntuacion;
    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("emisor")]
    public string Emisor { get => emisor; set => emisor = value; }
    [Column("receptor")]
    public string Receptor { get => receptor; set => receptor = value; }
    [Column("puntuacion")]
    public int Puntuacion { get => puntuacion; set => puntuacion = value; } 
    #endregion
}