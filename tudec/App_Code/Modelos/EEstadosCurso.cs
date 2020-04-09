using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

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
