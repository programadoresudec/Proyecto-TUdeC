using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de ETema
/// </summary>
/// 

[Serializable]
[Table("temas", Schema="temas")]
public class ETema
{
    #region attributes
    private int id;
    private int idCurso;
    private string titulo;
    private string informacion;
    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_id_curso")]
    public int IdCurso { get => idCurso; set => idCurso = value; }
    [Column("titulo")]
    public string Titulo { get => titulo; set => titulo = value; }
    [Column("informacion")]
    public string Informacion { get => informacion; set => informacion = value; }
} 
#endregion