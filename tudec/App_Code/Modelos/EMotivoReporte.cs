 
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
/// <summary>
/// Clase motivos de la tabla reportes
/// </summary>
[Table("motivos", Schema = "reportes")]
public class EMotivoReporte
{
    #region attributes
    private string motivo;
    private int diasxReporte;
    private int puntuacionxBloqueo;
    #endregion

    #region properties
    [Key]
    [Column("motivo")]
    public string Motivo { get => motivo; set => motivo = value; }

    [Column("dias_para_reportar")]
    public int DiasxReporte { get => diasxReporte; set => diasxReporte = value; }

    [Column("puntuacion_para_el_bloqueo")]
    public int PuntuacionxBloqueo { get => puntuacionxBloqueo; set => puntuacionxBloqueo = value; }
    #endregion
}