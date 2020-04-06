﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de EArea
/// </summary>
///

[Table("areas", Schema="cursos")]
public class EArea
{

    private string area;
    private string icono;

    [Key]
    [Column("area")]
    public string Area { get => area; set => area = value; }

    [Column("icono")]
    public string Icono { get => icono; set => icono = value; }
}