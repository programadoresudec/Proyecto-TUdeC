using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


/// <summary>
/// Descripción breve de EArea
/// </summary>
///

[Table("areas", Schema = "cursos")]
public class EArea
{

    #region attributes
    private string area;
    private string icono;
    #endregion

    #region properties
    [Key]
    [Column("area")]
    public string Area { get => area; set => area = value; }

    [Column("icono")]
    public string Icono { get => icono; set => icono = value; }
    #endregion
}