﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de ETipoPregunta
/// </summary>
/// 

[Table("tipos_pregunta", Schema="examenes")]
public class ETiposPregunta
{

    private string tipo;

    [Key]
    [Column("tipo")]
    public string Tipo { get => tipo; set => tipo = value; }

}