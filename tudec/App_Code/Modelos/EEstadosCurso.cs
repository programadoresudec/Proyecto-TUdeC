﻿
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


/// <summary>
/// Descripción breve de EEstadosCurso
/// </summary>
/// 

[Table("estados_curso", Schema="cursos")]
public class EEstadosCurso
{

    #region attributes
    private string estado;
    #endregion

    #region properties
    [Key]
    [Column("estado")]
    public string Estado { get => estado; set => estado = value; }
    #endregion
}
