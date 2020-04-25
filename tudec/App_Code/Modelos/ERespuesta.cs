using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de ERespuesta
/// </summary>
/// 

[Table("respuestas", Schema="examenes")]
public class ERespuesta
{

    private int id;
    private int idPregunta;
    private string respuesta;
    private bool estado;

    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_id_preguntas")]
    public int IdPregunta { get => idPregunta; set => idPregunta = value; }
    [Column("respuesta")]
    public string Respuesta { get => respuesta; set => respuesta = value; }
    [Column("estado")]
    public bool Estado { get => estado; set => estado = value; }

}