using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EEjecucionExamen
/// </summary>
/// 

[Table("ejecucion_examen", Schema="examenes")]
public class EEjecucionExamen
{

    private int id;
    private string nombreUsuario;
    private int idExamen;
    private DateTime fechaEjecucion;
    private Nullable<int> calificacion;
    private string respuestas;

    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_nombre_de_usuario")]
    public string NombreUsuario { get => nombreUsuario; set => nombreUsuario = value; }
    [Column("fk_id_examen")]
    public int IdExamen { get => idExamen; set => idExamen = value; }
    [Column("fecha_de_ejecucion")]
    public DateTime FechaEjecucion { get => fechaEjecucion; set => fechaEjecucion = value; }
    [Column("calificacion")]
    public int? Calificacion { get => calificacion; set => calificacion = value; }
    [Column("respuestas")]
    public string Respuestas { get => respuestas; set => respuestas = value; }
}