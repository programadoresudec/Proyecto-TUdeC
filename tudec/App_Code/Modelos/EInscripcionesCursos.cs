using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EInscripcionesCursos
/// </summary>
/// 

[Table("inscripciones_cursos", Schema="cursos")]
public class EInscripcionesCursos
{

    #region attributes
    private int id;
    private string nombreUsuario;
    private int idCurso;
    private DateTime fechaInscripcion;
    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_nombre_de_usuario")]
    public string NombreUsuario { get => nombreUsuario; set => nombreUsuario = value; }
    [Column("fk_id_curso")]
    public int IdCurso { get => idCurso; set => idCurso = value; }
    [Column("fecha_de_inscripcion")]
    public DateTime FechaInscripcion { get => fechaInscripcion; set => fechaInscripcion = value; } 
    #endregion

}