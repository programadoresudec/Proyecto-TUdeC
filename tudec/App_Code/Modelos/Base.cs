using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Base
/// </summary>
public class Base: DbContext
{
    public Base(): base("cadena"){}
    public DbSet<EArea> TablaAreas { get; set; }
    public DbSet<ECurso> TablaCursos { get; set; }
    public DbSet<EArchivo> TablaArchivos { get; set; }
    public DbSet<ESugerencia> TablaSugerencias { get; set; }
    public DbSet<EUsuario> TablaUsuarios { get; set; }
    public DbSet<EExamen> TablaExamenes { get; set; }
    public DbSet<ETema> TablaTemas { get; set; }
    public DbSet<EEstadosCurso> TablaEstados { get; set; }
    public DbSet<EInscripcionesCursos> TablaInscripciones { get; set; }
    public DbSet<EAutentication> TablaAutenticaciones { get; set; }
}