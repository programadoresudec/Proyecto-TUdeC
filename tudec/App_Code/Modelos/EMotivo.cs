 
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
/// <summary>
/// Clase motivos de la tabla reportes
/// </summary>
[Table("motivos", Schema = "reportes")]
public class EMotivoReporte
{
    #region attributes
    private string motivoDelReporte;
    #endregion
    #region properties
    [Key]
    [Column("motivo")]
    public string MotivoDelReporte { get => MotivoDelReporte; set => MotivoDelReporte = value; }
    #endregion
}