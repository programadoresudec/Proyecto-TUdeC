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
    public Base(): base("cadena")
    {
        
    }
}