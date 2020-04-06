using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Sugerencia
/// </summary>
public class Sugerencia: Base
{
    public Sugerencia()
    {
        
    }

    DbSet<EArchivo> TablaArchivos { get; set; }
    DbSet<ESugerencia> TablaSugerencias { get; set; }

    public void AlmacenarImagen(EArchivo archivo)
    {

        TablaArchivos.Add(archivo);
        SaveChanges();

    }

    public void Enviar(ESugerencia sugerencia)
    {

        TablaSugerencias.Add(sugerencia);
        SaveChanges();

    }

    public List<ESugerencia> GetSugerencias()
    {

        List<ESugerencia> sugerencias = TablaSugerencias.ToList();

        return sugerencias;

    }

    public int GetCantidadImagenes(EUsuario usuario)
    {

        List<ESugerencia> sugerencias = TablaSugerencias.Where(x => x.Emisor.Equals(usuario.NombreDeUsuario)).ToList();

        int cantidad = 0;

        foreach(ESugerencia sugerencia in sugerencias)
        {

            cantidad += TablaArchivos.Where(x => x.IdSugerencia == sugerencia.Id).Count();

        }

        return cantidad;

    }

}