using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EExamen
/// </summary>
/// 

[Table("examenes", Schema="examenes")]
public class EExamen
{

    private int id;
    private int idTema;
    private DateTime fechaInicion;
    private DateTime fechaFin;

    public int Id { get => id; set => id = value; }
    public int IdTema { get => idTema; set => idTema = value; }
    public DateTime FechaInicion { get => fechaInicion; set => fechaInicion = value; }
    public DateTime FechaFin { get => fechaFin; set => fechaFin = value; }
}