using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de Sugerencia
/// </summary>
public class Sugerencia
{
    private Base db = new Base();
    public void AlmacenarImagen(EArchivo archivo)
    {

        db.TablaArchivos.Add(archivo);
        db.SaveChanges();

    }

    public void Enviar(ESugerencia sugerencia)
    {

        db.TablaSugerencias.Add(sugerencia);
        db.SaveChanges();

    }

    public List<ESugerencia> GetSugerencias()
    {

        List<ESugerencia> sugerencias = db.TablaSugerencias.ToList();

        return sugerencias;

    }

    public int GetCantidadSugerencias()
    {

        return db.TablaArchivos.Count();

    }

    public int GetCantidadUsuariosAnonimos()
    {

        //int cantidad = 0;

        //List<ESugerencia> sugerencias = db.TablaSugerencias.Where(x => x.Emisor == null).ToList();
        return 0;

    }

    public int GetCantidadImagenes(EUsuario usuario)
    {

        List<ESugerencia> sugerencias = db.TablaSugerencias.Where(x => x.Emisor.Equals(usuario.NombreDeUsuario)).ToList();

        int cantidad = 0;

        foreach (ESugerencia sugerencia in sugerencias)
        {
            cantidad += db.TablaArchivos.Where(x => x.IdSugerencia == sugerencia.Id).Count();
        }
        return cantidad;
    }
}