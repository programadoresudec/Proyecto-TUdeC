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
  

    public void Enviar(ESugerencia sugerencia)
    {
        
        db.TablaSugerencias.Add(sugerencia);
        db.SaveChanges();

    }

    public ESugerencia GetSugerencia(int id)
    {

        ESugerencia sugerencia = db.TablaSugerencias.Where(x => x.Id == id).FirstOrDefault();

        return sugerencia;

    }

    public List<ESugerencia> GetSugerencias()
    {

        List<ESugerencia> sugerencias = db.TablaSugerencias.ToList();

        return sugerencias;

    }

    public int GetCantidadSugerencias()
    {

        return db.TablaSugerencias.Count();

    }

 

}