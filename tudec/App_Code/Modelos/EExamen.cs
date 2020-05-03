using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EExamen
/// </summary>
/// 

[Table("examenes", Schema="examenes")]
public class EExamen
{

    #region attributes
    private int id;
    private int idTema;
    private DateTime fechaFin;
    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_id_tema")]
    public int IdTema { get => idTema; set => idTema = value; }
    [Column("fecha_fin")]
    public DateTime FechaFin { get => fechaFin; set => fechaFin = value; } 
    #endregion
}