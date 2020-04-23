using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de GestionExamen
/// </summary>
public class GestionExamen
{

    private Base db = new Base();


    public List<ETiposPregunta> GetTiposPregunta()
    {

        List<ETiposPregunta> tipos = db.TablaTiposPregunta.ToList();
        ETiposPregunta tipoDefecto = new ETiposPregunta();
        tipoDefecto.Tipo = "Tipo de pregunta";

        tipos.Insert(0, tipoDefecto);

        return tipos;

    }

}