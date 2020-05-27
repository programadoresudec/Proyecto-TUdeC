using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

/// <summary>
/// Summary description for EMensaje
/// </summary>
[Table("mensajes", Schema = "mensajes")]
public class EMensaje
{
    #region attributes
    private int id;
    private string nombreDeUsuarioEmisor;
    private string nombreDeUsuarioReceptor;
    private string contenido;
    private DateTime fecha;
    private int? idCurso;
    #endregion

    #region properties
    [Key]
    [Column("id")]
    public int Id { get => id; set => id = value; }
    [Column("fk_nombre_de_usuario_emisor")]
    public string NombreDeUsuarioEmisor { get => nombreDeUsuarioEmisor; set => nombreDeUsuarioEmisor = value; }
    [Column("fk_nombre_de_usuario_receptor")]
    public string NombreDeUsuarioReceptor { get => nombreDeUsuarioReceptor; set => nombreDeUsuarioReceptor = value; }
    [Column("contenido")]
    public string Contenido { get => contenido; set => contenido = value; }
    [Column("fecha")]
    public DateTime Fecha { get => fecha; set => fecha = value; }
    [Column("id_curso")]
    public int? IdCurso { get => idCurso; set => idCurso = value; }
    #endregion
}