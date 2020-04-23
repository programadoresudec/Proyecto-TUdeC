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

    public List<ESugerencia> GetSugerencias(string filtro, string titulo)
    {

        bool estado;
        
        if(titulo == null)
        {

            titulo = "";

        }

        List<ESugerencia> sugerencias = null;

        if (filtro.Equals("Estado de lectura"))
        {

            sugerencias = db.TablaSugerencias.Where(x => titulo.Equals("") || x.Titulo.ToLower().Equals(titulo.ToLower())).ToList();

        }
        else
        {

            if (filtro.Equals("Leídos"))
            {
                estado = true;

            }
            else
            {

                estado = false;

            }

            if(titulo == "")
            {

                sugerencias = db.TablaSugerencias.Where(x => x.Estado == estado).ToList();

            }
            else
            {

                sugerencias = db.TablaSugerencias.Where(x => x.Titulo.ToLower().Equals(titulo.ToLower()) && x.Estado == estado).ToList();


            }


        }

        return sugerencias;

    }

    public List<string> GetTitulosSrc(string filtro, string titulo)
    {

        bool estado;

        if (titulo == null)
        {

            titulo = "";

        }

        List<ESugerencia> sugerencias = null;
        List<string> titulos = new List<string>();

        if (filtro.Equals("Estado de lectura"))
        {

            sugerencias = db.TablaSugerencias.Where(x => x.Titulo.ToLower().Contains(titulo.ToLower())).ToList();

        }
        else
        {

            if (filtro.Equals("Leídos"))
            {
                estado = true;

            }
            else
            {

                estado = false;

            }

            sugerencias = db.TablaSugerencias.Where(x => x.Titulo.ToLower().Contains(titulo.ToLower()) && x.Estado == estado).ToList();

        }

        foreach (ESugerencia sugerencia in sugerencias)
        {

            string tituloSugerencia = sugerencia.Titulo;
            titulos.Add(tituloSugerencia);

        }

        return titulos;

    }

    public int GetCantidadSugerencias()
    {

        return db.TablaSugerencias.Count();

    }

}