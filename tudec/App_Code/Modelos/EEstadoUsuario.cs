
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
/// <summary>
/// Summary description for EEstadoUsuario
/// </summary>
[Table("estados_usuario", Schema = "usuarios")]
public class EEstadoUsuario
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