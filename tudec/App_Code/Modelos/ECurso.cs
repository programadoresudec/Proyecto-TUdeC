using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de ECurso
/// </summary>
/// 

[Serializable]
[Table("cursos", Schema="cursos")]
public class ECurso
{

    #region attributes
    private int id;
    private string creador;
    private string area;
    private string estado;
    private string nombre;
    private DateTime fechaCreacion;
    private DateTime fechaInicio;
    private string codigoInscripcion;
    private Nullable<int> puntuacion;
    private string descripcion;
    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_creador")]
    public string Creador { get => creador; set => creador = value; }
    [Column("fk_area")]
    public string Area { get => area; set => area = value; }
    [Column("fk_estado")]
    public string Estado { get => estado; set => estado = value; }
    [Column("nombre")]
    public string Nombre { get => nombre; set => nombre = value; }
    [Column("fecha_de_creacion")]
    public DateTime FechaCreacion { get => fechaCreacion; set => fechaCreacion = value; }
    [Column("fecha_de_inicio")]
    public DateTime FechaInicio { get => fechaInicio; set => fechaInicio = value; }
    [Column("codigo_inscripcion")]
    public string CodigoInscripcion { get => codigoInscripcion; set => codigoInscripcion = value; }
    [Column("puntuacion")]
    public int? Puntuacion { get => puntuacion; set => puntuacion = value; }
    [Column("descripcion")]
    public string Descripcion { get => descripcion; set => descripcion = value; }
    #endregion

}