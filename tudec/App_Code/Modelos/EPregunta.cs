using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EPregunta
/// </summary>
/// 

[Table("preguntas", Schema="examenes")]
public class EPregunta
{

    #region attributes
    private int id;
    private int idExamen;
    private string tipoPregunta;
    private string pregunta;
    private int porcentaje;

    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_id_examen")]
    public int IdExamen { get => idExamen; set => idExamen = value; }
    [Column("fk_tipo_pregunta")]
    public string TipoPregunta { get => tipoPregunta; set => tipoPregunta = value; }
    [Column("pregunta")]
    public string Pregunta { get => pregunta; set => pregunta = value; }
    [Column("porcentaje")]
    public int Porcentaje { get => porcentaje; set => porcentaje = value; }
    #endregion
}
